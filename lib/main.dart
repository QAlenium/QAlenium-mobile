import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:qalenium_mobile/routes/pre_login/companies.dart';
import 'package:qalenium_mobile/routes/pre_login/signin.dart';

import 'models/company.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:math';

late http.Response response;
List<Company> companies = [];

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  callCompaniesApi();
}

void callCompaniesApi() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceUuid = "";

  if (defaultTargetPlatform == TargetPlatform.android)  {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceUuid = androidInfo.androidId!;
  }
  else if (defaultTargetPlatform == TargetPlatform.iOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceUuid = iosInfo.identifierForVendor!;
  }
  else if (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows) {
    deviceUuid = const Uuid().v5(Uuid.NAMESPACE_OID, Random().toString());
  }
  else {
    deviceUuid = const Uuid().v5(Uuid.NAMESPACE_OID, Random().toString());
  }

  response = await http.get(Uri.parse('https://qalenium-api.herokuapp'
      '.com/company/getCompanyByDeviceId/' + deviceUuid));

  if (response.statusCode == 200) {
    try {
      List<dynamic> companiesDynamic = jsonDecode(response.body);
      companies = companiesDynamic.map((company) => Company
          .companyFromJson(company)).toList();
      runApp(const SplashRoute());
    } catch (e) {
      runApp(const SplashRoute());
    }
  }
}

class SplashRoute extends StatelessWidget {
  const SplashRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FlexSchemeData _myFlexScheme = FlexSchemeData(
      name: 'Midnight blue',
      description: 'Midnight blue theme, custom definition of all colors',
      light: FlexSchemeColor(
        primary: Color(int.parse(companies.isEmpty ? 'FF010B2C' : companies[0].primaryLightColor , radix: 16)),
        primaryVariant: Color(int.parse(companies.isEmpty ? 'FF151C2C' : companies[0].primaryLightColor , radix: 16)),
        secondary: Color(int.parse(companies.isEmpty ? 'FFFFCA24' : companies[0].primaryLightColor , radix: 16)),
        secondaryVariant: Color(int.parse(companies.isEmpty ? 'FF846C2A' : companies[0].primaryLightColor , radix: 16)),
      ),
      dark: FlexSchemeColor(
        primary: Color(int.parse(companies.isEmpty ? 'FF010B2C' : companies[0].primaryLightColor , radix: 16)),
        primaryVariant: Color(int.parse(companies.isEmpty ? 'FF151C2C' : companies[0].primaryLightColor , radix: 16)),
        secondary: Color(int.parse(companies.isEmpty ? 'FFFFCA24' : companies[0].primaryLightColor , radix: 16)),
        secondaryVariant: Color(int.parse(companies.isEmpty ? 'FF846C2A' : companies[0].primaryLightColor , radix: 16)),
      ),
    );

    return AnimatedBuilder(
      animation: ChangeNotifier(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Splash',
          theme: FlexThemeData.light(
            primary: _myFlexScheme.light.primary,
            primaryVariant: _myFlexScheme.light.primaryVariant,
            secondary: _myFlexScheme.light.secondary,
            secondaryVariant: _myFlexScheme.light.secondaryVariant,
          ),
          darkTheme: FlexThemeData.dark(
            primary: _myFlexScheme.dark.primary,
            primaryVariant: _myFlexScheme.dark.primaryVariant,
            secondary: _myFlexScheme.dark.secondary,
            secondaryVariant: _myFlexScheme.dark.secondaryVariant,
          ),
          themeMode: ThemeMode.system,
          home: SplashPage(title: 'Splash Page', flexSchemeData: _myFlexScheme),
        );
      },
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.title,
    required this.flexSchemeData}) : super(key: key);

  final String title;
  final FlexSchemeData flexSchemeData;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  void redirect() async {
    if (companies.isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInRoute(
                company: companies[0],
                flexSchemeData: widget.flexSchemeData
            ))
        );
      });
    } else {
      Future.delayed(Duration.zero, () async {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CompaniesRoute(
                flexSchemeData: widget.flexSchemeData
            ))
        );
      });
    }
    FlutterNativeSplash.remove();
  }
}
