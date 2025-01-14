// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:latlong2/latlong.dart';

class Address {
  int addressId;
  String address;
  LatLng point;
  Address({
    required this.addressId,
    required this.address,
    required this.point,
  });
}
