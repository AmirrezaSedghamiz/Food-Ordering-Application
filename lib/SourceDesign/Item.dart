// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

class Item {
  int itemId;
  String name;
  String recipe;
  double cost;
  bool isDeleted;
  Uint8List? image;
  
  Item({
    required this.itemId,
    required this.name,
    required this.recipe,
    required this.cost,
    required this.isDeleted,
    this.image,
  });


  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemId: map['itemid'] as int,
      name: map['name'] as String,
      recipe: map['recipe'] as String,
      cost: map['cost'] as double,
      isDeleted: map['isdeleted'] as bool,
      image: map['image'] != null ? base64Decode(map['image']) : null,
    );
  }


  factory Item.fromJson(String source) => Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
