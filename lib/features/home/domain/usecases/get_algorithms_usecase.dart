import '../repository/algorithm_repository.dart';
import '../entities/algorithm_entity.dart';

class GetAlgorithmsUseCase {
  final AlgorithmRepository repository;

  GetAlgorithmsUseCase(this.repository);

  Future<List<AlgorithmEntity>> call() async {
    return repository.getAllAlgorithms();
  }
}
