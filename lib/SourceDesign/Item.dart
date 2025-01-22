// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class Item {
  String name;
  String recipe;
  double cost;
  bool isDeleted;
  Uint8List? image;
  
  Item({
    required this.name,
    required this.recipe,
    required this.cost,
    required this.isDeleted,
    this.image,
  });

  Future<Map<String, dynamic>> toJson() async {
    return {
      'name': name,
      'recipe': recipe,
      'cost': cost,
      'image': image == null ? null : base64Encode(image!), // image is null if not provided, no need to handle separately
    };
  }


  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] as String,
      recipe: map['recipe'] as String,
      cost: map['cost'] as double,
      isDeleted: map['isdeleted'] as bool,
      image: map['image'] != null ? base64Decode(map['image']) : null,
    );
  }


  factory Item.fromJson(String source) => Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.recipe == recipe &&
      other.cost == cost &&
      other.isDeleted == isDeleted &&
      other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      recipe.hashCode ^
      cost.hashCode ^
      isDeleted.hashCode ^
      image.hashCode;
  }
}
