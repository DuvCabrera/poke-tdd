import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app_1/domain/entites/entities.dart';
import 'package:poke_app_1/domain/helpers/domain_error.dart';
import 'package:poke_app_1/domain/usecases/usecases.dart';

import 'remote_request_kanto_pk_test.mocks.dart';

enum HttpError {
  badRequest,
  notFound,
}

class RemotePokeTag implements PokeTag {
  @override
  final String name;
  @override
  final String url;

  RemotePokeTag({required this.name, required this.url});

  factory RemotePokeTag.fromJson(Map json) {
    return RemotePokeTag(name: json['name'], url: json['url']);
  }
}

class RemoteRequestKantoPk implements RequestKanto {
  final HttpClient httpClient;
  final String url;

  RemoteRequestKantoPk({required this.httpClient, required this.url});

  @override
  Future<List<PokeTag>> get() async {
    try {
      final response = await httpClient.request(url);
      List<PokeTag> listPk = [];
      for (var map in response) {
        listPk.add(RemotePokeTag.fromJson(map));
      }
      return listPk;
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}

abstract class HttpClient {
  Future<List<Map>> request(String url);
}

@GenerateMocks([HttpClient])
void main() {
  late HttpClient client;
  late RemoteRequestKantoPk sut;
  late String url;

  PostExpectation mockRequest() => when(client.request(url));
  void mockResponse() {
    mockRequest().thenAnswer((_) async => [
          {'name': 'pickachu', 'url': url}
        ]);
  }

  void mockResponseError(error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    client = MockHttpClient();
    sut = RemoteRequestKantoPk(httpClient: client, url: url);
    mockResponse();
  });

  test('RemoteRequestKantoPk must call the correct arguments', () async {
    await sut.get();

    verify(client.request(url));
  });

  test('RemoteRequestKantoPk must return List<PokeTag>', () async {
    final response = await sut.get();

    expect(response, isA<List<PokeTag>>());
  });

  test('should return an DomainError when 400 ', () async {
    mockResponseError(HttpError.badRequest);
    final future = sut.get();

    expect(future, throwsA(DomainError.unexpected));
  });
}
