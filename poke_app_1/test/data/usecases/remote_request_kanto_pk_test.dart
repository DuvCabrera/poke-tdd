import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:poke_app_1/data/http/http.dart';
import 'package:poke_app_1/data/usecases/usecases.dart';
import 'package:poke_app_1/domain/entites/entities.dart';
import 'package:poke_app_1/domain/helpers/helpers.dart';

import 'remote_request_kanto_pk_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late HttpClient client;
  late RemoteRequestKantoPk sut;
  late String url;

  PostExpectation mockRequest() => when(client.request(url));
  void mockResponseSucces() {
    mockRequest().thenAnswer((_) async => [
          {'name': 'pickachu', 'url': url}
        ]);
  }

  void mockResponseError() {
    mockRequest().thenAnswer((_) async => [{}]);
  }

  void mockResponseTrow(error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    client = MockHttpClient();
    sut = RemoteRequestKantoPk(httpClient: client, url: url);
    mockResponseSucces();
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
    mockResponseTrow(HttpError.badRequest);
    final future = sut.get();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should return an DomainError when invalidData ', () async {
    mockResponseError();
    final future = sut.get();

    expect(future, throwsA(DomainError.unexpected));
  });
}
