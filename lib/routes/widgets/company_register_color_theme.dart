import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qalenium_mobile/routes/widgets/theme_showcase.dart';

import '../../inherited_widgets/company_theme_color.dart';

class CompanyColorThemeState extends StatefulWidget {
  const CompanyColorThemeState({Key? key}) : super(key: key);

  @override
  State<CompanyColorThemeState> createState() => _CompanyColorThemeStateState();
}

class _CompanyColorThemeStateState extends State<CompanyColorThemeState> {

  late CompanyThemeColor companyThemeColor;

  void updatePrimaryColor(Color color) {
    setState(() => companyThemeColor.primaryColor = color);
  }

  void updatePrimaryVariantColor(Color color) {
    setState(() => companyThemeColor.primaryVariantColor = color);
  }

  void updateSecondaryColor(Color color) {
    setState(() => companyThemeColor.secondaryColor = color);
  }

  void updateSecondaryVariantColor(Color color) {
    setState(() => companyThemeColor.secondaryVariantColor = color);
  }

  @override
  void initState() {
    super.initState();
    companyThemeColor = context.dependOnInheritedWidgetOfExactType<CompanyThemeColor>()!;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 600),
      expansionCallback: (panelIndex, isExpanded) {
        companyThemeColor.isColorPickerExpanded = !companyThemeColor.isColorPickerExpanded;
        setState(() {

        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return const ListTile(
              title: Text('Color theme selection', style:
              TextStyle(color: Colors.black),),
            );
          },
          body: Column(
            children: [
              const Text('Primary Theme Color'),
              ColorPicker(
                  pickerColor: companyThemeColor.primaryColor,
                  onColorChanged: updatePrimaryColor
              ),
              const Text('Primary Variant Theme Color'),
              ColorPicker(
                  pickerColor: companyThemeColor.primaryVariantColor,
                  onColorChanged: updatePrimaryVariantColor
              ),
              const Text('Secondary Theme Color'),
              ColorPicker(
                  pickerColor: companyThemeColor.secondaryColor,
                  onColorChanged: updateSecondaryColor
              ),
              const Text('Primary Variant Theme Color'),
              ColorPicker(
                  pickerColor: companyThemeColor.secondaryVariantColor,
                  onColorChanged: updateSecondaryVariantColor
              ),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            content: SingleChildScrollView(
                                child: Theme(
                                  child: const ThemeShowcase(),
                                  data: FlexThemeData.light(
                                    primary: companyThemeColor.primaryColor,
                                    primaryVariant: companyThemeColor.primaryVariantColor,
                                    secondary: companyThemeColor.secondaryColor,
                                    secondaryVariant: companyThemeColor.secondaryVariantColor,
                                  ),
                                )
                            )
                        );
                      });
                },
                child: const Text('Try me out!'),
              ),
            ],
          ),
          isExpanded: companyThemeColor.isColorPickerExpanded,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}