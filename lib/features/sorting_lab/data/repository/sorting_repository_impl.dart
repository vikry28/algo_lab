import '../../domain/entities/array_item.dart';
import '../../domain/repository/sorting_repository.dart';
import '../datasources/sorting_local_datasource.dart';

class SortingRepositoryImpl implements SortingRepository {
  final SortingLocalDatasource local;
  SortingRepositoryImpl(this.local);

  @override
  Future<List<ArrayItem>> generate({int length = 8, int max = 100}) async {
    final list = local.generateRandom(length: length, max: max);
    return List.generate(list.length, (i) => ArrayItem(value: list[i], id: i));
  }
}
