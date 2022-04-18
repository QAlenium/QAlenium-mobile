import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qalenium_mobile/routes/widgets/theme_showcase.dart';
import 'package:qalenium_mobile/routes/pre_login/companies.dart';

import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

import '../../models/company.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';


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
      home: RegisterCompanyPage(title: 'Register Company Page', flexSchemeData: flexSchemeData),
    );
  }
}

class RegisterCompanyPage extends StatefulWidget {
  const RegisterCompanyPage({Key? key, required this.title, required this
      .flexSchemeData}) : super(key: key);

  final String title;
  final FlexSchemeData flexSchemeData;

  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {

  final companyNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final rePasswordTextController = TextEditingController();
  final continuousQualityURLTextController = TextEditingController();
  final ciCdURLTextController = TextEditingController();
  final boardKanbanURLTextController = TextEditingController();
  final testingURLTextController = TextEditingController();
  final messagingURLTextController = TextEditingController();

  final logoUrlController = TextEditingController();

  final continuousQualityTokenTextController = TextEditingController();
  final continuousQualityUsernameTextController = TextEditingController();
  final continuousQualityPasswordTextController = TextEditingController();

  final ciCdTokenTextController = TextEditingController();
  final ciCdUsernameTextController = TextEditingController();
  final ciCdPasswordTextController = TextEditingController();

  final boardKanbanTokenTextController = TextEditingController();
  final boardKanbanUsernameTextController = TextEditingController();
  final boardKanbanPasswordTextController = TextEditingController();

  final testingTokenTextController = TextEditingController();
  final testingUsernameTextController = TextEditingController();
  final testingPasswordTextController = TextEditingController();

  final messagingTokenTextController = TextEditingController();
  final messagingUsernameTextController = TextEditingController();
  final messagingPasswordTextController = TextEditingController();

  late String logoUrl = "https://raw.githubusercontent.com/QAlenium/QAlenium-mobile/main/assets/appium.jpg";

  Color primaryColor = const Color(0xFF071330);
  Color primaryVariantColor = const Color(0xFF071330);
  Color secondaryColor = const Color(0xFFFFC929);
  Color secondaryVariantColor = const Color(0xFFFFC929);

  bool isLoginUsingGithubEnabled = false;
  bool isLoginUsingAppleEnabled = false;
  bool isLoginUsingFacebookEnabled = false;
  bool isLoginUsingEmailEnabled = false;
  bool isAuthTogglesListExpanded = false;
  bool isAdminSetupExpanded = false;
  bool isColorPickerExpanded = false;
  bool isToolsSetupExpanded = false;
  bool isContinuousQualityEnabled = false;
  bool isCiCdEnabled = false;
  bool isBoardKanbanEnabled = false;
  bool isTestingEnabled = false;
  bool isMessagingEnabled = false;
  bool isContinuousQualityAuthTokenEnabled = false;
  bool isCiCdAuthTokenEnabled = false;
  bool isBoardKanbanAuthTokenEnabled = false;
  bool isTestingAuthTokenEnabled = false;
  bool isMessagingAuthTokenEnabled = false;

  int selectedRadio = 1;

  bool _passwordVisible = true;
  bool _rePasswordVisible = true;

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = logoUrlController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (!isURL(text)) {
      return "URL is invalid";
    }
    // return null if the text is valid
    return null;
  }

  void updatePrimaryColor(Color color) {
    setState(() => primaryColor = color);
  }

  void updatePrimaryVariantColor(Color color) {
    setState(() => primaryVariantColor = color);
  }

  void updateSecondaryColor(Color color) {
    setState(() => secondaryColor = color);
  }

  void updateSecondaryVariantColor(Color color) {
    setState(() => secondaryVariantColor = color);
  }

