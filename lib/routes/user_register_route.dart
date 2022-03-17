import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qalenium_mobile/routes/signin_route.dart';

import 'home_route.dart';

class UserSignupRoute extends StatelessWidget {
  const UserSignupRoute({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register User',
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
      home: const UserSignupPage(title: 'Register User Page'),
    );
  }
}

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<UserSignupPage> createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final rePasswordTextController = TextEditingController();

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
                    const Text('Fill in all user data'),
                    TextFormField(
                      controller: emailTextController,
                      decoration: const InputDecoration(
                          hintText: 'email@provider.com'
                      ),
                    ),
                    TextFormField(
                      controller: passwordTextController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'password'
                      ),
                    ),
                    TextFormField(
                      controller: rePasswordTextController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'repeat password'
                      ),
                    ),
                    ElevatedButton(
                        child: const Text('Register'),
                        onPressed: () async {

                          if (emailTextController.text.isEmpty ||
                              passwordTextController.text.isEmpty ||
                              rePasswordTextController.text.isEmpty) {
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

                          if (passwordTextController.text !=
                              rePasswordTextController.text) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Passwords doesn\'t match'),
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

                          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                          String deviceUuid = "";

                          if (Platform.isAndroid) {
                            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                            deviceUuid = androidInfo.androidId!;
                          } else if (Platform.isIOS) {
                            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                            deviceUuid = iosInfo.identifierForVendor!;
                          }

                          final response = await http
                              .post(Uri.parse('https://qalenium-api.herokuapp'
                              '.com/user/signup'),
                            headers: <String, String> {
                              'Content-Type':'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'email': emailTextController.text,
                              'auth': passwordTextController.text,
                              'company': 'company X',
                              'deviceId': deviceUuid
                            }),
                          );

                          if (response.statusCode == 200) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('User registered '
                                        'successfully'),
                                  );
                                });

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const
                                SignInRoute())
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
