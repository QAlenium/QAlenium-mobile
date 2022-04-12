import 'package:flutter/material.dart';

import '../../inherited_widgets/company_tools_setup.dart';

class CompanyToolsSetupState extends StatefulWidget {
  const CompanyToolsSetupState({Key? key}) : super(key: key);

  @override
  State<CompanyToolsSetupState> createState() => _CompanyToolsSetupStateState();
}

class _CompanyToolsSetupStateState extends State<CompanyToolsSetupState> {

  late CompanyToolSetup companyToolSetup;

  @override
  void initState() {
    super.initState();
    companyToolSetup = context.dependOnInheritedWidgetOfExactType<CompanyToolSetup>()!;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 600),
      expansionCallback: (panelIndex, isExpanded) {
        companyToolSetup.isToolsSetupExpanded = !companyToolSetup.isToolsSetupExpanded;
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
                  value: companyToolSetup.isContinuousQualityEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyToolSetup.isContinuousQualityEnabled = value;
                    });
                  }
              ),
              if (companyToolSetup.isContinuousQualityEnabled)
                Column(
                  children: [
                    SwitchListTile(
                        title: const Text('Token'),
                        secondary: const Icon(Icons.lock),
                        value: companyToolSetup.isContinuousQualityAuthTokenEnabled,
                        onChanged: (value) {
                          setState(() {
                            companyToolSetup.isContinuousQualityAuthTokenEnabled = value;
                          });
                        }
                    ),
                    TextFormField(
                      controller: companyToolSetup.continuousQualityURLTextController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Continuous Quality URL',
                      ),
                    ),
                    const Text('Leave token/credentials blank if '
                        'API '
                        'is public'),
                    if (companyToolSetup.isContinuousQualityAuthTokenEnabled)
                      Column(
                        children: [
                          TextFormField(
                            controller: companyToolSetup.continuousQualityTokenTextController,
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
                            controller: companyToolSetup.continuousQualityUsernameTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Continuous '
                                  'Quality Username',
                            ),
                          ),
                          TextFormField(
                            controller: companyToolSetup.continuousQualityPasswordTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Continuous '
                                  'Quality Password',
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              SwitchListTile(
                  title: const Text('CI/CD'),
                  secondary: const Icon(Icons.code),
                  value: companyToolSetup.isCiCdEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyToolSetup.isCiCdEnabled = value;
                    });
                  }
              ),
              if (companyToolSetup.isCiCdEnabled)
                Column(
                  children: [
                    SwitchListTile(
                        title: const Text('Token'),
                        secondary: const Icon(Icons.lock),
                        value: companyToolSetup.isCiCdAuthTokenEnabled,
                        onChanged: (value) {
                          setState(() {
                            companyToolSetup.isCiCdAuthTokenEnabled = value;
                          });
                        }
                    ),
                    TextFormField(
                      controller: companyToolSetup.ciCdURLTextController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'CI/CD URL',
                      ),
                    ),
                    const Text('Leave token/credentials blank if '
                        'API '
                        'is public'),
                    if (companyToolSetup.isCiCdAuthTokenEnabled)
                      Column(
                        children: [
                          TextFormField(
                            controller: companyToolSetup.ciCdTokenTextController,
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
                            controller: companyToolSetup.ciCdUsernameTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'CI/CD Username',
                            ),
                          ),
                          TextFormField(
                            controller: companyToolSetup.ciCdPasswordTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'CI/CD Password',
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              SwitchListTile(
                  title: const Text('Board/Kanban'),
                  secondary: const Icon(Icons.book),
                  value: companyToolSetup.isBoardKanbanEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyToolSetup.isBoardKanbanEnabled = value;
                    });
                  }
              ),
              if (companyToolSetup.isBoardKanbanEnabled)
                Column(
                  children: [
                    SwitchListTile(
                        title: const Text('Token'),
                        secondary: const Icon(Icons.lock),
                        value: companyToolSetup.isBoardKanbanAuthTokenEnabled,
                        onChanged: (value) {
                          setState(() {
                            companyToolSetup.isBoardKanbanAuthTokenEnabled = value;
                          });
                        }
                    ),
                    TextFormField(
                      controller: companyToolSetup.boardKanbanURLTextController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Board/Kanban URL',
                      ),
                    ),
                    const Text('Leave token/credentials blank if '
                        'API '
                        'is public'),
                    if (companyToolSetup.isBoardKanbanAuthTokenEnabled)
                      Column(
                        children: [
                          TextFormField(
                            controller:
                            companyToolSetup.boardKanbanTokenTextController,
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
                            controller: companyToolSetup.boardKanbanUsernameTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Board/Kanban Username',
                            ),
                          ),
                          TextFormField(
                            controller: companyToolSetup.boardKanbanPasswordTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Board/Kanban Password',
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              SwitchListTile(
                  title: const Text('Testing'),
                  secondary: const Icon(Icons.bug_report),
                  value: companyToolSetup.isTestingEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyToolSetup.isTestingEnabled = value;
                    });
                  }
              ),
              if (companyToolSetup.isTestingEnabled)
                Column(
                  children: [
                    SwitchListTile(
                        title: const Text('Token'),
                        secondary: const Icon(Icons.lock),
                        value: companyToolSetup.isTestingAuthTokenEnabled,
                        onChanged: (value) {
                          setState(() {
                            companyToolSetup.isTestingAuthTokenEnabled = value;
                          });
                        }
                    ),
                    TextFormField(
                      controller: companyToolSetup.testingURLTextController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Testing URL',
                      ),
                    ),
                    const Text('Leave token/credentials blank if '
                        'API '
                        'is public'),
                    if (companyToolSetup.isTestingAuthTokenEnabled)
                      Column(
                        children: [
                          TextFormField(
                            controller:
                            companyToolSetup.testingTokenTextController,
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
                            companyToolSetup.testingUsernameTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Testing Username',
                            ),
                          ),
                          TextFormField(
                            controller:
                            companyToolSetup.testingPasswordTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Testing Password',
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              SwitchListTile(
                  title: const Text('Messaging'),
                  secondary: const Icon(Icons.message),
                  value: companyToolSetup.isMessagingEnabled,
                  onChanged: (value) {
                    setState(() {
                      companyToolSetup.isMessagingEnabled = value;
                    });
                  }
              ),
              if (companyToolSetup.isMessagingEnabled)
                Column(
                  children: [
                    SwitchListTile(
                        title: const Text('Token'),
                        secondary: const Icon(Icons.lock),
                        value: companyToolSetup.isMessagingAuthTokenEnabled,
                        onChanged: (value) {
                          setState(() {
                            companyToolSetup.isMessagingAuthTokenEnabled = value;
                          });
                        }
                    ),
                    TextFormField(
                      controller: companyToolSetup.messagingURLTextController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Messaging URL',
                      ),
                    ),
                    const Text('Leave token/credentials blank if '
                        'API '
                        'is public'),
                    if (companyToolSetup.isMessagingAuthTokenEnabled)
                      Column(
                        children: [
                          TextFormField(
                            controller:
                            companyToolSetup.messagingTokenTextController,
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
                            companyToolSetup.messagingUsernameTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Messaging Username',
                            ),
                          ),
                          TextFormField(
                            controller:
                            companyToolSetup.messagingPasswordTextController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Messaging Password',
                            ),
                          ),
                        ],
                      )
                  ],
                ),
            ],
          ),
          isExpanded: companyToolSetup.isToolsSetupExpanded,
          canTapOnHeader: true,
        ),
      ],
    );
  }
}