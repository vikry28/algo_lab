class BadgeEntity {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final int color;
  final bool isUnlocked;
  final int requiredXP;

  const BadgeEntity({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.requiredXP,
  });
}
