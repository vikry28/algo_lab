import '../entities/learning_entity.dart';
import '../repository/learning_repository.dart';

class GetLearningItems {
  final LearningRepository repository;

  GetLearningItems(this.repository);

  Future<List<LearningEntity>> call() async {
    return await repository.getLearningItems();
  }
}
