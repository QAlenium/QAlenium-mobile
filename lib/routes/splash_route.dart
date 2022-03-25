import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:qalenium_mobile/routes/companies_route.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const SplashRoute());
}

class SplashRoute extends StatelessWidget {
  const SplashRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const FlexSchemeData _myFlexScheme = FlexSchemeData(
      name: 'Midnight blue',
      description: 'Midnight blue theme, custom definition of all colors',
      light: FlexSchemeColor(
        primary: Color(0xFF071330),
        primaryVariant: Color(0xFF071330),
        secondary: Color(0xFFFFC929),
        secondaryVariant: Color(0xFFFFC929)
      ),
      dark: FlexSchemeColor(
          primary: Color(0xFF071330),
          primaryVariant: Color(0xFF071330),
          secondary: Color(0xFFFFC929),
          secondaryVariant: Color(0xFFFFC929)
      ),
    );

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
      home: const SplashPage(title: 'Splash Page', flexSchemeData: _myFlexScheme),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.title, required this.flexSchemeData}) : super
      (key:
    key);

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
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    callInitApis();
  }

  void callInitApis() {

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // String deviceUuid = "";
    //
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   deviceUuid = androidInfo.androidId!;
    // } else if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   deviceUuid = iosInfo.identifierForVendor!;
    // }
    //
    // http.Response response = await http.get(Uri.parse('https://qalenium-api.herokuapp'
    //     '.com/company/getCompanyByDeviceId/' + deviceUuid));
    //
    // if (response.statusCode == 200) {
    //   List<dynamic> companiesDynamic = jsonDecode(response.body);
    //   List<Company> companies = companiesDynamic.map((company) => Company
    //       .companyFromJson(company)).toList();
    //
    //   if (companies.length > 1) {
    //     //TODO redirect to a page that contains only the returned companies
    //     //TODO plus a button to return to the companies list route
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return const AlertDialog(
    //             content: Text('Device is associated to more than one company,'
    //                 ' hence, redirecting to a page that contains only the '
    //                 'associated companies'),
    //           );
    //         });
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const CompaniesRoute())
    //     );
    //   } else {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const CompaniesRoute())
    //     );
    //   }
    // } else {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return const AlertDialog(
    //           content: Text('Something went wrong. Please try closing the app '
    //               'and reopening it. If the error persist, contact the '
    //               'administrator.'),
    //         );
    //       });
    // }

    Future.delayed(Duration.zero, () async {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompaniesRoute(flexSchemeData: widget.flexSchemeData))
      );
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return const Scaffold();
  }
}
