import '../../data/models/models.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/entites/entities.dart';
import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteRequestKantoPk implements RequestKanto {
  final HttpClient httpClient;
  final String url;

  RemoteRequestKantoPk({required this.httpClient, required this.url});

  @override
  Future<List<PokeTag>> get() async {
    try {
      final response = await httpClient.request(url);
      return response
          .map((map) => RemotePokeTag.fromJson(map).toEntity())
          .toList();
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}
