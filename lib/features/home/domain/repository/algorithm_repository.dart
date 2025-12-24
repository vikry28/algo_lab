import '../entities/algorithm_entity.dart';

abstract class AlgorithmRepository {
  Future<List<AlgorithmEntity>> getAllAlgorithms();
}
