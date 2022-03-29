class Company {
  final int companyId;
  final String name;
  final String logo;
  final bool loginGit;
  final bool loginApple;
  final bool loginFacebook;
  final bool loginEmail;
  final String primaryLightColor;
  final String primaryLightVariantColor;
  final String secondaryLightColor;
  final String secondaryLightVariantColor;
  final String primaryDarkColor;
  final String primaryDarkVariantColor;
  final String secondaryDarkColor;
  final String secondaryDarkVariantColor;

  const Company({
    required this.companyId,
    required this.name,
    required this.logo,
    required this.loginGit,
    required this.loginApple,
    required this.loginFacebook,
    required this.loginEmail,
    required this.primaryLightColor,
    required this.primaryLightVariantColor,
    required this.secondaryLightColor,
    required this.secondaryLightVariantColor,
    required this.primaryDarkColor,
    required this.primaryDarkVariantColor,
    required this.secondaryDarkColor,
    required this.secondaryDarkVariantColor

  });

  factory Company.companyFromJson(Map<String, dynamic> json) {
    return Company(
        companyId: json['companyId'],
        name: json['name'],
        logo: json['logo'],
        loginGit: json['loginGit'],
        loginApple: json['loginApple'],
        loginFacebook: json['loginFacebook'],
        loginEmail: json['loginEmail'],
        primaryLightColor: json['primaryLightColor'],
        primaryLightVariantColor: json['primaryLightVariantColor'],
        secondaryLightColor: json['secondaryLightColor'],
        secondaryLightVariantColor: json['secondaryLightVariantColor'],
        primaryDarkColor: json['primaryDarkColor'],
        primaryDarkVariantColor: json['primaryDarkVariantColor'],
        secondaryDarkColor: json['secondaryDarkColor'],
        secondaryDarkVariantColor: json['secondaryDarkVariantColor']
    );
  }
}


