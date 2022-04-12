import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:qalenium_mobile/routes/widgets/company_register_auth_methods.dart';
import 'package:qalenium_mobile/routes/widgets/company_register_color_theme.dart';
import 'package:qalenium_mobile/routes/widgets/company_register_title.dart';
import 'package:qalenium_mobile/routes/widgets/company_register_submit_button.dart';
import 'package:qalenium_mobile/routes/widgets/company_register_tools_setup.dart';
import 'package:qalenium_mobile/routes/pre_login/companies.dart';
import '../widgets/company_register_admin_setup.dart';

class RegisterCompanyRoute extends StatelessWidget {
  const RegisterCompanyRoute({Key? key, required this.flexSchemeData}) : super(key: key);

  final FlexSchemeData flexSchemeData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Company',
      theme: FlexThemeData.light(
        primary: flexSchemeData.light.primary,
        primaryVariant: flexSchemeData.light.primaryVariant,
        secondary: flexSchemeData.light.secondary,
        secondaryVariant: flexSchemeData.light.secondaryVariant,
      ),
      darkTheme: FlexThemeData.dark(
        primary: flexSchemeData.dark.primary,
        primaryVariant: flexSchemeData.dark.primaryVariant,
        secondary: flexSchemeData.dark.secondary,
        secondaryVariant: flexSchemeData.dark.secondaryVariant,
      ),
      themeMode: ThemeMode.system,
      home: RegisterCompanyPage(
          flexSchemeData: flexSchemeData
      ),
    );
  }
}

class RegisterCompanyPage extends StatefulWidget {
  const RegisterCompanyPage({Key? key, required this.flexSchemeData}) : super(key: key);

  final FlexSchemeData flexSchemeData;

  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CompaniesRoute(flexSchemeData: widget.flexSchemeData)
                )
            );
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Form(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: const <Widget>[
                  CompanyTitleState(),
                  CompanyAuthMethodsState(),
                  CompanyAdminSetupState(),
                  CompanyColorThemeState(),
                  CompanyToolsSetupState(),
                  CompanySubmitButton()
                ],
              ),
            )),
      ),
    );
  }
}
