import 'package:flutter/widgets.dart';

class CompanyThemeColor extends InheritedWidget {
  CompanyThemeColor({
    Key? key,
    required this.isColorPickerExpanded,
    required this.primaryColor,
    required this.primaryVariantColor,
    required this.secondaryColor,
    required this.secondaryVariantColor,
    required Widget child
  }) : super(key: key, child: child);

  late final bool isColorPickerExpanded;
  //final Color primaryColor = const Color(0xFF071330);
  late final Color primaryColor;
  late final Color primaryVariantColor;
  late final Color secondaryColor;
  late final Color secondaryVariantColor;

  static CompanyThemeColor? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CompanyThemeColor>();

  @override
  bool updateShouldNotify(CompanyThemeColor oldWidget) =>
      oldWidget.isColorPickerExpanded != isColorPickerExpanded &&
          oldWidget.primaryColor != primaryColor &&
          oldWidget.primaryVariantColor != primaryVariantColor &&
          oldWidget.secondaryColor != secondaryColor &&
          oldWidget.secondaryVariantColor != secondaryVariantColor;

}