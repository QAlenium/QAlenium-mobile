import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qalenium_mobile/routes/register/register_company_route.dart';

import 'package:http/http.dart' as http;
import 'package:qalenium_mobile/routes/signin_route.dart';

import '../models/company.dart';

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

  List<Company> companies = [];
  List<Company> _foundUsers = [];

  void _goToRegisterCompanyPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterCompanyRoute())
    );
  }

  void callCompaniesApi() async {
    http.Response response = await http.get(Uri.parse('https://qalenium-api.herokuapp'
        '.com/company/getcompanylist'));

    if (response.statusCode != 200) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Something went wrong. Please try again in a few '
                  'moments.'),
            );
          });
    } else {
      setState(() {
        List<dynamic> listCompanies = jsonDecode(response.body);
        companies = listCompanies.map((company) => Company.companyFromJson
          (company)).toList();
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Company> results = [];
    if (enteredKeyword.isEmpty) {
      results = companies;
    } else {
      results = companies
          .where((company) =>
          company.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUsers = results;
    });
  }


  @override
  void initState() {
    super.initState();
    callCompaniesApi();
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
        title: TextFormField(
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          maxLines: 1,
          decoration: const InputDecoration(
              hintText: "Type company here"
          ),
          onChanged: (value) => {
            _runFilter(value)
          },
        ),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: _foundUsers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () => {

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInRoute(company: companies[index])))
                },
                child: Card(
                  //semanticContainer: true,
                  //borderOnForeground: true,
                    shadowColor: Colors.black,
                    margin: const EdgeInsets.all(10),
                    shape:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white)
                    ),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: _foundUsers[index].logo == '' ?
                                Image.asset(
                                  'assets/logo_company.png',
                                  alignment: Alignment.center,
                                ) :
                                Image.memory(
                                  const Base64Decoder().convert
                                  (_foundUsers[index].logo),
                                  alignment: Alignment.center,
                                )
                            ),
                          ),
                          Text(_foundUsers[index].name),
                        ],
                      ),
                    )
                )
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToRegisterCompanyPage,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
