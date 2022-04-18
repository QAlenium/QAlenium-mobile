import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qalenium_mobile/models/company.dart';
import 'package:qalenium_mobile/routes/pre_login/signin.dart';

import 'package:uuid/uuid.dart';
import 'dart:math';

class UserSignupRoute extends StatelessWidget {
  const UserSignupRoute({Key? key, required this.company, required this
      .flexSchemeData}) : super(key: key);

  final Company company;
  final FlexSchemeData flexSchemeData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register User',
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
      home: UserSignupPage(title: 'Register User Page', company: company,
          flexSchemeData: flexSchemeData),
    );
  }
}

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({Key? key, required this.title, required this.company,
    required this.flexSchemeData}) : super(key: key);

  final Company company;
  final String title;
  final FlexSchemeData flexSchemeData;

  @override
  State<UserSignupPage> createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final rePasswordTextController = TextEditingController();

  bool _passwordVisible = true;
  bool _rePasswordVisible = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _rePasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: Center(
          child: Form(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.network(
                      widget.company.logo,
                      semanticLabel: 'Company\'s logo',
                      alignment: Alignment.center,
                    ),
                    TextFormField(
                      controller: emailTextController,
                      decoration: const InputDecoration(
                          hintText: 'email@provider.com'
                      ),
                    ),
                    TextFormField(
                      controller: passwordTextController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        hintText: 'password',
                        suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              })
                            }
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: rePasswordTextController,
                      obscureText: !_rePasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'repeat password',
                        suffixIcon: IconButton(
                            icon: Icon(
                              _rePasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => {
                              setState(() {
                                _rePasswordVisible = !_rePasswordVisible;
                              })
                            }
                        ),
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

                          if (defaultTargetPlatform == TargetPlatform.android) {
                            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                            deviceUuid = androidInfo.androidId!;
                          } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                            deviceUuid = iosInfo.identifierForVendor!;
                          } else {
                            deviceUuid = const Uuid().v5(Uuid.NAMESPACE_OID, Random().toString());
                          }

                          final response = await http
                              .post(Uri.parse('https://qalenium-api.herokuapp'
                              '.com/user/signup/' + widget.company.companyId.toString()),
                              headers: <String, String> {
                                'Content-Type':'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(<String, String>{
                                'email': emailTextController.text,
                                'auth': sha512.convert(utf8.encode
                                  (emailTextController.text + ':' +
                                    passwordTextController.text)).toString(),
                                'companyId': widget.company.companyId.toString(),
                                'deviceId': deviceUuid,
                                'isAdmin': false.toString()
                              })
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
                                MaterialPageRoute(builder: (context) =>
                                    SignInRoute(company: widget.company,
                                        flexSchemeData: widget.flexSchemeData))
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
