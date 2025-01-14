import 'dart:io';

class Admin {
  int adminId;
  String username;
  String phoneNumber;
  File? image;
  
  Admin({
    required this.adminId,
    required this.username,
    required this.phoneNumber,
    this.image,
  });
}
