import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qalenium_mobile/routes/companies_route.dart';
import 'package:path_provider/path_provider.dart';

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

typedef OnPickImageCallback = void Function();

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {
  final companyNameTextController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  bool isLoginUsingGithubEnabled = false;
  bool isLoginUsingAppleEnabled = false;
  bool isLoginUsingFacebookEnabled = false;
  bool isLoginUsingEmailEnabled = false;

  late XFile _image = XFile(File('').path);
  String? _retrieveDataError;
  dynamic _pickImageError;

  int selectedRadio = 1;

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

    if (_image.path != '') {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: kIsWeb
            ? Image.network(
          _image.path,
          alignment: Alignment.center,
        )
            : Image.file(
          File(_image.path),
          alignment: Alignment.center,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Image.asset(
        'assets/logo_company.png',
        semanticLabel: 'Company\'s logo',
        width: 100,
        height: 100,
      );
    }
  }

  Future<void> _onImageButtonPressed({BuildContext? context}) async {

    await _displayPickImageDialog(context!, () async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: selectedRadio == 1 ? ImageSource.gallery : ImageSource.camera,
          maxWidth: 100,
          maxHeight: 100,
          imageQuality: 1,
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

  String getStringFromAssetImage(String assetPath) {
    String imageString = "";
    getImageFileFromAssets(assetPath).then((file) =>
    imageString = file.readAsStringSync()
    );
    return imageString;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                        ? FutureBuilder<void>(
                      //future: retrieveLostData(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Image.asset(
                              'assets/logo_company.png',
                              semanticLabel: 'Company\'s logo',
                              width: 100,
                              height: 100,
                            );
                          case ConnectionState.waiting:
                            return Image.asset(
                              'assets/logo_company.png',
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
                                'assets/logo_company.png',
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

                        final response = await http
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
                            'loginEmail': isLoginUsingEmailEnabled.toString()
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
      ),
    );
  }
}
