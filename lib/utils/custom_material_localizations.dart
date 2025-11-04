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

class _CustomMaterialLocalizations extends _DelegateMaterialLocalizations {
  final DateLocaleConfig dateConfig;

  _CustomMaterialLocalizations(super.delegate, this.dateConfig);

  @override
  int get firstDayOfWeekIndex => dateConfig.startingDayOfWeek != null
      ? dateConfig.startingDayOfWeek! % 7
      : super.firstDayOfWeekIndex;

  @override
  String get dateHelpText => dateConfig.dateFormat != null
      ? dateConfig.dateFormat!.pattern!
      : super.dateHelpText;

  @override
  String get dateSeparator => super.dateSeparator;

  @override
  String formatCompactDate(final DateTime date) => dateConfig.dateFormat != null
      ? dateConfig.dateFormat!.format(date)
      : super.formatCompactDate(date);

  @override
  String formatFullDate(final DateTime date) => super.formatFullDate(date);

  @override
  String formatMediumDate(final DateTime date) => super.formatMediumDate(date);

  @override
  String formatShortDate(final DateTime date) => super.formatShortDate(date);

  @override
  String formatTimeOfDay(
    final TimeOfDay timeOfDay, {
    final bool alwaysUse24HourFormat = false,
  }) => dateConfig.timeFormat != null
      ? dateConfig.timeFormat!.format(
          DateTime(2020, 1, 1, timeOfDay.hour, timeOfDay.minute),
        )
      : super.formatTimeOfDay(
          timeOfDay,
          alwaysUse24HourFormat: alwaysUse24HourFormat,
        );

  @override
  DateTime? parseCompactDate(final String? inputString) =>
      super.parseCompactDate(inputString);

  @override
  TimeOfDayFormat timeOfDayFormat({final bool alwaysUse24HourFormat = false}) =>
      super.timeOfDayFormat(alwaysUse24HourFormat: alwaysUse24HourFormat);
}

abstract class _DelegateMaterialLocalizations extends MaterialLocalizations {
  final MaterialLocalizations _delegate;

  _DelegateMaterialLocalizations(this._delegate);

  @override
  String get alertDialogLabel => _delegate.alertDialogLabel;

  @override
  String get anteMeridiemAbbreviation => _delegate.anteMeridiemAbbreviation;

  @override
  String get backButtonTooltip => _delegate.backButtonTooltip;

  @override
  String get bottomSheetLabel => _delegate.bottomSheetLabel;

  @override
  String get calendarModeButtonLabel => _delegate.calendarModeButtonLabel;

  @override
  String get cancelButtonLabel => _delegate.cancelButtonLabel;

  @override
  String get clearButtonTooltip => _delegate.clearButtonTooltip;

  @override
  String get closeButtonLabel => _delegate.closeButtonLabel;

  @override
  String get closeButtonTooltip => _delegate.closeButtonTooltip;

  @override
  String get collapsedHint => _delegate.collapsedHint;

  @override
  String get collapsedIconTapHint => _delegate.collapsedIconTapHint;

  @override
  String get continueButtonLabel => _delegate.continueButtonLabel;

  @override
  String get copyButtonLabel => _delegate.copyButtonLabel;

  @override
  String get currentDateLabel => _delegate.currentDateLabel;

  @override
  String get cutButtonLabel => _delegate.cutButtonLabel;

  @override
  String get dateHelpText => _delegate.dateHelpText;

  @override
  String get dateInputLabel => _delegate.dateInputLabel;

  @override
  String get dateOutOfRangeLabel => _delegate.dateOutOfRangeLabel;

  @override
  String get datePickerHelpText => _delegate.datePickerHelpText;

  @override
  String get dateRangeEndLabel => _delegate.dateRangeEndLabel;

  @override
  String get dateRangePickerHelpText => _delegate.dateRangePickerHelpText;

  @override
  String get dateRangeStartLabel => _delegate.dateRangeStartLabel;

  @override
  String get dateSeparator => _delegate.dateSeparator;

  @override
  String get deleteButtonTooltip => _delegate.deleteButtonTooltip;

  @override
  String get dialModeButtonLabel => _delegate.dialModeButtonLabel;

  @override
  String get dialogLabel => _delegate.dialogLabel;

  @override
  String get drawerLabel => _delegate.drawerLabel;

  @override
  String get expandedHint => _delegate.expandedHint;

  @override
  String get expandedIconTapHint => _delegate.expandedIconTapHint;

