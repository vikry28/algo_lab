class AlgorithmEntity {
  final Map<String, String> title;
  final Map<String, String> description;
  final String icon;
  final String colorHex;

  AlgorithmEntity({
    required this.title,
    required this.description,
    required this.icon,
    required this.colorHex,
  });

  // Optional helper
  String getTitle(String langCode) => title[langCode] ?? title['en']!;
  String getDescription(String langCode) =>
      description[langCode] ?? description['en']!;
}
