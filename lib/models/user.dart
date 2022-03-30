class User {
  final int userId;
  final int companyId;
  final String deviceId;
  final String email;
  final String auth;

  const User({
    required this.userId,
    required this.companyId,
    required this.deviceId,
    required this.email,
    required this.auth
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        companyId: int.parse(json['companyId']),
        deviceId: json['deviceId'],
        email: json['email'],
        auth: json['auth']
    );
  }
}


