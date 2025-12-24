import '../../domain/entities/array_item.dart';

class ArrayItemModel extends ArrayItem {
  ArrayItemModel({required super.value, super.id});

  factory ArrayItemModel.fromJson(Map<String, dynamic> json) =>
      ArrayItemModel(value: json['value'] as int, id: json['id'] as int?);

  Map<String, dynamic> toJson() => {'id': id, 'value': value};
}
