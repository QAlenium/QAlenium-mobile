import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../../inherited_widgets/company_title.dart';

class CompanyTitleState extends StatefulWidget {
  const CompanyTitleState({Key? key}) : super(key: key);

  @override
  State<CompanyTitleState> createState(CompanyTitleStateState();
}

class _CompanyTitleStateState extends State<CompanyTitleState> {

  late CompanyTitle companyTitle;

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = companyTitle.logoUrlController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (!isURL(text)) {
      return "URL is invalid";
    }
    // return null if the text is valid
    return null;
  }

  @override
  void initState() {
    super.initState();
    companyTitle = context.dependOnInheritedWidgetOfExactType<CompanyTitle>()!;
  }

  @override
  Widget build(BuildContext context) {



    return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: FutureBuilder<void>(
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                return Image.network(
                  companyTitle.logoUrl,
                  semanticLabel: 'Company\'s logo',
                  width: 100,
                  height: 100,
                );
              },
            ),
          ),
          ElevatedButton.icon(
              label: const Text('Change logo'),
              icon: const Icon(
                Icons.edit,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Choose logo from URL"),
                      content: TextField(
                        controller: companyTitle.logoUrlController,
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
                              if (!isURL(companyTitle.logoUrlController.text,
                                  requireTld: false)) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                        content: Text('Invalid URL'),
                                      );
                                    });
                              } else {
                                companyTitle.logoUrl = companyTitle
                                  .logoUrlController.text;
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
            controller: companyTitle.companyNameTextController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Type company name',
            ),
          ),
        ]
    );
  }
}