import '../../domain/entities/learning_entity.dart';

class LearningModel extends LearningEntity {
  LearningModel({
    required super.id,
    required super.title,
    super.hasCode,
    super.hasPlay,
    super.hasLink,
    super.description,
  });

  factory LearningModel.fromJson(Map<String, dynamic> json) {
    return LearningModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      hasCode: json['hasCode'] ?? false,
      hasPlay: json['hasPlay'] ?? false,
      hasLink: json['hasLink'] ?? false,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hasCode': hasCode,
      'hasPlay': hasPlay,
      'hasLink': hasLink,
      'description': description,
    };
  }
}
