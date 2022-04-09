import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:qalenium_mobile/models/user.dart';
import 'package:qalenium_mobile/routes/pre_login/companies.dart';
import 'package:qalenium_mobile/routes/drawer_menu/favorites.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/company.dart';
import '../register/user_signup.dart';

class SignInRoute extends StatelessWidget {
  const SignInRoute({Key? key, required this.company, required this.flexSchemeData}) :
        super(key: key);

  final Company company;
  final FlexSchemeData flexSchemeData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignIn',
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
      home: SignInPage(title: 'SignIn Page', company: company, flexSchemeData: flexSchemeData),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title, required this.company,
    required this.flexSchemeData}) : super(key: key);

  final Company company;
  final String title;
  final FlexSchemeData flexSchemeData;

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
                    Image.memory(
                      const Base64Decoder().convert
                        (widget.company.logo),
                      semanticLabel: 'Company\'s logo',
                      alignment: Alignment.center,
                    ),
                    if (widget.company.loginEmail)
                      Column(
                        children: [
                          TextFormField(
                            controller: emailTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.email),
                                label: const Text('Login'),
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
                                      'auth': sha512.convert(utf8.encode
                                        (emailTextController.text + ':' +
                                          passwordTextController.text)).toString(),
                                      'companyId':widget.company.companyId.toString()
                                    }),
                                  );

                                  if (response.statusCode == 200) {
                                    var user = User.fromJson(jsonDecode(response.body));

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            FavoritesRoute(
                                              flexSchemeData: widget.flexSchemeData,
                                              user: user,
                                              company: widget.company,
                                            )
                                        )
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
                          ),
                        ],
                      ), if (widget.company.loginFacebook) SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.facebook
                          ),
                          label: const Text('Login Facebook'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    UserSignupRoute(company: widget.company,
                                        flexSchemeData: widget.flexSchemeData
                                    ))
                            );
                          }
                      ),
                    ), if (widget.company.loginApple) SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.apple
                          ),
                          label: const Text('Login Apple'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    UserSignupRoute(company: widget.company,
                                        flexSchemeData: widget.flexSchemeData))
                            );
                          }
                      ),
                    ), if (widget.company.loginGit) SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          icon: const Icon(
                              Icons.code
                          ),
                          label: const Text('Login Github'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    UserSignupRoute(company: widget.company,
                                        flexSchemeData: widget.flexSchemeData))
                            );
                          }
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Signup'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  UserSignupRoute(company: widget.company,
                                      flexSchemeData: widget.flexSchemeData))
                          );
                        },
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.apartment),
                        label: const Text('Change company'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  CompaniesRoute(flexSchemeData: widget.flexSchemeData))
                          );
                        },
                      ),
                    )
                  ],
                ),
              )),
        )
    );
  }
}
