import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qalenium_mobile/routes/companies_route.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

import '../../models/company.dart';

class RegisterCompanyRoute extends StatelessWidget {
  const RegisterCompanyRoute({Key? key, required this.flexSchemeData}) : super(key: key);

  final FlexSchemeData flexSchemeData;
  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final FlexSchemeData flexSchemeData;

  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

typedef OnPickImageCallback = void Function();

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {

  final companyNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final rePasswordTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  late XFile _image = XFile(File(retrieveFilePathFromAsset('qalenium_logo_white_background.png')).path);

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
  int selectedRadio = 1;
  String? _retrieveDataError;

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

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  String retrieveFilePathFromAsset(String assetPath) {
    File file = File('');
    getImageFileFromAssets(assetPath).then((file) => file.path);
    setState(() {
      _image = XFile(File(file.path).path);
    });
    return file.path;
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file!;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }

    if (_image.path != '' || _image.path.isNotEmpty) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: kIsWeb
            ? Image.network(
          _image.path,
          alignment: Alignment.center,
          width: 100,
          height: 100,
        )
            : Image.file(
          File(_image.path),
          alignment: Alignment.center,
          width: 100,
          height: 100,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return  Image.asset(
        'assets/qalenium_logo_white_background.png',
        semanticLabel: 'Company\'s logo',
        width: 100,
        height: 100,
      );
    }
  }

  String getStringFromAssetImage(String assetPath) {
    String imageString = "";
    getImageFileFromAssets(assetPath).then((file) =>
    imageString = file.readAsStringSync()
    );
    return imageString;
  }

  Future<void> _onImageButtonPressed({BuildContext? context}) async {

    await _displayPickImageDialog(context!, () async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: selectedRadio == 1 ? ImageSource.gallery : ImageSource.camera,
          maxWidth: 100,
          maxHeight: 100,
          imageQuality: 100,
        );
        setState(() {
          _image = pickedFile!;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          bool isRadioSelected = false;
          return AlertDialog(
            title: const Text('Select source'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RadioListTile(
                        title: const Text('Gallery'),
                        subtitle: const Text('Select logo from gallery'),
                        secondary: const Icon(Icons.photo),
                        selected: isRadioSelected,
                        toggleable: true,
                        value: 1,
                        groupValue: selectedRadio,
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              selectedRadio = value as int;
                            }

                            if(isRadioSelected == false) {
                              isRadioSelected = true;
                            } else {
                              isRadioSelected = false;
                            }
                          });
                        }
                    ),
                    RadioListTile(
                        title: const Text('Camera'),
                        subtitle: const Text('Set your logo as a picture'),
                        secondary: const Icon(Icons.camera_alt),
                        selected: isRadioSelected,
                        toggleable: true,
                        value: 2,
                        groupValue: selectedRadio,
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              selectedRadio = value as int;
                            }

                            if(isRadioSelected == false) {
                              isRadioSelected = true;
                            } else {
                              isRadioSelected = false;
                            }
                          });
                        }
                    ),
                  ],
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('Select'),
                  onPressed: () {
                    onPick();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _image = XFile(File(retrieveFilePathFromAsset('qalenium_logo_white_background.png')).path);
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
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                      //future: retrieveLostData(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Image.asset(
                              'assets/qalenium_logo_white_background.png',
                              semanticLabel: 'Company\'s logo',
                              width: 100,
                              height: 100,
                            );
                          case ConnectionState.waiting:
                            return Image.asset(
                              'assets/qalenium_logo_white_background.png',
                              semanticLabel: 'Company\'s logo',
                              width: 100,
                              height: 100,
                            );
                          case ConnectionState.done:
                            return _previewImages();
                          default:
                            if (snapshot.hasError) {
                              return Text(
                                'Pick image/video error: ${snapshot.error}}',
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return Image.asset(
                                'assets/qalenium_logo_white_background.png',
                                semanticLabel: 'Company\'s logo',
                                width: 100,
                                height: 100,
                              );
                            }
                        }
                      },
                    )
                        : _previewImages(),
                  ),
                  ElevatedButton.icon(
                      label: const Text('Change logo'),
                      icon: const Icon(
                        Icons.edit,
                      ),
                      onPressed: () async {
                        _onImageButtonPressed(context: context);
                      }
                  ),
                  TextFormField(
                    controller: companyNameTextController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Type company name here',
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

                                  FlexSchemeData(
                                    name: 'Midnight blue',
                                    description: 'Midnight blue theme, custom definition of all colors',
                                    light: FlexSchemeColor(
                                        primary: primaryColor,
                                        primaryVariant: primaryVariantColor,
                                        secondary: secondaryColor,
                                        secondaryVariant: secondaryVariantColor
                                    ),
                                    dark: FlexSchemeColor(
                                        primary: primaryColor,
                                        primaryVariant: primaryVariantColor,
                                        secondary: secondaryColor,
                                        secondaryVariant: secondaryVariantColor
                                    ),
                                  );
                                },
                                child: const Text('Try me out!'),
                            )
                          ],
                        ),
                        isExpanded: isColorPickerExpanded,
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

                        final companyCreationResponse = await http
                            .post(Uri.parse('https://qalenium-api.herokuapp.com/company/createCompany'),
                          headers: <String, String> {
                            'Content-Type':'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            'name': companyNameTextController.text,
                            'logo': base64Encode(File(_image.path).readAsBytesSync()),
                            'flavourColor': '#000000',
                            'loginGit': isLoginUsingGithubEnabled.toString(),
                            'loginApple': isLoginUsingAppleEnabled.toString(),
                            'loginFacebook': isLoginUsingFacebookEnabled.toString(),
                            'loginEmail': isLoginUsingEmailEnabled.toString(),
                            'primaryLightColor':primaryColor.hexCode,
                            'primaryLightVariantColor':primaryVariantColor.hexCode,
                            'secondaryLightColor':secondaryColor.hexCode,
                            'secondaryLightVariantColor':secondaryVariantColor.hexCode,
                            'primaryDarkColor':primaryColor.hexCode,
                            'primaryDarkVariantColor':primaryVariantColor.hexCode,
                            'secondaryDarkColor':secondaryColor.hexCode,
                            'secondaryDarkVariantColor':secondaryVariantColor.hexCode,
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
                                '.com/user/signup'),
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
