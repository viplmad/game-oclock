import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show DateLocaleConfig;

class CustomMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  final LocalizationsDelegate<MaterialLocalizations> delegate;
  final DateLocaleConfig dateConfig;

  CustomMaterialLocalizationsDelegate(this.delegate, this.dateConfig);

  @override
  Future<MaterialLocalizations> load(final Locale locale) async {
    return SynchronousFuture<MaterialLocalizations>(
      _CustomMaterialLocalizations(await delegate.load(locale), dateConfig),
    );
  }

  @override
  bool isSupported(final Locale locale) => delegate.isSupported(locale);

  @override
  bool shouldReload(final CustomMaterialLocalizationsDelegate old) =>
      old.dateConfig != dateConfig;

  @override
  String toString() => 'Custom $delegate';
}

class _CustomMaterialLocalizations extends MaterialLocalizations {
  final MaterialLocalizations delegate;
  final DateLocaleConfig dateConfig;

  _CustomMaterialLocalizations(this.delegate, this.dateConfig);

  @override
  int get firstDayOfWeekIndex => dateConfig.startingDayOfWeek != null
      ? dateConfig.startingDayOfWeek! % 7
      : delegate.firstDayOfWeekIndex;

  @override
  String get dateHelpText => dateConfig.dateFormat != null
      ? dateConfig.dateFormat!.pattern!
      : delegate.dateHelpText;

  @override
  String get dateSeparator => delegate.dateSeparator;

  @override
  String formatCompactDate(final DateTime date) => dateConfig.dateFormat != null
      ? dateConfig.dateFormat!.format(date)
      : delegate.formatCompactDate(date);

  @override
  String formatFullDate(final DateTime date) => delegate.formatFullDate(date);

  @override
  String formatHour(
    final TimeOfDay timeOfDay, {
    final bool alwaysUse24HourFormat = false,
  }) => delegate.formatHour(
    timeOfDay,
    alwaysUse24HourFormat: alwaysUse24HourFormat,
  );

  @override
  String formatMediumDate(final DateTime date) =>
      delegate.formatMediumDate(date);

  @override
  String formatMinute(final TimeOfDay timeOfDay) =>
      delegate.formatMinute(timeOfDay);

  @override
  String formatMonthYear(final DateTime date) => delegate.formatMonthYear(date);

  @override
  String formatShortDate(final DateTime date) => delegate.formatShortDate(date);

  @override
  String formatShortMonthDay(final DateTime date) =>
      delegate.formatShortMonthDay(date);

  @override
  String formatTimeOfDay(
    final TimeOfDay timeOfDay, {
    final bool alwaysUse24HourFormat = false,
  }) => dateConfig.timeFormat != null
      ? dateConfig.timeFormat!.format(
          DateTime(2020, 1, 1, timeOfDay.hour, timeOfDay.minute),
        )
      : delegate.formatTimeOfDay(
          timeOfDay,
          alwaysUse24HourFormat: alwaysUse24HourFormat,
        );

  @override
  String formatYear(final DateTime date) => delegate.formatYear(date);

  @override
  DateTime? parseCompactDate(final String? inputString) =>
      delegate.parseCompactDate(inputString);

  @override
  TimeOfDayFormat timeOfDayFormat({final bool alwaysUse24HourFormat = false}) =>
      delegate.timeOfDayFormat(alwaysUse24HourFormat: alwaysUse24HourFormat);

  //

  @override
  String get alertDialogLabel => delegate.alertDialogLabel;

  @override
  String get anteMeridiemAbbreviation => delegate.anteMeridiemAbbreviation;

  @override
  String get backButtonTooltip => delegate.backButtonTooltip;

  @override
  String get bottomSheetLabel => delegate.bottomSheetLabel;

  @override
  String get calendarModeButtonLabel => delegate.calendarModeButtonLabel;

  @override
  String get cancelButtonLabel => delegate.cancelButtonLabel;

  @override
  String get clearButtonTooltip => delegate.clearButtonTooltip;

  @override
  String get closeButtonLabel => delegate.closeButtonLabel;

  @override
  String get closeButtonTooltip => delegate.closeButtonTooltip;

