// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:data_base_project/SourceDesign/Address.dart';

class Customer {
  int customerId;
  String username;
  String phoneNumber;
  File? image;
  List<Address> addresses;
  Address selectedAddress;

  Customer({
    required this.customerId,
    required this.username,
    required this.phoneNumber,
    required this.addresses,
    required this.selectedAddress,
    this.image,
  });
}
