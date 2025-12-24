class LanguageOption {
  final String code; // "en", "id", dll
  final String label; // "English", "Bahasa"
  final String flagEmoji; // 🇺🇸, 🇮🇩

  const LanguageOption({
    required this.code,
    required this.label,
    required this.flagEmoji,
  });
}
