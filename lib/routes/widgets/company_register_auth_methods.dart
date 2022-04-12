import 'package:flutter/material.dart';

import '../../inherited_widgets/company_auth_methods.dart';

class CompanyAuthMethodsState extends StatefulWidget {
  const CompanyAuthMethodsState({Key? key}) : super(key: key);

  @override
  State<CompanyAuthMethodsState> createState() => _CompanyAuthMethodsStateState();
}

class _CompanyAuthMethodsStateState extends State<CompanyAuthMethodsState> {

  @override
  Widget build(BuildContext context) {

    var companyAuthMethods = context.dependOnInheritedWidgetOfExactType<CompanyAuthMethods>()!;

    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 600),
      expansionCallback: (panelIndex, isExpanded) {

        companyAuthMethods.isAuthTogglesListExpanded = !companyAuthMethods
        .isAuthTogglesListExpanded;

      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return const ListTile(
              title: Text(
                  'Authentication Methods',
                  style: TextStyle(color: Colors.black)
              ),
            );
          },
          body: Column(
            children: [
              SwitchListTile(
                  title: const Text('Login using Email'),
                  secondary: const Icon(Icons.email),
                  value: companyAuthMethods.isLoginUsingEmailEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyAuthMethods.isLoginUsingEmailEnabled = value;
                    });
                  }
              ),
              SwitchListTile(
                  title: const Text('Login using GitHub'),
                  secondary: const Icon(Icons.code),
                  value: companyAuthMethods.isLoginUsingGithubEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyAuthMethods.isLoginUsingGithubEnabled = value;
                    });
                  }
              ),
              SwitchListTile(
                  title: const Text('Login using Apple'),
                  secondary: const Icon(Icons.apple),
                  value: companyAuthMethods.isLoginUsingAppleEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyAuthMethods.isLoginUsingAppleEnabled = value;
                    });
                  }
              ),
              SwitchListTile(
                  title: const Text('Login using Facebook'),
                  secondary: const Icon(Icons.facebook),
                  value: companyAuthMethods.isLoginUsingFacebookEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyAuthMethods.isLoginUsingFacebookEnabled = value;
                    });
                  }
              ),
            ],
          ),
          isExpanded: companyAuthMethods.isAuthTogglesListExpanded,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}