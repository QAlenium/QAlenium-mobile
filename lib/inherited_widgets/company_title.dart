import 'package:flutter/widgets.dart';

class CompanyTitle extends InheritedWidget {
  CompanyTitle({
    Key? key,
    required this.logoUrl,
    required this.logoUrlController,
    required this.companyNameTextController,
    required Widget child
  }) : super(key: key, child: child);

  late final String logoUrl;
  late final TextEditingController logoUrlController;
  late final TextEditingController companyNameTextController;

  static CompanyTitle? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CompanyTitle>();

  @override
  bool updateShouldNotify(CompanyTitle oldWidget) =>
      oldWidget.logoUrl != logoUrl &&
          oldWidget.logoUrlController != logoUrlController &&
          oldWidget.companyNameTextController != companyNameTextController;

}