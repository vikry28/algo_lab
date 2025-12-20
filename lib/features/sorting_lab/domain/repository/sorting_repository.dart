import '../entities/array_item.dart';

abstract class SortingRepository {
  Future<List<ArrayItem>> generate({int length = 8, int max = 100});
}
