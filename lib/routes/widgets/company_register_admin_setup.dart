import 'package:flutter/material.dart';

import '../../inherited_widgets/company_admin_setup.dart';

class CompanyAdminSetupState extends StatefulWidget {
  const CompanyAdminSetupState({Key? key}) : super(key: key);

  @override
  State<CompanyAdminSetupState> createState() => _CompanyAdminSetupStateState();
}

class _CompanyAdminSetupStateState extends State<CompanyAdminSetupState> {

  @override
  Widget build(BuildContext context) {

    var companyAdminSetup = context.dependOnInheritedWidgetOfExactType<CompanyAdminSetup>()!;

    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 600),
      expansionCallback: (panelIndex, isExpanded) {
        companyAdminSetup.isAdminSetupExpanded = !companyAdminSetup.isAdminSetupExpanded;
        setState(() {

        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return const ListTile(
              title: Text('Admin setup', style:
              TextStyle(color: Colors.black),),
            );
          },
          body: Column(
            children: [
              TextFormField(
                controller: companyAdminSetup.emailTextController,
                decoration: const InputDecoration(
                    hintText: 'email@provider.com'
                ),
              ),
              TextFormField(
                controller: companyAdminSetup.passwordTextController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'password'
                ),
              ),
              TextFormField(
                controller: companyAdminSetup.rePasswordTextController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'repeat password'
                ),
              ),
            ],
          ),
          isExpanded: companyAdminSetup.isAdminSetupExpanded,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}