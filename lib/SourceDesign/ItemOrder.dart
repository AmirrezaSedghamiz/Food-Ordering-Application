// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_base_project/SourceDesign/Item.dart';
import 'package:data_base_project/SourceDesign/Order.dart';

class ItemOrder {
  Item item;
  Order order;
  int quantity;
  ItemOrder({
    required this.item,
    required this.order,
    required this.quantity,
  });


}
