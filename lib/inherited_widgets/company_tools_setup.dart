import 'package:flutter/widgets.dart';

class CompanyToolSetup extends InheritedWidget {
  CompanyToolSetup({
    Key? key,
    required this.continuousQualityURLTextController,
    required this.ciCdURLTextController,
    required this.boardKanbanURLTextController,
    required this.testingURLTextController,
    required this.messagingURLTextController,
    required this.isToolsSetupExpanded,
    required this.isContinuousQualityEnabled,
    required this.isCiCdEnabled,
    required this.isBoardKanbanEnabled,
    required this.isTestingEnabled,
    required this.isMessagingEnabled,
    required this.isContinuousQualityAuthTokenEnabled,
    required this.isCiCdAuthTokenEnabled,
    required this.isBoardKanbanAuthTokenEnabled,
    required this.isTestingAuthTokenEnabled,
    required this.isMessagingAuthTokenEnabled,
    required this.continuousQualityTokenTextController,
    required this.continuousQualityUsernameTextController,
    required this.continuousQualityPasswordTextController,
    required this.ciCdTokenTextController,
    required this.ciCdUsernameTextController,
    required this.ciCdPasswordTextController,
    required this.boardKanbanTokenTextController,
    required this.boardKanbanPasswordTextController,
    required this.boardKanbanUsernameTextController,
    required this.testingTokenTextController,
    required this.testingUsernameTextController,
    required this.testingPasswordTextController,
    required this.messagingTokenTextController,
    required this.messagingUsernameTextController,
    required this.messagingPasswordTextController,
    required Widget child
  }) : super(key: key, child: child);

  late final TextEditingController continuousQualityURLTextController;
  late final TextEditingController ciCdURLTextController;
  late final TextEditingController boardKanbanURLTextController;
  late final TextEditingController testingURLTextController;
  late final TextEditingController messagingURLTextController;

  late final bool isToolsSetupExpanded;
  late final bool isContinuousQualityEnabled;
  late final bool isCiCdEnabled;
  late final bool isBoardKanbanEnabled;
  late final bool isTestingEnabled;
  late final bool isMessagingEnabled;

  late final bool isContinuousQualityAuthTokenEnabled;
  late final bool isCiCdAuthTokenEnabled;
  late final bool isBoardKanbanAuthTokenEnabled;
  late final bool isTestingAuthTokenEnabled;
  late final bool isMessagingAuthTokenEnabled;

  late final TextEditingController continuousQualityTokenTextController;
  late final TextEditingController continuousQualityUsernameTextController;
  late final TextEditingController continuousQualityPasswordTextController;

  late final TextEditingController ciCdTokenTextController;
  late final TextEditingController ciCdUsernameTextController;
  late final TextEditingController ciCdPasswordTextController;

  late final TextEditingController boardKanbanTokenTextController;
  late final TextEditingController boardKanbanUsernameTextController;
  late final TextEditingController boardKanbanPasswordTextController;

  late final TextEditingController testingTokenTextController;
  late final TextEditingController testingUsernameTextController;
  late final TextEditingController testingPasswordTextController;

  late final TextEditingController messagingTokenTextController;
  late final TextEditingController messagingUsernameTextController;
  late final TextEditingController messagingPasswordTextController;

  static CompanyToolSetup? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CompanyToolSetup>();

  @override
  bool updateShouldNotify(CompanyToolSetup oldWidget) =>
      oldWidget.continuousQualityURLTextController != continuousQualityURLTextController &&
          oldWidget.ciCdURLTextController != ciCdURLTextController &&
          oldWidget.boardKanbanURLTextController != boardKanbanURLTextController &&
          oldWidget.testingURLTextController != testingURLTextController &&
          oldWidget.messagingURLTextController != messagingURLTextController &&
          oldWidget.isToolsSetupExpanded != isToolsSetupExpanded &&
          oldWidget.isContinuousQualityEnabled != isContinuousQualityEnabled &&
          oldWidget.isCiCdEnabled != isCiCdEnabled &&
          oldWidget.isBoardKanbanEnabled != isBoardKanbanEnabled &&
          oldWidget.isTestingEnabled != isTestingEnabled &&
          oldWidget.isMessagingEnabled != isMessagingEnabled &&
          oldWidget.isContinuousQualityAuthTokenEnabled != isContinuousQualityAuthTokenEnabled &&
          oldWidget.isCiCdAuthTokenEnabled != isCiCdAuthTokenEnabled &&
          oldWidget.isBoardKanbanAuthTokenEnabled != isBoardKanbanAuthTokenEnabled &&
          oldWidget.isTestingAuthTokenEnabled != isTestingAuthTokenEnabled &&
          oldWidget.isMessagingAuthTokenEnabled != isMessagingAuthTokenEnabled &&
          oldWidget.continuousQualityTokenTextController != continuousQualityTokenTextController &&
          oldWidget.continuousQualityUsernameTextController != continuousQualityUsernameTextController &&
          oldWidget.continuousQualityPasswordTextController != continuousQualityPasswordTextController &&
          oldWidget.ciCdTokenTextController != ciCdTokenTextController &&
          oldWidget.ciCdUsernameTextController != ciCdUsernameTextController &&
          oldWidget.ciCdPasswordTextController != ciCdPasswordTextController &&
          oldWidget.boardKanbanTokenTextController != boardKanbanTokenTextController &&
          oldWidget.boardKanbanUsernameTextController != boardKanbanUsernameTextController &&
          oldWidget.boardKanbanPasswordTextController != boardKanbanPasswordTextController &&
          oldWidget.testingTokenTextController != testingTokenTextController &&
          oldWidget.testingUsernameTextController != testingUsernameTextController &&
          oldWidget.testingPasswordTextController != testingPasswordTextController &&
          oldWidget.messagingTokenTextController != messagingTokenTextController &&
          oldWidget.messagingUsernameTextController != messagingUsernameTextController &&
          oldWidget.messagingPasswordTextController != messagingPasswordTextController;
}