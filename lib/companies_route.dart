import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:qalenium_mobile/register_company_route.dart';
import 'package:qalenium_mobile/signin_route.dart';

class CompaniesRoute extends StatelessWidget {
  const CompaniesRoute({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QAlenium',
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
      home: const CompaniesPage(title: 'QAlenium Companies Page'),
    );
  }
}

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {

  void _goToRegisterCompanyPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterCompanyRoute())
    );
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
        title: const TextField(
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Type company here"
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(20, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInRoute())
              );
            },
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToRegisterCompanyPage,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
