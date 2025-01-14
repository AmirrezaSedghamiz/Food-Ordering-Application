// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_base_project/SourceDesign/Address.dart';
import 'package:data_base_project/SourceDesign/Order.dart';

class ShoppingCart {
  int shoppingCartId;
  Address selectedAddress;
  double totalCost;
  List<Order> orders;
  ShoppingCart({
    required this.shoppingCartId,
    required this.selectedAddress,
    required this.totalCost,
    required this.orders,
  });
}