  @override
  String get collapsedHint => delegate.collapsedHint;

  @override
  String get collapsedIconTapHint => delegate.collapsedIconTapHint;

  @override
  String get continueButtonLabel => delegate.continueButtonLabel;

  @override
  String get copyButtonLabel => delegate.copyButtonLabel;

  @override
  String get currentDateLabel => delegate.currentDateLabel;

  @override
  String get cutButtonLabel => delegate.cutButtonLabel;

  @override
  String get dateInputLabel => delegate.dateInputLabel;

  @override
  String get dateOutOfRangeLabel => delegate.dateOutOfRangeLabel;

  @override
  String get datePickerHelpText => delegate.datePickerHelpText;

  @override
  String get dateRangeEndLabel => delegate.dateRangeEndLabel;

  @override
  String get dateRangePickerHelpText => delegate.dateRangePickerHelpText;

  @override
  String get dateRangeStartLabel => delegate.dateRangeStartLabel;

  @override
  String get deleteButtonTooltip => delegate.deleteButtonTooltip;

  @override
  String get dialModeButtonLabel => delegate.dialModeButtonLabel;

  @override
  String get dialogLabel => delegate.dialogLabel;

  @override
  String get drawerLabel => delegate.drawerLabel;

  @override
  String get expandedHint => delegate.expandedHint;

  @override
  String get expandedIconTapHint => delegate.expandedIconTapHint;

  @override
  String get expansionTileCollapsedHint => delegate.expansionTileCollapsedHint;

  @override
  String get expansionTileCollapsedTapHint =>
      delegate.expansionTileCollapsedTapHint;

  @override
  String get expansionTileExpandedHint => delegate.expansionTileExpandedHint;

  @override
  String get expansionTileExpandedTapHint =>
      delegate.expansionTileExpandedTapHint;

  @override
  String get firstPageTooltip => delegate.firstPageTooltip;

  @override
  String get hideAccountsLabel => delegate.hideAccountsLabel;

  @override
  String get inputDateModeButtonLabel => delegate.inputDateModeButtonLabel;

  @override
  String get inputTimeModeButtonLabel => delegate.inputTimeModeButtonLabel;

  @override
  String get invalidDateFormatLabel => delegate.invalidDateFormatLabel;

  @override
  String get invalidDateRangeLabel => delegate.invalidDateRangeLabel;

  @override
  String get invalidTimeLabel => delegate.invalidTimeLabel;

  @override
  String get keyboardKeyAlt => delegate.keyboardKeyAlt;

  @override
  String get keyboardKeyAltGraph => delegate.keyboardKeyAltGraph;

  @override
  String get keyboardKeyBackspace => delegate.keyboardKeyBackspace;

  @override
  String get keyboardKeyCapsLock => delegate.keyboardKeyCapsLock;

  @override
  String get keyboardKeyChannelDown => delegate.keyboardKeyChannelDown;

  @override
  String get keyboardKeyChannelUp => delegate.keyboardKeyChannelUp;

  @override
  String get keyboardKeyControl => delegate.keyboardKeyControl;

  @override
  String get keyboardKeyDelete => delegate.keyboardKeyDelete;

  @override
  String get keyboardKeyEject => delegate.keyboardKeyEject;

  @override
  String get keyboardKeyEnd => delegate.keyboardKeyEnd;

  @override
  String get keyboardKeyEscape => delegate.keyboardKeyEscape;

  @override
  String get keyboardKeyFn => delegate.keyboardKeyFn;

  @override
  String get keyboardKeyHome => delegate.keyboardKeyHome;

  @override
  String get keyboardKeyInsert => delegate.keyboardKeyInsert;

  @override
  String get keyboardKeyMeta => delegate.keyboardKeyMeta;

  @override
  String get keyboardKeyMetaMacOs => delegate.keyboardKeyMetaMacOs;

  @override
  String get keyboardKeyMetaWindows => delegate.keyboardKeyMetaWindows;

  @override
  String get keyboardKeyNumLock => delegate.keyboardKeyNumLock;

  @override
  String get keyboardKeyNumpad0 => delegate.keyboardKeyNumpad0;

