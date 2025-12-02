// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class Item {
  int itemid;
  String name;
  String recipe;
  double cost;
  bool isDeleted;
  Uint8List? image;

  Item({
    required this.name,
    required this.itemid,
    required this.recipe,
    required this.cost,
    required this.isDeleted,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'recipe': recipe,
      'cost': cost,
      'image': image == null
          ? null
          : base64Encode(
              image!), // image is null if not provided, no need to handle separately
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    print('weee2');
    return Item(
      itemid: map['itemid'],
      name: map['name'] as String,
      recipe: map['recipe'] as String,
      cost: double.parse(map['cost'].toString()),
      isDeleted: map['isdeleted'] as bool,
      image: map['image'] != null ? base64Decode(map['image']) : null,
    );
  }

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.name == name &&
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

class ItemQuantity {
  int itemid;
  int quantity;
  String name;
  String recipe;
  double cost;
  bool isDeleted;
  Uint8List? image;

  ItemQuantity({
    required this.name,
    required this.quantity,
    required this.itemid,
    required this.recipe,
    required this.cost,
    required this.isDeleted,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'recipe': recipe,
      'cost': cost,
      'image': image == null ? null : base64Encode(image!),
    };
  }

  factory ItemQuantity.fromMap(Map<String, dynamic> map) {
    return ItemQuantity(
      quantity: map['quantity'],
      itemid: map['itemid'],
      name: map['name'] as String,
      recipe: map['recipe'] as String,
      cost: double.parse(map['cost'].toString()),
      isDeleted: map['isdeleted'] as bool,
      image: map['image'] != null ? base64Decode(map['image']) : null,
    );
  }

  factory ItemQuantity.fromJson(String source) =>
      ItemQuantity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant ItemQuantity other) {
    if (identical(this, other)) return true;

    return other.itemid == itemid &&
        other.quantity == quantity &&
        other.name == name &&
        other.recipe == recipe &&
        other.cost == cost &&
        other.isDeleted == isDeleted &&
        other.image == image;
  }

  @override
  int get hashCode {
    return itemid.hashCode ^
        quantity.hashCode ^
        name.hashCode ^
        recipe.hashCode ^
        cost.hashCode ^
        isDeleted.hashCode ^
        image.hashCode;
  }
}
