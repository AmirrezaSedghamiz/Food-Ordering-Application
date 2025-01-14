// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names

class Order {
  int orderId;
  DateTime orderTime;
  OrderStatus status;
  String orderDetails;
  double orderCost;
  Order({
    required this.orderId,
    required this.orderTime,
    required this.orderCost,
    required this.status,
    required this.orderDetails,
  });
}

enum OrderStatus { REJECTED, PENDING, ACCEPTED }
