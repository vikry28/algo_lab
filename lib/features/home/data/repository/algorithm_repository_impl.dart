import '../datasources/algorithm_local_datasource.dart';
import '../../domain/entities/algorithm_entity.dart';
import '../../domain/repository/algorithm_repository.dart';

class AlgorithmRepositoryImpl implements AlgorithmRepository {
  final AlgorithmLocalDataSource localDataSource;

  AlgorithmRepositoryImpl({required this.localDataSource});

  @override
  Future<List<AlgorithmEntity>> getAllAlgorithms() async {
    final models = await localDataSource.getAlgorithms();
    return models.map((model) => model.toEntity()).toList();
  }
}
