import '../../domain/entities/algorithm_entity.dart';

class AlgorithmModel {
  final String titleKey;
  final String descriptionKey;
  final Map<String, String> title;
  final Map<String, String> description;
  final String icon;
  final String colorHex;

  AlgorithmModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.title,
    required this.description,
    required this.icon,
    required this.colorHex,
  });

  // helper untuk ambil bahasa aktif
  String getTitle(String languageCode) => title[languageCode] ?? title['en']!;
  String getDescription(String languageCode) =>
      description[languageCode] ?? description['en']!;
  AlgorithmEntity toEntity() {
    return AlgorithmEntity(
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      title: title,
      description: description,
      icon: icon,
      colorHex: colorHex,
    );
  }
}
