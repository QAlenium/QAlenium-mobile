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
  final String continuousQualityUrl;
  final String ciCdUrl;
  final String boardKanbanUrl;
  final String testingUrl;
  final String messagingUrl;

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
    required this.secondaryDarkVariantColor,
    required this.continuousQualityUrl,
    required this.ciCdUrl,
    required this.boardKanbanUrl,
    required this.messagingUrl,
    required this.testingUrl
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
        secondaryDarkVariantColor: json['secondaryDarkVariantColor'],
        continuousQualityUrl: json['continuousQualityUrl'] ?? "",
        ciCdUrl: json['ciCdUrl'] ?? "",
        boardKanbanUrl: json['boardKanbanUrl'] ?? "",
        testingUrl: json['testingUrl'] ?? "",
        messagingUrl: json['messagingUrl'] ?? ""
    );
  }
}


