// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
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
}
