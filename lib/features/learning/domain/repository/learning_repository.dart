import '../entities/learning_entity.dart';

abstract class LearningRepository {
  Future<List<LearningEntity>> getLearningItems();
}