  @override
  String get expansionTileCollapsedHint => _delegate.expansionTileCollapsedHint;

  @override
  String get expansionTileCollapsedTapHint =>
      _delegate.expansionTileCollapsedTapHint;

  @override
  String get expansionTileExpandedHint => _delegate.expansionTileExpandedHint;

  @override
  String get expansionTileExpandedTapHint =>
      _delegate.expansionTileExpandedTapHint;

  @override
  int get firstDayOfWeekIndex => _delegate.firstDayOfWeekIndex;

  @override
  String get firstPageTooltip => _delegate.firstPageTooltip;

  @override
  String get hideAccountsLabel => _delegate.hideAccountsLabel;

  @override
  String get inputDateModeButtonLabel => _delegate.inputDateModeButtonLabel;

  @override
  String get inputTimeModeButtonLabel => _delegate.inputTimeModeButtonLabel;

  @override
  String get invalidDateFormatLabel => _delegate.invalidDateFormatLabel;

  @override
  String get invalidDateRangeLabel => _delegate.invalidDateRangeLabel;

  @override
  String get invalidTimeLabel => _delegate.invalidTimeLabel;

  @override
  String get keyboardKeyAlt => _delegate.keyboardKeyAlt;

  @override
  String get keyboardKeyAltGraph => _delegate.keyboardKeyAltGraph;

  @override
  String get keyboardKeyBackspace => _delegate.keyboardKeyBackspace;

  @override
  String get keyboardKeyCapsLock => _delegate.keyboardKeyCapsLock;

  @override
  String get keyboardKeyChannelDown => _delegate.keyboardKeyChannelDown;

  @override
  String get keyboardKeyChannelUp => _delegate.keyboardKeyChannelUp;

  @override
  String get keyboardKeyControl => _delegate.keyboardKeyControl;

  @override
  String get keyboardKeyDelete => _delegate.keyboardKeyDelete;

  @override
  String get keyboardKeyEject => _delegate.keyboardKeyEject;

  @override
  String get keyboardKeyEnd => _delegate.keyboardKeyEnd;

  @override
  String get keyboardKeyEscape => _delegate.keyboardKeyEscape;

  @override
  String get keyboardKeyFn => _delegate.keyboardKeyFn;

  @override
  String get keyboardKeyHome => _delegate.keyboardKeyHome;

  @override
  String get keyboardKeyInsert => _delegate.keyboardKeyInsert;

  @override
  String get keyboardKeyMeta => _delegate.keyboardKeyMeta;

  @override
  String get keyboardKeyMetaMacOs => _delegate.keyboardKeyMetaMacOs;

  @override
  String get keyboardKeyMetaWindows => _delegate.keyboardKeyMetaWindows;

  @override
  String get keyboardKeyNumLock => _delegate.keyboardKeyNumLock;

  @override
  String get keyboardKeyNumpad0 => _delegate.keyboardKeyNumpad0;

  @override
  String get keyboardKeyNumpad1 => _delegate.keyboardKeyNumpad1;

  @override
  String get keyboardKeyNumpad2 => _delegate.keyboardKeyNumpad2;

  @override
  String get keyboardKeyNumpad3 => _delegate.keyboardKeyNumpad3;

  @override
  String get keyboardKeyNumpad4 => _delegate.keyboardKeyNumpad4;

  @override
  String get keyboardKeyNumpad5 => _delegate.keyboardKeyNumpad5;

  @override
  String get keyboardKeyNumpad6 => _delegate.keyboardKeyNumpad6;

  @override
  String get keyboardKeyNumpad7 => _delegate.keyboardKeyNumpad7;

  @override
  String get keyboardKeyNumpad8 => _delegate.keyboardKeyNumpad8;

  @override
  String get keyboardKeyNumpad9 => _delegate.keyboardKeyNumpad9;

  @override
  String get keyboardKeyNumpadAdd => _delegate.keyboardKeyNumpadAdd;

  @override
  String get keyboardKeyNumpadComma => _delegate.keyboardKeyNumpadComma;

  @override
  String get keyboardKeyNumpadDecimal => _delegate.keyboardKeyNumpadDecimal;

  @override
  String get keyboardKeyNumpadDivide => _delegate.keyboardKeyNumpadDivide;

  @override
  String get keyboardKeyNumpadEnter => _delegate.keyboardKeyNumpadEnter;

