import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app_1/domain/entites/entities.dart';
import 'package:poke_app_1/domain/usecases/usecases.dart';

import 'remote_request_kanto_pk_test.mocks.dart';

class RemoteRequestKantoPk implements RequestKanto {
  final HttpClient httpClient;
  final String url;

  RemoteRequestKantoPk({required this.httpClient, required this.url});

  @override
  Future<List<PokeTag>> get() async {
    return await httpClient.request(url);
  }
}

abstract class HttpClient {
  Future<Map> request(String url);
}

@GenerateMocks([HttpClient])
void main() {
  late HttpClient client;
  late RemoteRequestKantoPk sut;
  late String url;

  PostExpectation mockRequest() => when(client.request(url));
  void mockResponse() {
    mockRequest().thenAnswer((_) async => {'poke': 'pickachu'});
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
}
