class Company {
  final String companyId;
  final String name;
  final String logo;
  final String flavourColor;
  final bool loginGit;
  final bool loginApple;
  final bool loginFacebook;
  final bool loginEmail;

  const Company({
    required this.companyId,
    required this.name,
    required this.logo,
    required this.flavourColor,
    required this.loginGit,
    required this.loginApple,
    required this.loginFacebook,
    required this.loginEmail
  });

  factory Company.companyFromJson(Map<String, dynamic> json) {
    return Company(
        companyId: json['companyId'],
        name: json['name'],
        logo: json['logo'],
        flavourColor: json['flavourColor'],
        loginGit: json['loginGit'],
        loginApple: json['loginApple'],
        loginFacebook: json['loginFacebook'],
        loginEmail: json['loginEmail']
    );
  }
}