  @override
  String get keyboardKeyNumpadEqual => _delegate.keyboardKeyNumpadEqual;

  @override
  String get keyboardKeyNumpadMultiply => _delegate.keyboardKeyNumpadMultiply;

  @override
  String get keyboardKeyNumpadParenLeft => _delegate.keyboardKeyNumpadParenLeft;

  @override
  String get keyboardKeyNumpadParenRight =>
      _delegate.keyboardKeyNumpadParenRight;

  @override
  String get keyboardKeyNumpadSubtract => _delegate.keyboardKeyNumpadSubtract;

  @override
  String get keyboardKeyPageDown => _delegate.keyboardKeyPageDown;

  @override
  String get keyboardKeyPageUp => _delegate.keyboardKeyPageUp;

  @override
  String get keyboardKeyPower => _delegate.keyboardKeyPower;

  @override
  String get keyboardKeyPowerOff => _delegate.keyboardKeyPowerOff;

  @override
  String get keyboardKeyPrintScreen => _delegate.keyboardKeyPrintScreen;

  @override
  String get keyboardKeyScrollLock => _delegate.keyboardKeyScrollLock;

  @override
  String get keyboardKeySelect => _delegate.keyboardKeySelect;

  @override
  String get keyboardKeyShift => _delegate.keyboardKeyShift;

  @override
  String get keyboardKeySpace => _delegate.keyboardKeySpace;

  @override
  String get lastPageTooltip => _delegate.lastPageTooltip;

  @override
  String get licensesPageTitle => _delegate.licensesPageTitle;

  @override
  String get lookUpButtonLabel => _delegate.lookUpButtonLabel;

  @override
  String get menuBarMenuLabel => _delegate.menuBarMenuLabel;

  @override
  String get menuDismissLabel => _delegate.menuDismissLabel;

  @override
  String get modalBarrierDismissLabel => _delegate.modalBarrierDismissLabel;

  @override
  String get moreButtonTooltip => _delegate.moreButtonTooltip;

  @override
  List<String> get narrowWeekdays => _delegate.narrowWeekdays;

  @override
  String get nextMonthTooltip => _delegate.nextMonthTooltip;

  @override
  String get nextPageTooltip => _delegate.nextPageTooltip;

  @override
  String get okButtonLabel => _delegate.okButtonLabel;

  @override
  String get openAppDrawerTooltip => _delegate.openAppDrawerTooltip;

  @override
  String get pasteButtonLabel => _delegate.pasteButtonLabel;

  @override
  String get popupMenuLabel => _delegate.popupMenuLabel;

  @override
  String get postMeridiemAbbreviation => _delegate.postMeridiemAbbreviation;

  @override
  String get previousMonthTooltip => _delegate.previousMonthTooltip;

  @override
  String get previousPageTooltip => _delegate.previousPageTooltip;

  @override
  String get refreshIndicatorSemanticLabel =>
      _delegate.refreshIndicatorSemanticLabel;

  @override
  // ignore: deprecated_member_use
  String get reorderItemDown => _delegate.reorderItemDown;

  @override
  // ignore: deprecated_member_use
  String get reorderItemLeft => _delegate.reorderItemLeft;

  @override
  // ignore: deprecated_member_use
  String get reorderItemRight => _delegate.reorderItemRight;

  @override
  // ignore: deprecated_member_use
  String get reorderItemToEnd => _delegate.reorderItemToEnd;

  @override
  // ignore: deprecated_member_use
  String get reorderItemToStart => _delegate.reorderItemToStart;

  @override
  // ignore: deprecated_member_use
  String get reorderItemUp => _delegate.reorderItemUp;

  @override
  String get rowsPerPageTitle => _delegate.rowsPerPageTitle;

  @override
  String get saveButtonLabel => _delegate.saveButtonLabel;

  @override
  String get scanTextButtonLabel => _delegate.scanTextButtonLabel;

  @override
  String get scrimLabel => _delegate.scrimLabel;

  @override
  ScriptCategory get scriptCategory => _delegate.scriptCategory;

  @override
  String get searchFieldLabel => _delegate.searchFieldLabel;

  @override
  String get searchWebButtonLabel => _delegate.searchWebButtonLabel;

  @override
  String get selectAllButtonLabel => _delegate.selectAllButtonLabel;

  @override
  String get selectYearSemanticsLabel => _delegate.selectYearSemanticsLabel;

  @override
  String get selectedDateLabel => _delegate.selectedDateLabel;

