class AlgorithmEntity {
  final String titleKey;
  final String descriptionKey;
  final Map<String, String> title;
  final Map<String, String> description;
  final String icon;
  final String colorHex;
  final String category;

  AlgorithmEntity({
    required this.titleKey,
    required this.descriptionKey,
    required this.title,
    required this.description,
    required this.icon,
    required this.colorHex,
    required this.category,
  });

  // Optional helper
  String getTitle(String langCode) => title[langCode] ?? title['en']!;
  String getDescription(String langCode) =>
      description[langCode] ?? description['en']!;
}