  @override
  String get keyboardKeyNumpad1 => delegate.keyboardKeyNumpad1;

  @override
  String get keyboardKeyNumpad2 => delegate.keyboardKeyNumpad2;

  @override
  String get keyboardKeyNumpad3 => delegate.keyboardKeyNumpad3;

  @override
  String get keyboardKeyNumpad4 => delegate.keyboardKeyNumpad4;

  @override
  String get keyboardKeyNumpad5 => delegate.keyboardKeyNumpad5;

  @override
  String get keyboardKeyNumpad6 => delegate.keyboardKeyNumpad6;

  @override
  String get keyboardKeyNumpad7 => delegate.keyboardKeyNumpad7;

  @override
  String get keyboardKeyNumpad8 => delegate.keyboardKeyNumpad8;

  @override
  String get keyboardKeyNumpad9 => delegate.keyboardKeyNumpad9;

  @override
  String get keyboardKeyNumpadAdd => delegate.keyboardKeyNumpadAdd;

  @override
  String get keyboardKeyNumpadComma => delegate.keyboardKeyNumpadComma;

  @override
  String get keyboardKeyNumpadDecimal => delegate.keyboardKeyNumpadDecimal;

  @override
  String get keyboardKeyNumpadDivide => delegate.keyboardKeyNumpadDivide;

  @override
  String get keyboardKeyNumpadEnter => delegate.keyboardKeyNumpadEnter;

  @override
  String get keyboardKeyNumpadEqual => delegate.keyboardKeyNumpadEqual;

  @override
  String get keyboardKeyNumpadMultiply => delegate.keyboardKeyNumpadMultiply;

  @override
  String get keyboardKeyNumpadParenLeft => delegate.keyboardKeyNumpadParenLeft;

  @override
  String get keyboardKeyNumpadParenRight =>
      delegate.keyboardKeyNumpadParenRight;

  @override
  String get keyboardKeyNumpadSubtract => delegate.keyboardKeyNumpadSubtract;

  @override
  String get keyboardKeyPageDown => delegate.keyboardKeyPageDown;

  @override
  String get keyboardKeyPageUp => delegate.keyboardKeyPageUp;

  @override
  String get keyboardKeyPower => delegate.keyboardKeyPower;

  @override
  String get keyboardKeyPowerOff => delegate.keyboardKeyPowerOff;

  @override
  String get keyboardKeyPrintScreen => delegate.keyboardKeyPrintScreen;

  @override
  String get keyboardKeyScrollLock => delegate.keyboardKeyScrollLock;

  @override
  String get keyboardKeySelect => delegate.keyboardKeySelect;

  @override
  String get keyboardKeyShift => delegate.keyboardKeyShift;

  @override
  String get keyboardKeySpace => delegate.keyboardKeySpace;

  @override
  String get lastPageTooltip => delegate.lastPageTooltip;

  @override
  String get licensesPageTitle => delegate.licensesPageTitle;

  @override
  String get lookUpButtonLabel => delegate.lookUpButtonLabel;

  @override
  String get menuBarMenuLabel => delegate.menuBarMenuLabel;

  @override
  String get menuDismissLabel => delegate.menuDismissLabel;

  @override
  String get modalBarrierDismissLabel => delegate.modalBarrierDismissLabel;

  @override
  String get moreButtonTooltip => delegate.moreButtonTooltip;

  @override
  String get nextMonthTooltip => delegate.nextMonthTooltip;

  @override
  String get nextPageTooltip => delegate.nextPageTooltip;

  @override
  String get okButtonLabel => delegate.okButtonLabel;

  @override
  String get openAppDrawerTooltip => delegate.openAppDrawerTooltip;

  @override
  String get pasteButtonLabel => delegate.pasteButtonLabel;

  @override
  String get popupMenuLabel => delegate.popupMenuLabel;

  @override
  String get postMeridiemAbbreviation => delegate.postMeridiemAbbreviation;

  @override
  String get previousMonthTooltip => delegate.previousMonthTooltip;

  @override
  String get previousPageTooltip => delegate.previousPageTooltip;

