import 'learning_entity.dart';

class LearningCategoryEntity {
  final String id;
  final String title;
  final List<LearningEntity> items;

  const LearningCategoryEntity({
    required this.id,
    required this.title,
    required this.items,
  });
}
