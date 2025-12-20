class ArrayItem {
  int value;
  final int? id;

  ArrayItem({required this.value, this.id});

  ArrayItem copyWith({int? value, int? id}) {
    return ArrayItem(value: value ?? this.value, id: id ?? this.id);
  }
}
