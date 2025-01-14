import 'dart:io';

class Manager {
  int managerId;
  String username;
  String phoneNumber;
  File? image;
  
  Manager({
    required this.managerId,
    required this.username,
    required this.phoneNumber,
    this.image,
  });
}
