import '../../domain/entities/algorithm_entity.dart';

class AlgorithmModel {
  final Map<String, String> title; // 'id': 'Bubble Sort', 'en': 'Bubble Sort'
  final Map<String, String>
  description; // 'id': 'Sorting sederhana', 'en': 'Simple sorting'
  final String icon;
  final String colorHex;

  AlgorithmModel({
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
      title: title,
      description: description,
      icon: icon,
      colorHex: colorHex,
    );
  }
}
