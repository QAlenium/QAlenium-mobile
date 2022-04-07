import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../models/company.dart';
import '../../models/nav_bar.dart';
import '../../models/user.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({Key? key, required this.company, required this.user,
    required this.flexSchemeData}) : super(key: key);

  final User user;
  final Company company;
  final FlexSchemeData flexSchemeData;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
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
      home: SignInPage(title: 'Settings Page', company: company,
          user: user, flexSchemeData: flexSchemeData),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title, required this.company,
    required this.user, required this.flexSchemeData}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final User user;
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
        drawer: NavBar(
            flexSchemeData: widget.flexSchemeData,
            user: widget.user,
            company: widget.company
        ),
        body: const Center(

        )
    );
  }
}