  @override
  void initState() {
    super.initState();
    logoUrl = "https://raw.githubusercontent.com/QAlenium/QAlenium-mobile/main/assets/appium.jpg";
    _passwordVisible = false;
    _rePasswordVisible = false;
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
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: FutureBuilder<void>(
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        return Image.network(
                          logoUrl,
                          semanticLabel: 'Company\'s logo',
                          width: 100,
                          height: 100,
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                      label: const Text('Change logo'),
                      icon: const Icon(
                        Icons.edit,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Choose logo from URL"),
                              content: TextField(
                                controller: logoUrlController,
                                decoration: InputDecoration(
                                    labelText: "Paste logo URL here",
                                    errorText: _errorText
                                ),
                                onChanged: (text) => setState(() => {}),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    setState(() {
                                      if (!isURL(logoUrlController.text,
                                          requireTld: false)) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                content: Text('Invalid URL'),
                                              );
                                            });
                                      } else {
                                        logoUrl = logoUrlController.text;
                                        Navigator.pop(context, 'Use this URL');
                                      }
                                    })
                                  },
                                  child: const Text('Use this URL'),
                                ),
                              ],
                            )
                        );
                      }
                  ),
                  TextFormField(
                    controller: companyNameTextController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Type company name',
                    ),
                  ),
                  ExpansionPanelList(
                    animationDuration: const Duration(milliseconds: 600),
                    expansionCallback: (panelIndex, isExpanded) {
                      isAuthTogglesListExpanded = !isAuthTogglesListExpanded;
                      setState(() {

                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return const ListTile(
                            title: Text('Authentication Methods', style:
                            TextStyle(color: Colors.black),),
                          );
                        },
                        body: Column(
                          children: [
                            SwitchListTile(
                                title: const Text('Login using Email'),
                                secondary: const Icon(Icons.email),
                                value: isLoginUsingEmailEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isLoginUsingEmailEnabled = value;
                                  });
                                }
                            ),
                            SwitchListTile(
                                title: const Text('Login using GitHub'),
                                secondary: const Icon(Icons.code),
                                value: isLoginUsingGithubEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isLoginUsingGithubEnabled = value;
                                  });
                                }
                            ),
                            SwitchListTile(
                                title: const Text('Login using Apple'),
                                secondary: const Icon(Icons.apple),
                                value: isLoginUsingAppleEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isLoginUsingAppleEnabled = value;
                                  });
                                }
                            ),
                            SwitchListTile(
                                title: const Text('Login using Facebook'),
                                secondary: const Icon(Icons.facebook),
                                value: isLoginUsingFacebookEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isLoginUsingFacebookEnabled = value;
                                  });
                                }
                            ),
                          ],
                        ),
                        isExpanded: isAuthTogglesListExpanded,
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                  ExpansionPanelList(
                    animationDuration: const Duration(milliseconds: 600),
                    expansionCallback: (panelIndex, isExpanded) {
                      isAdminSetupExpanded = !isAdminSetupExpanded;
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
                          ],
                        ),
                        isExpanded: isAdminSetupExpanded,
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                  ExpansionPanelList(
                    animationDuration: const Duration(milliseconds: 600),
                    expansionCallback: (panelIndex, isExpanded) {
                      isColorPickerExpanded = !isColorPickerExpanded;
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
                                pickerColor: primaryColor,
                                onColorChanged: updatePrimaryColor
                            ),
                            const Text('Primary Variant Theme Color'),
                            ColorPicker(
                                pickerColor: primaryVariantColor,
                                onColorChanged: updatePrimaryVariantColor
                            ),
                            const Text('Secondary Theme Color'),
                            ColorPicker(
                                pickerColor: secondaryColor,
                                onColorChanged: updateSecondaryColor
                            ),
                            const Text('Primary Variant Theme Color'),
                            ColorPicker(
                                pickerColor: secondaryVariantColor,
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
                                                  primary: primaryColor,
                                                  primaryVariant: primaryVariantColor,
                                                  secondary: secondaryColor,
                                                  secondaryVariant: secondaryVariantColor,
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
                        isExpanded: isColorPickerExpanded,
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                  ExpansionPanelList(
                    animationDuration: const Duration(milliseconds: 600),
                    expansionCallback: (panelIndex, isExpanded) {
                      isToolsSetupExpanded = !isToolsSetupExpanded;
                      setState(() {

                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return const ListTile(
                            title: Text('Tools Setup', style:
                            TextStyle(color: Colors.black),
                            ),
                          );
                        },
                        body: Column(
                          children: [
                            SwitchListTile(
                                title: const Text('Continuous Quality'),
                                secondary: const Icon(Icons.search),
                                value: isContinuousQualityEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isContinuousQualityEnabled = value;
                                  });
                                }
                            ),
                            if (isContinuousQualityEnabled)
                              Column(
                                children: [
                                  SwitchListTile(
                                      title: const Text('Token'),
                                      secondary: const Icon(Icons.lock),
                                      value: isContinuousQualityAuthTokenEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          isContinuousQualityAuthTokenEnabled = value;
                                        });
                                      }
                                  ),
                                  TextFormField(
                                    controller: continuousQualityURLTextController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'Continuous Quality URL',
                                    ),
                                  ),
                                  const Text('Leave token/credentials blank if '
                                      'API '
                                      'is public'),
                                  if (isContinuousQualityAuthTokenEnabled)
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: continuousQualityTokenTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Continuous Quality '
                                                'Auth Token',
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: continuousQualityUsernameTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Continuous '
                                                'Quality Username',
                                          ),
                                        ),
                                        TextFormField(
                                          controller: continuousQualityPasswordTextController,
                                          textAlign: TextAlign.center,
                                          obscureText: !_passwordVisible,
                                          decoration: InputDecoration(
                                            hintText: 'Quality Password',
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
                                      ],
                                    )
                                ],
                              ),
                            SwitchListTile(
                                title: const Text('CI/CD'),
                                secondary: const Icon(Icons.code),
                                value: isCiCdEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isCiCdEnabled = value;
                                  });
                                }
                            ),
                            if (isCiCdEnabled)
                              Column(
                                children: [
                                  SwitchListTile(
                                      title: const Text('Token'),
                                      secondary: const Icon(Icons.lock),
                                      value: isCiCdAuthTokenEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          isCiCdAuthTokenEnabled = value;
                                        });
                                      }
                                  ),
                                  TextFormField(
                                    controller: ciCdURLTextController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'CI/CD URL',
                                    ),
                                  ),
                                  const Text('Leave token/credentials blank if '
                                      'API '
                                      'is public'),
                                  if (isCiCdAuthTokenEnabled)
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: ciCdTokenTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'CI/CD Auth Token',
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: ciCdUsernameTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'CI/CD Username',
                                          ),
                                        ),
                                        TextFormField(
                                          controller: ciCdPasswordTextController,
                                          textAlign: TextAlign.center,
                                          obscureText: !_passwordVisible,
                                          decoration: InputDecoration(
                                            hintText: 'CI/CD Password',
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
                                      ],
                                    )
                                ],
                              ),
                            SwitchListTile(
                                title: const Text('Board/Kanban'),
                                secondary: const Icon(Icons.book),
                                value: isBoardKanbanEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isBoardKanbanEnabled = value;
                                  });
                                }
                            ),
                            if (isBoardKanbanEnabled)
                              Column(
                                children: [
                                  SwitchListTile(
                                      title: const Text('Token'),
                                      secondary: const Icon(Icons.lock),
                                      value: isBoardKanbanAuthTokenEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          isBoardKanbanAuthTokenEnabled = value;
                                        });
                                      }
                                  ),
                                  TextFormField(
                                    controller: boardKanbanURLTextController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'Board/Kanban URL',
                                    ),
                                  ),
                                  const Text('Leave token/credentials blank if '
                                      'API '
                                      'is public'),
                                  if (isBoardKanbanAuthTokenEnabled)
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller:
                                          boardKanbanTokenTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Board/Kanban Auth Token',
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller: boardKanbanUsernameTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Board/Kanban Username',
                                          ),
                                        ),
                                        TextFormField(
                                          controller: boardKanbanPasswordTextController,
                                          textAlign: TextAlign.center,
                                          obscureText: !_passwordVisible,
                                          decoration: InputDecoration(
                                            hintText: 'Board/Kanban Password',
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
                                      ],
                                    )
                                ],
                              ),
                            SwitchListTile(
                                title: const Text('Testing'),
                                secondary: const Icon(Icons.bug_report),
                                value: isTestingEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isTestingEnabled = value;
                                  });
                                }
                            ),
                            if (isTestingEnabled)
                              Column(
                                children: [
                                  SwitchListTile(
                                      title: const Text('Token'),
                                      secondary: const Icon(Icons.lock),
                                      value: isTestingAuthTokenEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          isTestingAuthTokenEnabled = value;
                                        });
                                      }
                                  ),
                                  TextFormField(
                                    controller: testingURLTextController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'Testing URL',
                                    ),
                                  ),
                                  const Text('Leave token/credentials blank if '
                                      'API '
                                      'is public'),
                                  if (isTestingAuthTokenEnabled)
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller:
                                          testingTokenTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Testing Auth Token',
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller:
                                          testingUsernameTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Testing Username',
                                          ),
                                        ),
                                        TextFormField(
                                          controller:
                                          testingPasswordTextController,
                                          textAlign: TextAlign.center,
                                          obscureText: !_passwordVisible,
                                          decoration: InputDecoration(
                                            hintText: 'Testing Password',
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
                                      ],
                                    )
                                ],
                              ),
                            SwitchListTile(
                                title: const Text('Messaging'),
                                secondary: const Icon(Icons.message),
                                value: isMessagingEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    isMessagingEnabled = value;
                                  });
                                }
                            ),
                            if (isMessagingEnabled)
                              Column(
                                children: [
                                  SwitchListTile(
                                      title: const Text('Token'),
                                      secondary: const Icon(Icons.lock),
                                      value: isMessagingAuthTokenEnabled,
                                      onChanged: (value) {
                                        setState(() {
                                          isMessagingAuthTokenEnabled = value;
                                        });
                                      }
                                  ),
                                  TextFormField(
                                    controller: messagingURLTextController,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      hintText: 'Messaging URL',
                                    ),
                                  ),
                                  const Text('Leave token/credentials blank if '
                                      'API '
                                      'is public'),
                                  if (isMessagingAuthTokenEnabled)
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller:
                                          messagingTokenTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Messaging Auth Token',
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        TextFormField(
                                          controller:
                                          messagingUsernameTextController,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            hintText: 'Messaging Username',
                                          ),
                                        ),
                                        TextFormField(
                                          controller:
                                          messagingPasswordTextController,
                                          textAlign: TextAlign.center,
                                          obscureText: !_passwordVisible,
                                          decoration: InputDecoration(
                                            hintText: 'Messaging Password',
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
                                      ],
                                    )
                                ],
                              ),
                          ],
                        ),
                        isExpanded: isToolsSetupExpanded,
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                  ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () async {

                        if (companyNameTextController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text('Company name must not be '
                                      'empty'),
                                );
                              });
                          return;
                        }

                        if (emailTextController.text.isEmpty ||
                            passwordTextController.text.isEmpty ||
                            rePasswordTextController.text.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text('User fields must not be '
                                      'blank'),
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

                        if (isContinuousQualityEnabled) {
                          if (continuousQualityURLTextController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Continuous Quality URL '
                                        'cannot be empty if enabled'),
                                  );
                                });
                            return;
                          } else if (!isURL(continuousQualityURLTextController.text,
                              requireTld: false)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('The Continuous Quality URL is '
                                        'invalid'),
                                  );
                                });
                            return;
                          }
                        }

                        if (isCiCdEnabled) {
                          if (ciCdURLTextController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('CI/CD URL '
                                        'cannot be empty if enabled'),
                                  );
                                });
                            return;
                          } else if (!isURL(ciCdURLTextController.text,
                              requireTld: false)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('The CI/CD URL is '
                                        'invalid'),
                                  );
                                });
                            return;
                          }
                        }

                        if (isBoardKanbanEnabled) {
                          if (boardKanbanURLTextController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Board/Kanban URL '
                                        'cannot be empty if enabled'),
                                  );
                                });
                            return;
                          } else if (!isURL(boardKanbanURLTextController.text,
                              requireTld: false)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('The Board/Kanban URL is '
                                        'invalid'),
                                  );
                                });
                            return;
                          }
                        }

                        if (isTestingEnabled) {
                          if (testingURLTextController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Messaging URL '
                                        'cannot be empty if enabled'),
                                  );
                                });
                            return;
                          } else if (!isURL(testingURLTextController.text,
                              requireTld: false)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('The Messaging URL is '
                                        'invalid'),
                                  );
                                });
                            return;
                          }
                        }

                        if (isMessagingEnabled) {
                          if (messagingURLTextController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Messaging URL '
                                        'cannot be empty if enabled'),
                                  );
                                });
                            return;
                          } else if (!isURL(messagingURLTextController.text,
                              requireTld: false)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('The Messaging URL is '
                                        'invalid'),
                                  );
                                });
                            return;
                          }
                        }

                        final companyCreationResponse = await http
                            .post(Uri.parse('https://qalenium-api.herokuapp.com/company/createCompany'),
                          headers: <String, String> {
                            'Content-Type':'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            'name': companyNameTextController.text,
                            'logo': logoUrl,
                            'loginGit': isLoginUsingGithubEnabled.toString(),
                            'loginApple': isLoginUsingAppleEnabled.toString(),
                            'loginFacebook': isLoginUsingFacebookEnabled.toString(),
                            'loginEmail': isLoginUsingEmailEnabled.toString(),
                            'primaryLightColor': primaryColor.hexCode,
                            'primaryLightVariantColor': primaryVariantColor.hexCode,
                            'secondaryLightColor': secondaryColor.hexCode,
                            'secondaryLightVariantColor': secondaryVariantColor.hexCode,
                            'primaryDarkColor': primaryColor.hexCode,
                            'primaryDarkVariantColor': primaryVariantColor.hexCode,
                            'secondaryDarkColor': secondaryColor.hexCode,
                            'secondaryDarkVariantColor': secondaryVariantColor.hexCode,
                            'continuousQualityUrl': Uri.encodeFull(continuousQualityURLTextController.text),
                            'ciCdUrl': Uri.encodeFull(ciCdURLTextController.text),
                            'boardKanbanUrl': Uri.encodeFull(boardKanbanURLTextController.text),
                            'testingUrl': Uri.encodeFull(testingURLTextController.text),
                            'messagingUrl': Uri.encodeFull(messagingURLTextController.text),
                          }),
                        );

                        if (companyCreationResponse.statusCode == 200) {
                          // At this point, the company was registered
                          // successfully already

                          final companyQueryByNameResponse = await http
                              .get(Uri.parse('https://qalenium-api.herokuapp'
                              '.com/company/getCompanyByName/' +
                              companyNameTextController.text)
                          );

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

                          if (companyQueryByNameResponse.statusCode == 200) {
                            List<dynamic> listCompanies = jsonDecode(companyQueryByNameResponse.body);
                            List<Company> companies = listCompanies.map((company) => Company.companyFromJson(company)).toList();

                            final userResponse = await http
                                .post(Uri.parse('https://qalenium-api.herokuapp'
                                '.com/user/signup/' + companies[0].companyId.toString()),
                                headers: <String, String> {
                                  'Content-Type':'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, String>{
                                  'email': emailTextController.text,
                                  'auth': sha512.convert(utf8.encode
                                    (emailTextController.text + ':' +
                                      passwordTextController.text)).toString(),
                                  'companyId': companies[0].companyId
                                      .toString(),
                                  'deviceId': deviceUuid,
                                  'isAdmin': true.toString()
                                })
                            );

                            if (userResponse.statusCode == 200) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: Text('Company registered '
                                          'successfully!'),
                                    );
                                  });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      CompaniesRoute(flexSchemeData: widget.flexSchemeData))
                              );
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(companyQueryByNameResponse.body),
                                    );
                                  });
                            }

                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(companyQueryByNameResponse.body),
                                  );
                                });
                            return;
                          }

                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(companyCreationResponse.body),
                                );
                              });
                        }
                      }
                  )
                ],
              ),
            )),
      ),
    );
  }
}
