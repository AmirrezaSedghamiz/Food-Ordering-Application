// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_base_project/SourceDesign/Customer.dart';

class Feedback {
  String body;
  int rating;
  Customer customer;
  
  Feedback({
    required this.body,
    required this.rating,
    required this.customer,
  });
}
