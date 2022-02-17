import '../../domain/entites/entities.dart';

import '../http/http.dart';

class RemotePokeTag implements PokeTag {
  @override
  final String name;
  @override
  final String url;

  RemotePokeTag({required this.name, required this.url});

  factory RemotePokeTag.fromJson(Map json) {
    if (!json.containsKey('name') && !json.containsKey('url')) {
      throw HttpError.invalidData;
    }
    return RemotePokeTag(name: json['name'], url: json['url']);
  }

  PokeTag toEntity() {
    return PokeTag(name: name, url: url);
  }
}
