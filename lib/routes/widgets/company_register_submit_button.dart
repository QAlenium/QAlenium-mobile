import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import 'package:http/http.dart' as http;

import '../../inherited_widgets/company_admin_setup.dart';
import '../../inherited_widgets/company_auth_methods.dart';
import '../../inherited_widgets/company_theme_color.dart';
import '../../inherited_widgets/company_title.dart';
import '../../inherited_widgets/company_tools_setup.dart';
import '../../models/company.dart';

class CompanySubmitButton extends StatefulWidget {
  const CompanySubmitButton({Key? key,}) : super(key: key);

  @override
  State<CompanySubmitButton> createState() => _CompanySubmitButtonState();

}

class _CompanySubmitButtonState extends State<CompanySubmitButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var companyTitle = context.dependOnInheritedWidgetOfExactType<CompanyTitle>()!;
    var companyAuthMethods = context.dependOnInheritedWidgetOfExactType<CompanyAuthMethods>()!;
    var companyAdminSetup = context.dependOnInheritedWidgetOfExactType<CompanyAdminSetup>()!;
    var companyThemeColor = context.dependOnInheritedWidgetOfExactType<CompanyThemeColor>()!;
    var companyToolSetup = context.dependOnInheritedWidgetOfExactType<CompanyToolSetup>()!;

    return ElevatedButton(
        child: const Text('Submit'),
        onPressed: () async {

          if (companyTitle.companyNameTextController.text.isEmpty) {
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

          if (companyAdminSetup.emailTextController.text.isEmpty ||
              companyAdminSetup.passwordTextController.text.isEmpty ||
              companyAdminSetup.rePasswordTextController.text.isEmpty) {
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

          if (!EmailValidator.validate(companyAdminSetup.emailTextController.text)) {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: Text('Invalid email'),
                  );
                });
            return;
          }

          if (companyAdminSetup.passwordTextController.text !=
              companyAdminSetup.rePasswordTextController.text) {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: Text('Passwords doesn\'t match'),
                  );
                });
            return;
          }

          if (companyAdminSetup.passwordTextController.text.length <= 6) {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: Text('Password is too short'),
                  );
                });
            return;
          }

          if (companyToolSetup.isContinuousQualityEnabled) {
            if (companyToolSetup.continuousQualityURLTextController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Continuous Quality URL '
                          'cannot be empty if enabled'),
                    );
                  });
              return;
            } else if (!isURL(companyToolSetup.continuousQualityURLTextController.text,
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

          if (companyToolSetup.isCiCdEnabled) {
            if (companyToolSetup.ciCdURLTextController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('CI/CD URL '
                          'cannot be empty if enabled'),
                    );
                  });
              return;
            } else if (!isURL(companyToolSetup.ciCdURLTextController.text,
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

          if (companyToolSetup.isBoardKanbanEnabled) {
            if (companyToolSetup.boardKanbanURLTextController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Board/Kanban URL '
                          'cannot be empty if enabled'),
                    );
                  });
              return;
            } else if (!isURL(companyToolSetup.boardKanbanURLTextController.text,
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

          if (companyToolSetup.isTestingEnabled) {
            if (companyToolSetup.testingURLTextController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Messaging URL '
                          'cannot be empty if enabled'),
                    );
                  });
              return;
            } else if (!isURL(companyToolSetup.testingURLTextController.text,
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

          if (companyToolSetup.isMessagingEnabled) {
            if (companyToolSetup.messagingURLTextController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: Text('Messaging URL '
                          'cannot be empty if enabled'),
                    );
                  });
              return;
            } else if (!isURL(companyToolSetup.messagingURLTextController.text,
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
              'name': companyTitle.companyNameTextController.text,
              'logo': companyTitle.logoUrl,
              'loginGit': companyAuthMethods.isLoginUsingGithubEnabled.toString(),
              'loginApple': companyAuthMethods.isLoginUsingAppleEnabled.toString(),
              'loginFacebook': companyAuthMethods.isLoginUsingFacebookEnabled.toString(),
              'loginEmail': companyAuthMethods.isLoginUsingEmailEnabled.toString(),
              'primaryLightColor': companyThemeColor.primaryColor.hexCode,
              'primaryLightVariantColor': companyThemeColor.primaryVariantColor.hexCode,
              'secondaryLightColor': companyThemeColor.secondaryColor.hexCode,
              'secondaryLightVariantColor': companyThemeColor.secondaryVariantColor.hexCode,
              'primaryDarkColor': companyThemeColor.primaryColor.hexCode,
              'primaryDarkVariantColor': companyThemeColor.primaryVariantColor.hexCode,
              'secondaryDarkColor': companyThemeColor.secondaryColor.hexCode,
              'secondaryDarkVariantColor': companyThemeColor.secondaryVariantColor.hexCode,
              'continuousQualityUrl': Uri.encodeFull
                (companyToolSetup.continuousQualityURLTextController.text),
              'ciCdUrl': Uri.encodeFull(companyToolSetup.ciCdURLTextController.text),
              'boardKanbanUrl': Uri.encodeFull(companyToolSetup.boardKanbanURLTextController.text),
              'testingUrl': Uri.encodeFull(companyToolSetup.testingURLTextController.text),
              'messagingUrl': Uri.encodeFull(companyToolSetup.messagingURLTextController.text),
            }),
          );

          if (companyCreationResponse.statusCode == 200) {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    content: Text('Company registered/updated '
                        'successfully!'),
                  );
                });

            final companyQueryByNameResponse = await http
                .get(Uri.parse('https://qalenium-api.herokuapp'
                '.com/company/getCompanyByName/' +
                companyTitle.companyNameTextController.text)
            );

            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            String deviceUuid = "";

            if (Platform.isAndroid) {
              AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
              deviceUuid = androidInfo.androidId!;
            } else if (Platform.isIOS) {
              IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
              deviceUuid = iosInfo.identifierForVendor!;
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
                    'email': companyAdminSetup.emailTextController.text,
                    'auth': sha512.convert(utf8.encode(
                        companyAdminSetup.emailTextController.text + ':' +
                            companyAdminSetup.passwordTextController.text)).toString(),
                    'companyId': companies[0].companyId.toString(),
                    'deviceId': deviceUuid,
                    'isAdmin': true.toString()
                  })
              );

              if (userResponse.statusCode == 200) {

                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text('User created successfully!'),
                      );
                    });

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

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) =>
          //         CompaniesRoute(flexSchemeData: widget.flexSchemeData))
          // );

        }
    );
  }
}