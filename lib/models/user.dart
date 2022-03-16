import 'package:qalenium_mobile/models/company.dart';

class User {
  final String userId;
  final String deviceId;
  final String email;
  final String auth;
  final Company company;

  const User({
    required this.userId,
    required this.deviceId,
    required this.email,
    required this.auth,
    required this.company
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        deviceId: json['deviceId'],
        email: json['email'],
        auth: json['auth'],
        company: json['company']
    );
  }
}


