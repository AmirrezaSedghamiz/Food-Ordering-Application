// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import 'package:data_base_project/SourceDesign/Manager.dart';

class Restaurant {
  int restaurantId;
  String name;
  String address;
  LatLng point;
  int deliveryRadius;
  File image;
  Manager manager;
  List<Category> categories;
  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.address,
    required this.point,
    required this.deliveryRadius,
    required this.image,
    required this.manager,
    required this.categories,
  });
}
