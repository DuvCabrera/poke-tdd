import '../entites/entities.dart';

abstract class RequestKanto {
  Future<List<PokeTag>> get();
}
