import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:qalenium_mobile/routes/home_route.dart';
import 'package:qalenium_mobile/routes/register/user_signup_route.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/company.dart';

class SignInRoute extends StatelessWidget {
  const SignInRoute({Key? key, required this.company}) : super(key: key);

  final Company company;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignIn',
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
      home: SignInPage(title: 'SignIn Page', company: company),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title, required this.company}) : super
(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Company company;
  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                    //TODO add company logo
                    const Text('Fill in credentials'),
                    TextFormField(
                      controller: emailTextController,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordTextController,
                    ),
                    ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          
                          if (emailTextController.text.isEmpty ||
                              passwordTextController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Fields must not be blank'),
                                  );
                                });
                            return;
                          }

                          if (!EmailValidator.validate(emailTextController
                              .text)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Invalid email'),
                                  );
                                });
                            return;
                          }

                          if (passwordTextController.text.length <= 6) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Password is too short'),
                                  );
                                });
                            return;
                          }

                          final response = await http
                              .post(Uri.parse('https://qalenium-api.herokuapp'
                              '.com/user/signin'),
                            headers: <String, String> {
                              'Content-Type':'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'email': emailTextController.text,
                              'auth': passwordTextController.text,
                            }),
                          );

                          if (response.statusCode == 200) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const
                                HomeRoute())
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
                    ),
                    ElevatedButton(
                        child: const Text('Signup'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  UserSignupRoute(company: widget.company))
                          );
                        }
                    )
                  ],
                ),
              )),
        )
    );
  }
}