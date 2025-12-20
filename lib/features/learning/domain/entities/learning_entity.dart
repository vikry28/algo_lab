class LearningEntity {
  final String id;
  final String title;
  final bool hasCode;
  final bool hasPlay;
  final bool hasLink;
  final String description;

  const LearningEntity({
    required this.id,
    required this.title,
    this.hasCode = false,
    this.hasPlay = false,
    this.hasLink = false,
    this.description = '',
  });
}