  @override
  String get shareButtonLabel => _delegate.shareButtonLabel;

  @override
  String get showAccountsLabel => _delegate.showAccountsLabel;

  @override
  String get showMenuTooltip => _delegate.showMenuTooltip;

  @override
  String get signedInLabel => _delegate.signedInLabel;

  @override
  String get timePickerDialHelpText => _delegate.timePickerDialHelpText;

  @override
  String get timePickerHourLabel => _delegate.timePickerHourLabel;

  @override
  String get timePickerHourModeAnnouncement =>
      _delegate.timePickerHourModeAnnouncement;

  @override
  String get timePickerInputHelpText => _delegate.timePickerInputHelpText;

  @override
  String get timePickerMinuteLabel => _delegate.timePickerMinuteLabel;

  @override
  String get timePickerMinuteModeAnnouncement =>
      _delegate.timePickerMinuteModeAnnouncement;

  @override
  String get unspecifiedDate => _delegate.unspecifiedDate;

  @override
  String get unspecifiedDateRange => _delegate.unspecifiedDateRange;

  @override
  String get viewLicensesButtonLabel => _delegate.viewLicensesButtonLabel;

  @override
  String aboutListTileTitle(final String applicationName) =>
      _delegate.aboutListTileTitle(applicationName);

  @override
  String dateRangeEndDateSemanticLabel(final String formattedDate) =>
      _delegate.dateRangeEndDateSemanticLabel(formattedDate);

  @override
  String dateRangeStartDateSemanticLabel(final String formattedDate) =>
      _delegate.dateRangeStartDateSemanticLabel(formattedDate);

  @override
  String formatDecimal(final int number) => _delegate.formatDecimal(number);

  @override
  String formatCompactDate(final DateTime date) =>
      _delegate.formatCompactDate(date);

  @override
  String formatFullDate(final DateTime date) => _delegate.formatFullDate(date);

  @override
  String formatHour(
    final TimeOfDay timeOfDay, {
    final bool alwaysUse24HourFormat = false,
  }) => _delegate.formatHour(
    timeOfDay,
    alwaysUse24HourFormat: alwaysUse24HourFormat,
  );

  @override
  String formatMediumDate(final DateTime date) =>
      _delegate.formatMediumDate(date);

  @override
  String formatMinute(final TimeOfDay timeOfDay) =>
      _delegate.formatMinute(timeOfDay);

  @override
  String formatMonthYear(final DateTime date) =>
      _delegate.formatMonthYear(date);

  @override
  String formatShortDate(final DateTime date) =>
      _delegate.formatShortDate(date);

  @override
  String formatShortMonthDay(final DateTime date) =>
      _delegate.formatShortMonthDay(date);

  @override
  String formatTimeOfDay(
    final TimeOfDay timeOfDay, {
    final bool alwaysUse24HourFormat = false,
  }) => _delegate.formatTimeOfDay(
    timeOfDay,
    alwaysUse24HourFormat: alwaysUse24HourFormat,
  );

  @override
  String formatYear(final DateTime date) => _delegate.formatYear(date);

  @override
  String licensesPackageDetailText(final int licenseCount) =>
      _delegate.licensesPackageDetailText(licenseCount);

  @override
  String pageRowsInfoTitle(
    final int firstRow,
    final int lastRow,
    final int rowCount,
    final bool rowCountIsApproximate,
  ) => _delegate.pageRowsInfoTitle(
    firstRow,
    lastRow,
    rowCount,
    rowCountIsApproximate,
  );

  @override
  DateTime? parseCompactDate(final String? inputString) =>
      _delegate.parseCompactDate(inputString);

  @override
  String remainingTextFieldCharacterCount(final int remaining) =>
      _delegate.remainingTextFieldCharacterCount(remaining);

  @override
  String scrimOnTapHint(final String modalRouteContentName) =>
      _delegate.scrimOnTapHint(modalRouteContentName);

  @override
  String selectedRowCountTitle(final int selectedRowCount) =>
      _delegate.selectedRowCountTitle(selectedRowCount);

  @override
  String tabLabel({required final int tabIndex, required final int tabCount}) =>
      _delegate.tabLabel(tabIndex: tabIndex, tabCount: tabCount);

  @override
  TimeOfDayFormat timeOfDayFormat({final bool alwaysUse24HourFormat = false}) =>
      _delegate.timeOfDayFormat(alwaysUse24HourFormat: alwaysUse24HourFormat);
}
