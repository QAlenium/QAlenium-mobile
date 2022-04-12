import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:qalenium_mobile/models/chart_card.dart';
import 'package:qalenium_mobile/routes/widgets/nav_bar.dart';
import 'package:qalenium_mobile/routes/widgets/theme_showcase.dart';
import 'package:validators/validators.dart';

import '../../models/company.dart';
import '../../models/user.dart';

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({
    Key? key,
    required this.flexSchemeData,
    required this.user,
    required this.company
  }) : super(key: key);

  final User user;
  final Company company;
  final FlexSchemeData flexSchemeData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company Settings',
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
      home: SettingsPage(
        title: 'Company Settings Page',
        flexSchemeData: flexSchemeData,
        user: user,
        company: company,
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.title, required this
      .flexSchemeData, required this.user, required this.company}) : super(key:
  key);

  final Company company;
  final User user;
  final String title;
  final FlexSchemeData flexSchemeData;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

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

  String logoUrl = '';

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
  bool isChartSetupExpanded = false;
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
  int touchedIndex = -1;
  List<ChartCard> charts = [];

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

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(padding: const EdgeInsets.only(top: 16), child: text);
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 5, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, 5, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, 9, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow.darken(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: primaryColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  bool _passwordVisible = true;
  bool _rePasswordVisible = true;

  @override
  void initState() {
    super.initState();

    _passwordVisible = false;
    _rePasswordVisible = false;

    var pieChartCard = ChartCard(title: "Pie Chart",
      isSelected: false,
      chartType: "pie",
    );

    var horizontalBarChartCard = ChartCard(title: "Bar Chart",
      isSelected: false,
      chartType: "bar",
    );

    var verticalBarChartCard = ChartCard(title: "Radar Chart",
      isSelected: false,
      chartType: "radar",
    );

    var lineChartCard = ChartCard(title: "Line Chart",
      isSelected: false,
      chartType: "line",
    );

    logoUrl = widget.company.logo;

    charts = [pieChartCard, horizontalBarChartCard, verticalBarChartCard,
      lineChartCard];

    isLoginUsingGithubEnabled = widget.company.loginGit;
    isLoginUsingAppleEnabled = widget.company.loginApple;
    isLoginUsingEmailEnabled = widget.company.loginEmail;
    isLoginUsingFacebookEnabled = widget.company.loginFacebook;

    companyNameTextController.text = widget.company.name;

    primaryColor = Color(int.parse(widget.company.primaryLightColor, radix: 16));
    primaryVariantColor = Color(int.parse(widget.company.primaryLightVariantColor, radix: 16));
    secondaryColor = Color(int.parse(widget.company.secondaryLightColor, radix: 16));
    secondaryVariantColor = Color(int.parse(widget.company.secondaryLightVariantColor, radix: 16));

    //primaryDarkColor = Color(int.parse(widget.company.primaryDarkColor));
    //primaryDarkVariantColor = Color(int.parse(widget.company.primaryDarkVariantColor));
    //secondaryDarkColor = Color(int.parse(widget.company.secondaryDarkColor));
    //secondaryDarkVariantColor = Color(int.parse(widget.company.secondaryDarkVariantColor));

    if (widget.company.continuousQualityUrl != "") {
      isContinuousQualityEnabled = true;
      continuousQualityURLTextController.text = widget.company.continuousQualityUrl;

      // if (widget.company.continuousQualityAuth.contains(":")) {
      //   isContinuousQualityAuthTokenEnabled = false;
      //   continuousQualityUsernameTextController.text = "";
      //   continuousQualityPasswordTextController.text = "";
      // } else {
      //   isContinuousQualityAuthTokenEnabled = true;
      //   continuousQualityTokenTextController.text = "";
      // }
    }

    if (widget.company.ciCdUrl != "") {
      isCiCdEnabled = true;
      ciCdURLTextController.text = widget.company.ciCdUrl;

      // if (widget.company.ciCdAuth.contains(":")) {
      //   isCiCdAuthTokenEnabled = false;
      //   ciCdUsernameTextController.text = "";
      //   ciCdPasswordTextController.text = "";
      // } else {
      //   isCiCdAuthTokenEnabled = true;
      //   ciCdTokenTextController.text = "";
      // }
    }

    if (widget.company.boardKanbanUrl != "") {
      isBoardKanbanEnabled = true;
      boardKanbanURLTextController.text = widget.company.boardKanbanUrl;

      // if (widget.company.boardKanbanAuth.contains(":")) {
      //   isBoardKanbanAuthTokenEnabled = false;
      //   boardKanbanUsernameTextController.text = "";
      //   boardKanbanPasswordTextController.text = "";
      // } else {
      //   isBoardKanbanAuthTokenEnabled = true;
      //   boardKanbanTokenTextController.text = "";
      // }
    }

    if (widget.company.testingUrl != "") {
      isTestingEnabled = true;
      testingURLTextController.text = widget.company.testingUrl;

      // if (widget.company.testingAuth.contains(":")) {
      //   isTestingAuthTokenEnabled = false;
      //   testingUsernameTextController.text = "";
      //   testingPasswordTextController.text = "";
      // } else {
      //   isTestingAuthTokenEnabled = true;
      //   testingTokenTextController.text = "";
      // }
    }

    if (widget.company.messagingUrl != "") {
      isMessagingEnabled = true;
      messagingURLTextController.text = widget.company.messagingUrl;

      // if (widget.company.messagingAuth.contains(":")) {
      //   isMessagingAuthTokenEnabled = false;
      //   messagingUsernameTextController.text = "";
      //   messagingPasswordTextController.text = "";
      // } else {
      //   isMessagingAuthTokenEnabled = true;
      //   messagingTokenTextController.text = "";
      // }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      drawer: NavBar(
          flexSchemeData: widget.flexSchemeData,
          user: widget.user,
          company: widget.company),
      body: Center(
        child: Form(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(0),
                      child: FutureBuilder<void>(
                        //future: retrieveLostData(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          return Image.network(
                            logoUrl,
                            semanticLabel: 'Company\'s logo',
                            width: 100,
                            height: 100,
                          );
                        },
                      )
                  ),
                  ElevatedButton.icon(
                      label: const Text('Change logo'),
                      icon: const Icon(
                        Icons.edit,
                      ),
                      onPressed: () async {
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
                            const Text("Create admin account"),
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
                                            hintText: 'Quality password',
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
                  ExpansionPanelList(
                    animationDuration: const Duration(milliseconds: 600),
                    expansionCallback: (panelIndex, isExpanded) {
                      isChartSetupExpanded = !isChartSetupExpanded;
                      setState(() {

                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return const ListTile(
                            title: Text('Charts Setup', style:
                            TextStyle(color: Colors.black),
                            ),
                          );
                        },
                        body: Column(
                          children: [
                            if (isContinuousQualityEnabled) Column(
                              children: [
                                const Text("Select Quality Chart Type"),
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => {

                                      },
                                      child: AspectRatio(
                                        aspectRatio: 5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          color: primaryColor,
                                          child: Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: charts[index].chartType == "pie" ?
                                                PieChart(
                                                  PieChartData(
                                                    sections: List.filled(5,
                                                        PieChartSectionData(value: 1.0)),
                                                    pieTouchData: PieTouchData(),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "line" ? LineChart(
                                                  LineChartData(
                                                    lineBarsData: List.filled(1,
                                                        LineChartBarData(
                                                            spots: [
                                                              const FlSpot(1.0, 2.0),
                                                              const FlSpot(2.0, 5.0),
                                                              const FlSpot(3.0, 3.0),
                                                              const FlSpot(4.0, 4.0),
                                                              const FlSpot(5.0, 3.0),
                                                            ])),
                                                    lineTouchData: LineTouchData(
                                                        touchTooltipData: LineTouchTooltipData()
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "bar"
                                                    ? BarChart(
                                                  BarChartData(
                                                    barTouchData: BarTouchData(
                                                        touchTooltipData: BarTouchTooltipData(

                                                        )
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    barGroups: List.generate(3,
                                                            (i) {
                                                          switch (i) {
                                                            case 0:
                                                              return makeGroupData(0, 3, isTouched: i == touchedIndex);
                                                            case 1:
                                                              return makeGroupData(1, 17, isTouched: i == touchedIndex);
                                                            case 2:
                                                              return makeGroupData(2, 8, isTouched: i == touchedIndex);
                                                            default:
                                                              return throw Error();
                                                          }
                                                        }),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : RadarChart(
                                                  RadarChartData(
                                                    borderData: FlBorderData(show: false),
                                                    dataSets: [
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 2.0))
                                                      ),
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 7.0))
                                                      ),
                                                      RadarDataSet(dataEntries: List.filled(5, const RadarEntry(value: 4.0))
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                        child: Padding(
                                                          padding: const
                                                          EdgeInsets.all(0.0),
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: IconButton(
                                                              icon:
                                                              charts[index]
                                                                  .isSelected ?
                                                              const Icon(Icons
                                                                  .check_circle) : const
                                                              Icon(Icons
                                                                  .radio_button_unchecked),
                                                              color: const Color(0xff0f4a3c),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (charts[index].isSelected) {
                                                                    charts[index].isSelected = false;
                                                                  } else {
                                                                    charts[index].isSelected = true;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            if (isCiCdEnabled) Column(
                              children: [
                                const Text("Select CI/CD Chart Type"),
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => {

                                      },
                                      child: AspectRatio(
                                        aspectRatio: 5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          color: primaryColor,
                                          child: Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: charts[index].chartType == "pie" ?
                                                PieChart(
                                                  PieChartData(
                                                    sections: List.filled(5,
                                                        PieChartSectionData(value: 1.0)),
                                                    pieTouchData: PieTouchData(),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "line" ? LineChart(
                                                  LineChartData(
                                                    lineBarsData: List.filled(1,
                                                        LineChartBarData(
                                                            spots: [
                                                              const FlSpot(1.0, 2.0),
                                                              const FlSpot(2.0, 5.0),
                                                              const FlSpot(3.0, 3.0),
                                                              const FlSpot(4.0, 4.0),
                                                              const FlSpot(5.0, 3.0),
                                                            ])),
                                                    lineTouchData: LineTouchData(
                                                        touchTooltipData: LineTouchTooltipData()
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "bar"
                                                    ? BarChart(
                                                  BarChartData(
                                                    barTouchData: BarTouchData(
                                                        touchTooltipData: BarTouchTooltipData(

                                                        )
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    barGroups: List.generate(3,
                                                            (i) {
                                                          switch (i) {
                                                            case 0:
                                                              return makeGroupData(0, 3, isTouched: i == touchedIndex);
                                                            case 1:
                                                              return makeGroupData(1, 17, isTouched: i == touchedIndex);
                                                            case 2:
                                                              return makeGroupData(2, 8, isTouched: i == touchedIndex);
                                                            default:
                                                              return throw Error();
                                                          }
                                                        }),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : RadarChart(
                                                  RadarChartData(
                                                    borderData: FlBorderData(show: false),
                                                    dataSets: [
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 2.0))
                                                      ),
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 7.0))
                                                      ),
                                                      RadarDataSet(dataEntries: List.filled(5, const RadarEntry(value: 4.0))
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                        child: Padding(
                                                          padding: const
                                                          EdgeInsets.all(0.0),
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: IconButton(
                                                              icon:
                                                              charts[index]
                                                                  .isSelected ?
                                                              const Icon(Icons
                                                                  .check_circle) : const
                                                              Icon(Icons
                                                                  .radio_button_unchecked),
                                                              color: const Color(0xff0f4a3c),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (charts[index].isSelected) {
                                                                    charts[index].isSelected = false;
                                                                  } else {
                                                                    charts[index].isSelected = true;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            if (isBoardKanbanEnabled) Column(
                              children: [
                                const Text("Select Board/Kanban Chart Type"),
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => {

                                      },
                                      child: AspectRatio(
                                        aspectRatio: 5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          color: primaryColor,
                                          child: Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: charts[index].chartType == "pie" ?
                                                PieChart(
                                                  PieChartData(
                                                    sections: List.filled(5,
                                                        PieChartSectionData(value: 1.0)),
                                                    pieTouchData: PieTouchData(),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "line" ? LineChart(
                                                  LineChartData(
                                                    lineBarsData: List.filled(1,
                                                        LineChartBarData(
                                                            spots: [
                                                              const FlSpot(1.0, 2.0),
                                                              const FlSpot(2.0, 5.0),
                                                              const FlSpot(3.0, 3.0),
                                                              const FlSpot(4.0, 4.0),
                                                              const FlSpot(5.0, 3.0),
                                                            ])),
                                                    lineTouchData: LineTouchData(
                                                        touchTooltipData: LineTouchTooltipData()
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "bar"
                                                    ? BarChart(
                                                  BarChartData(
                                                    barTouchData: BarTouchData(
                                                        touchTooltipData: BarTouchTooltipData(

                                                        )
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    barGroups: List.generate(3,
                                                            (i) {
                                                          switch (i) {
                                                            case 0:
                                                              return makeGroupData(0, 3, isTouched: i == touchedIndex);
                                                            case 1:
                                                              return makeGroupData(1, 17, isTouched: i == touchedIndex);
                                                            case 2:
                                                              return makeGroupData(2, 8, isTouched: i == touchedIndex);
                                                            default:
                                                              return throw Error();
                                                          }
                                                        }),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : RadarChart(
                                                  RadarChartData(
                                                    borderData: FlBorderData(show: false),
                                                    dataSets: [
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 2.0))
                                                      ),
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 7.0))
                                                      ),
                                                      RadarDataSet(dataEntries: List.filled(5, const RadarEntry(value: 4.0))
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                        child: Padding(
                                                          padding: const
                                                          EdgeInsets.all(0.0),
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: IconButton(
                                                              icon:
                                                              charts[index]
                                                                  .isSelected ?
                                                              const Icon(Icons
                                                                  .check_circle) : const
                                                              Icon(Icons
                                                                  .radio_button_unchecked),
                                                              color: const Color(0xff0f4a3c),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (charts[index].isSelected) {
                                                                    charts[index].isSelected = false;
                                                                  } else {
                                                                    charts[index].isSelected = true;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            if (isTestingEnabled) Column(
                              children: [
                                const Text("Select Testing Chart Type"),
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => {

                                      },
                                      child: AspectRatio(
                                        aspectRatio: 5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          color: primaryColor,
                                          child: Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: charts[index].chartType == "pie" ?
                                                PieChart(
                                                  PieChartData(
                                                    sections: List.filled(5,
                                                        PieChartSectionData(value: 1.0)),
                                                    pieTouchData: PieTouchData(),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "line" ? LineChart(
                                                  LineChartData(
                                                    lineBarsData: List.filled(1,
                                                        LineChartBarData(
                                                            spots: [
                                                              const FlSpot(1.0, 2.0),
                                                              const FlSpot(2.0, 5.0),
                                                              const FlSpot(3.0, 3.0),
                                                              const FlSpot(4.0, 4.0),
                                                              const FlSpot(5.0, 3.0),
                                                            ])),
                                                    lineTouchData: LineTouchData(
                                                        touchTooltipData: LineTouchTooltipData()
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "bar"
                                                    ? BarChart(
                                                  BarChartData(
                                                    barTouchData: BarTouchData(
                                                        touchTooltipData: BarTouchTooltipData(

                                                        )
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    barGroups: List.generate(3,
                                                            (i) {
                                                          switch (i) {
                                                            case 0:
                                                              return makeGroupData(0, 3, isTouched: i == touchedIndex);
                                                            case 1:
                                                              return makeGroupData(1, 17, isTouched: i == touchedIndex);
                                                            case 2:
                                                              return makeGroupData(2, 8, isTouched: i == touchedIndex);
                                                            default:
                                                              return throw Error();
                                                          }
                                                        }),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : RadarChart(
                                                  RadarChartData(
                                                    borderData: FlBorderData(show: false),
                                                    dataSets: [
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 2.0))
                                                      ),
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 7.0))
                                                      ),
                                                      RadarDataSet(dataEntries: List.filled(5, const RadarEntry(value: 4.0))
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                        child: Padding(
                                                          padding: const
                                                          EdgeInsets.all(0.0),
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: IconButton(
                                                              icon:
                                                              charts[index]
                                                                  .isSelected ?
                                                              const Icon(Icons
                                                                  .check_circle) : const
                                                              Icon(Icons
                                                                  .radio_button_unchecked),
                                                              color: const Color(0xff0f4a3c),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (charts[index].isSelected) {
                                                                    charts[index].isSelected = false;
                                                                  } else {
                                                                    charts[index].isSelected = true;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            if (isMessagingEnabled) Column(
                              children: [
                                const Text("Select Messaging Chart type"),
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () => {

                                      },
                                      child: AspectRatio(
                                        aspectRatio: 5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                          color: primaryColor,
                                          child: Stack(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: charts[index].chartType == "pie" ?
                                                PieChart(
                                                  PieChartData(
                                                    sections: List.filled(5,
                                                        PieChartSectionData(value: 1.0)),
                                                    pieTouchData: PieTouchData(),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "line" ? LineChart(
                                                  LineChartData(
                                                    lineBarsData: List.filled(1,
                                                        LineChartBarData(
                                                            spots: [
                                                              const FlSpot(1.0, 2.0),
                                                              const FlSpot(2.0, 5.0),
                                                              const FlSpot(3.0, 3.0),
                                                              const FlSpot(4.0, 4.0),
                                                              const FlSpot(5.0, 3.0),
                                                            ])),
                                                    lineTouchData: LineTouchData(
                                                        touchTooltipData: LineTouchTooltipData()
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : charts[index].chartType == "bar"
                                                    ? BarChart(
                                                  BarChartData(
                                                    barTouchData: BarTouchData(
                                                        touchTooltipData: BarTouchTooltipData(

                                                        )
                                                    ),
                                                    titlesData: FlTitlesData(
                                                        show: false
                                                    ),
                                                    barGroups: List.generate(3,
                                                            (i) {
                                                          switch (i) {
                                                            case 0:
                                                              return makeGroupData(0, 3, isTouched: i == touchedIndex);
                                                            case 1:
                                                              return makeGroupData(1, 17, isTouched: i == touchedIndex);
                                                            case 2:
                                                              return makeGroupData(2, 8, isTouched: i == touchedIndex);
                                                            default:
                                                              return throw Error();
                                                          }
                                                        }),
                                                    gridData: FlGridData(show: false),
                                                    borderData: FlBorderData(show: false),
                                                  ),
                                                ) : RadarChart(
                                                  RadarChartData(
                                                    borderData: FlBorderData(show: false),
                                                    dataSets: [
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 2.0))
                                                      ),
                                                      RadarDataSet(
                                                          dataEntries: List.filled(5, const RadarEntry(value: 7.0))
                                                      ),
                                                      RadarDataSet(dataEntries: List.filled(5, const RadarEntry(value: 4.0))
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                        child: Padding(
                                                          padding: const
                                                          EdgeInsets.all(0.0),
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: IconButton(
                                                              icon:
                                                              charts[index]
                                                                  .isSelected ?
                                                              const Icon(Icons
                                                                  .check_circle) : const
                                                              Icon(Icons
                                                                  .radio_button_unchecked),
                                                              color: const Color(0xff0f4a3c),
                                                              onPressed: () {
                                                                setState(() {
                                                                  if (charts[index].isSelected) {
                                                                    charts[index].isSelected = false;
                                                                  } else {
                                                                    charts[index].isSelected = true;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                        isExpanded: isChartSetupExpanded,
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                  ElevatedButton(
                      child: const Text('Update'),
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

                        if (emailTextController.text.isNotEmpty) {

                          if (passwordTextController.text.isEmpty ||
                              rePasswordTextController.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('Password fields must not be '
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

                          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                          String deviceUuid = "";

                          if (Platform.isAndroid) {
                            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                            deviceUuid = androidInfo.androidId!;
                          } else if (Platform.isIOS) {
                            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                            deviceUuid = iosInfo.identifierForVendor!;
                          }

                          final userResponse = await http
                              .post(Uri.parse('https://qalenium-api.herokuapp'
                              '.com/user/signup/' + widget.company.companyId.toString()),
                              headers: <String, String> {
                                'Content-Type':'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(<String, String>{
                                'email': emailTextController.text,
                                'auth': sha512.convert(utf8.encode
                                  (emailTextController.text + ':' +
                                    passwordTextController.text)).toString(),
                                'companyId': widget.company.companyId.toString(),
                                'deviceId': deviceUuid,
                                'isAdmin': true.toString()
                              })
                          );

                          if (userResponse.statusCode == 200) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    content: Text('User created '
                                        'successfully!'),
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(userResponse.body),
                                  );
                                });
                            return;
                          }
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

                        final companyUpdateResponse = await http
                            .put(Uri.parse('https://qalenium-api.herokuapp'
                            '.com/company/updateCompany/' + widget.company
                            .companyId.toString()),
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

                        if (companyUpdateResponse.statusCode == 200) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text("Company updated successfully"),
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(companyUpdateResponse.body),
                                );
                              });
                        }
                      }
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
