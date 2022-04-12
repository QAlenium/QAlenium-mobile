import 'package:flutter/widgets.dart';

class CompanyAdminSetup extends InheritedWidget {
  CompanyAdminSetup({
    Key? key,
    required this.isAdminSetupExpanded,
    required this.emailTextController,
    required this.passwordTextController,
    required this.rePasswordTextController,
    required Widget child
  }) : super(key: key, child: child);

  late final bool isAdminSetupExpanded;
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  late final TextEditingController rePasswordTextController;

  static CompanyAdminSetup? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CompanyAdminSetup>();

  @override
  bool updateShouldNotify(CompanyAdminSetup oldWidget) =>
      oldWidget.isAdminSetupExpanded != isAdminSetupExpanded &&
          oldWidget.emailTextController != emailTextController &&
          oldWidget.passwordTextController != passwordTextController &&
          oldWidget.rePasswordTextController != rePasswordTextController;
}