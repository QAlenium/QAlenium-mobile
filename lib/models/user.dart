class User {
  final int userId;
  final int companyId;
  final String deviceId;
  final String email;
  final String auth;
  final bool isAdmin;

  const User({
    required this.userId,
    required this.companyId,
    required this.deviceId,
    required this.email,
    required this.auth,
    required this.isAdmin
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        companyId: int.parse(json['companyId']),
        deviceId: json['deviceId'],
        email: json['email'],
        auth: json['auth'],
        isAdmin: json['isAdmin']
    );
  }
}


