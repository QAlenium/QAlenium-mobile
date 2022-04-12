import 'package:flutter/widgets.dart';

class CompanyAuthMethods extends InheritedWidget {
  CompanyAuthMethods({
    Key? key,
    required this.isAuthTogglesListExpanded,
    required this.isLoginUsingEmailEnabled,
    required this.isLoginUsingGithubEnabled,
    required this.isLoginUsingAppleEnabled,
    required this.isLoginUsingFacebookEnabled,
    required Widget child
  }) : super(key: key, child: child);

  late final bool isAuthTogglesListExpanded;
  late final bool isLoginUsingEmailEnabled;
  late final bool isLoginUsingGithubEnabled;
  late final bool isLoginUsingAppleEnabled;
  late final bool isLoginUsingFacebookEnabled;

  static CompanyAuthMethods? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CompanyAuthMethods>();

  @override
  bool updateShouldNotify(CompanyAuthMethods oldWidget) =>
      oldWidget.isLoginUsingFacebookEnabled != isLoginUsingFacebookEnabled &&
          oldWidget.isLoginUsingEmailEnabled != isLoginUsingEmailEnabled &&
          oldWidget.isLoginUsingAppleEnabled != isLoginUsingAppleEnabled &&
          oldWidget.isLoginUsingGithubEnabled != isLoginUsingGithubEnabled &&
          oldWidget.isAuthTogglesListExpanded != isAuthTogglesListExpanded;

}