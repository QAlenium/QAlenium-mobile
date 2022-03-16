import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qalenium_mobile/routes/companies_route.dart';
import 'package:http/http.dart' as http;

class RegisterCompanyRoute extends StatelessWidget {
  const RegisterCompanyRoute({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Company',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const RegisterCompanyPage(title: 'Register Company Page'),
    );
  }
}

class RegisterCompanyPage extends StatefulWidget {
  const RegisterCompanyPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {

  final companyNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
        ),
        body: Center(
          child: Form(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Fill in the company name'),
                    TextFormField(
                      controller: companyNameTextController,
                    ),
                    ElevatedButton(
                        child: const Text('Submit'),
                        onPressed: () async {
                          // validate valid name
                          // validate empty fields

                          // if name already exists in database, throw message
                          // if name is unique, then go to companies list page

                          final response = await http
                              .post(Uri.parse('https://qalenium-api.herokuapp.com/company/createCompany'),
                            headers: <String, String> {
                              'Content-Type':'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'name': companyNameTextController.text,
                              'logo': 'Mf75dn64s67Hxv2xsi92LHG9EK6K2Fgfdig2jy',
                              'flavourColor': '#000000',
                              'loginGit': "false",
                              'loginApple': "false",
                              'loginFacebook': "false",
                              'loginEmail': "true"
                            }),
                          );

                          if (response.statusCode == 200) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Company Registered '
                                        'successfully'),
                                  );
                                });

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const
                                CompaniesRoute())
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(response.body),
                                  );
                                });
                          }
                        }
                    )
                  ],
                ),
              )),
        )
    );
  }
}
