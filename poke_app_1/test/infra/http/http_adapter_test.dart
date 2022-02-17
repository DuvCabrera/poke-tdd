import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:http/http.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);
  @override
  Future<List<Map>> request(String url) async {
    final response = await client.get(Uri.parse(url));
    return (jsonDecode(response.body) as List)
        .map((map) => map as Map<String, dynamic>)
        .toList();
  }
}

@GenerateMocks([Client])
void main() {
  late Client client;
  late HttpAdapter sut;
  late String url;

  PostExpectation mockRequest() {
    return when(client.get(Uri.parse(url)));
  }

  void mockResponseSucces() {
    mockRequest().thenAnswer((_) async => Response(
        '[{"name": "poke", "url":"url"},{"name": "poke", "url":"url"}]', 200));
  }

  setUp(() {
    url = faker.internet.httpUrl();
    client = MockClient();
    sut = HttpAdapter(client);
    mockResponseSucces();
  });

  test('should call get with correct value', () async {
    await sut.request(url);

    verify(client.get(Uri.parse(url)));
  });

  test('get should return List<Map> when success', () async {
    final result = await sut.request(url);

    expect(result, isA<List<Map>>());
  });
}