  @override
  String get refreshIndicatorSemanticLabel =>
      delegate.refreshIndicatorSemanticLabel;

  @override
  String get reorderItemDown => delegate.reorderItemDown;

  @override
  String get reorderItemLeft => delegate.reorderItemLeft;

  @override
  String get reorderItemRight => delegate.reorderItemRight;

  @override
  String get reorderItemToEnd => delegate.reorderItemToEnd;

  @override
  String get reorderItemToStart => delegate.reorderItemToStart;

  @override
  String get reorderItemUp => delegate.reorderItemUp;

  @override
  String get rowsPerPageTitle => delegate.rowsPerPageTitle;

  @override
  String get saveButtonLabel => delegate.saveButtonLabel;

  @override
  String get scanTextButtonLabel => delegate.scanTextButtonLabel;

  @override
  String get scrimLabel => delegate.scrimLabel;

  @override
  ScriptCategory get scriptCategory => delegate.scriptCategory;

  @override
  String get searchFieldLabel => delegate.searchFieldLabel;

  @override
  String get searchWebButtonLabel => delegate.searchWebButtonLabel;

  @override
  String get selectAllButtonLabel => delegate.selectAllButtonLabel;

  @override
  String get selectYearSemanticsLabel => delegate.selectYearSemanticsLabel;

  @override
  String get selectedDateLabel => delegate.selectedDateLabel;

  @override
  String get shareButtonLabel => delegate.shareButtonLabel;

  @override
  String get showAccountsLabel => delegate.showAccountsLabel;

  @override
  String get showMenuTooltip => delegate.showMenuTooltip;

  @override
  String get signedInLabel => delegate.signedInLabel;

  @override
  String get timePickerDialHelpText => delegate.timePickerDialHelpText;

  @override
  String get timePickerHourLabel => delegate.timePickerHourLabel;

  @override
  String get timePickerHourModeAnnouncement =>
      delegate.timePickerHourModeAnnouncement;

  @override
  String get timePickerInputHelpText => delegate.timePickerInputHelpText;

  @override
  String get timePickerMinuteLabel => delegate.timePickerMinuteLabel;

  @override
  String get timePickerMinuteModeAnnouncement =>
      delegate.timePickerMinuteModeAnnouncement;

  @override
  String get unspecifiedDate => delegate.unspecifiedDate;

  @override
  String get unspecifiedDateRange => delegate.unspecifiedDateRange;

  @override
  String get viewLicensesButtonLabel => delegate.viewLicensesButtonLabel;

  @override
  String aboutListTileTitle(final String applicationName) =>
      delegate.aboutListTileTitle(applicationName);

  @override
  String dateRangeEndDateSemanticLabel(final String formattedDate) =>
      delegate.dateRangeEndDateSemanticLabel(formattedDate);

  @override
  String dateRangeStartDateSemanticLabel(final String formattedDate) =>
      delegate.dateRangeStartDateSemanticLabel(formattedDate);

  @override
  String formatDecimal(final int number) => delegate.formatDecimal(number);

  @override
  String licensesPackageDetailText(final int licenseCount) =>
      delegate.licensesPackageDetailText(licenseCount);

  @override
  String pageRowsInfoTitle(
    final int firstRow,
    final int lastRow,
    final int rowCount,
    final bool rowCountIsApproximate,
  ) => delegate.pageRowsInfoTitle(
    firstRow,
    lastRow,
    rowCount,
    rowCountIsApproximate,
  );

  @override
  List<String> get narrowWeekdays => delegate.narrowWeekdays;

  @override
  String remainingTextFieldCharacterCount(final int remaining) =>
      delegate.remainingTextFieldCharacterCount(remaining);

  @override
  String scrimOnTapHint(final String modalRouteContentName) =>
      delegate.scrimOnTapHint(modalRouteContentName);

  @override
  String selectedRowCountTitle(final int selectedRowCount) =>
      delegate.selectedRowCountTitle(selectedRowCount);

  @override
  String tabLabel({required final int tabIndex, required final int tabCount}) =>
      delegate.tabLabel(tabIndex: tabIndex, tabCount: tabCount);
}
