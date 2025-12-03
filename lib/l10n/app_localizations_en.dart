// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get englishLabel => 'English';

  @override
  String get errorListPageLoadTitle => 'Error loading page.';

  @override
  String get errorDetailLoadTitle => 'Error loading detail.';

  @override
  String get errorPageLoadTitle => 'Loading error.';

  @override
  String get retryLabel => 'Retry';

  @override
  String get emptyListLabel => 'Empty';

  @override
  String get gamesTitle => 'Games';

  @override
  String get locationsTitle => 'Locations';

  @override
  String get devicesTitle => 'Devices';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get yearInReviewTitle => 'Year in Review';

  @override
  String get tagsTitle => 'Tags';

  @override
  String get usersTitle => 'Users';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get chooseThemeLabel => 'Choose theme';

  @override
  String get darkLabel => 'Dark';

  @override
  String get lightLabel => 'Light';

  @override
  String get systemDefaultLabel => 'System default';

  @override
  String systemDefaultLabelData(Object data) {
    return 'System default ($data)';
  }

  @override
  String get chooseLanguageLabel => 'Choose language';

  @override
  String get chooseStartingDayOfWeekLabel => 'Choose starting day of week';

  @override
  String get chooseTimeFormatLabel => 'Choose time format';

  @override
  String get chooseDateFormatLabel => 'Choose date format';

  @override
  String get gameLabel => 'Game';

  @override
  String get tagLabel => 'Tag';

  @override
  String get locationLabel => 'Location';

  @override
  String get calendarLabel => 'Calendar';

  @override
  String get creatingTitle => 'Creating';

  @override
  String get editingTitle => 'Editing';

  @override
  String get nameLabel => 'Name';

  @override
  String get fieldLabel => 'Field';

  @override
  String get operatorLabel => 'Operator';

  @override
  String get valueLabel => 'Value';

  @override
  String get idLabel => 'Id';

  @override
  String get titleLabel => 'Title';

  @override
  String get editionLabel => 'Edition';

  @override
  String get releaseDateLabel => 'Release Date';

  @override
  String get statusLabel => 'Status';

  @override
  String get ratingLabel => 'Rating';

  @override
  String get notesLabel => 'Notes';

  @override
  String get genresLabel => 'Genres';

  @override
  String get seriesLabel => 'Series';

  @override
  String get dateLabel => 'Date';

  @override
  String get startDateTimeLabel => 'Start';

  @override
  String get endDateTimeLabel => 'End';

  @override
  String get deviceLabel => 'Device';

  @override
  String get playthroughLabel => 'Playthrough';

  @override
  String get startedLabel => 'Started';

  @override
  String get finishedLabel => 'Finished';

  @override
  String get hostLabel => 'Host';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get currentPasswordLabel => 'Current Password';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get adminLabel => 'Administrator';

  @override
  String get confirmationLabel => 'Confirmation';

  @override
  String get loginLabel => 'Login';

  @override
  String get detailLabel => 'Detail';

  @override
  String get backLabel => 'Back';

  @override
  String get addFilterLabel => 'Add filter';

  @override
  String get createLabel => 'Create';

  @override
  String get editLabel => 'Edit';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get viewLabel => 'View';

  @override
  String get saveLabel => 'Save';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get clearLabel => 'Clear';

  @override
  String get reloadLabel => 'Reload';

  @override
  String get searchLabel => 'Search';

  @override
  String get wishlistLabel => 'Wishlist';

  @override
  String get lowPriorityLabel => 'Low Priority';

  @override
  String get nextUpLabel => 'Next Up';

  @override
  String get playingLabel => 'Playing';

  @override
  String get playedLabel => 'Played';

  @override
  String get completedLabel => 'Completed';

  @override
  String get retiredLabel => 'Retired';

  @override
  String get openLabel => 'Open';

  @override
  String get modifiedLabel => 'Modified';

  @override
  String get stayLabel => 'Stay';

  @override
  String get discardChangesLabel => 'Discard changes';

  @override
  String get allLabel => 'All';

  @override
  String get emptySessionsOnSelectedDayMessage => 'No sessions on selected day';

  @override
  String get showLabel => 'Show';

  @override
  String get hideLabel => 'Hide';

  @override
  String get showDatePicker => 'Show Date Picker';

  @override
  String get showTimePicker => 'Show Time Picker';

  @override
  String get showDurationPicker => 'Show Duration Picker';

  @override
  String get timeLabel => 'Time';

  @override
  String get equalLabel => 'Equal';

  @override
  String get notEqualLabel => 'Not equal';

  @override
  String get greaterThanLabel => 'Greater than';

  @override
  String get greaterThanEqualLabel => 'Greater than or equal';

  @override
  String get lessThanLabel => 'Less than';

  @override
  String get lessThanEqualLabel => 'Less than or equal';

  @override
  String get startsWithLabel => 'Starts with';

  @override
  String get notStartsWithLabel => 'Does not start with';

  @override
  String get endsWithLabel => 'Ends with';

  @override
  String get notEndsWithLabel => 'Does not end with';

  @override
  String get containsLabel => 'Contains';

  @override
  String get notContainsLabel => 'Does not contain';

  @override
  String get andLabel => 'and';

  @override
  String get orLabel => 'or';

  @override
  String get thenLabel => 'then';

  @override
  String get nullLabel => 'null';

  @override
  String quote(Object data) {
    return '\'$data\'';
  }

  @override
  String equalChipLabel(Object aField, Object bValue) {
    return '$aField = $bValue';
  }

  @override
  String notEqualChipLabel(Object aField, Object bValue) {
    return '$aField != $bValue';
  }

  @override
  String greaterThanChipLabel(Object aField, Object bValue) {
    return '$aField > $bValue';
  }

  @override
  String greaterThanEqualChipLabel(Object aField, Object bValue) {
    return '$aField >= $bValue';
  }

  @override
  String lessThanChipLabel(Object aField, Object bValue) {
    return '$aField < $bValue';
  }

  @override
  String lessThanEqualChipLabel(Object aField, Object bValue) {
    return '$aField <= $bValue';
  }

  @override
  String inChipLabel(Object aField, Object bValue) {
    return '$aField is in [$bValue]';
  }

  @override
  String notInChipLabel(Object aField, Object bValue) {
    return '$aField is not in [$bValue]';
  }

  @override
  String startsWithChipLabel(Object aField, Object bValue) {
    return '$aField starts with $bValue';
  }

  @override
  String notStartsWithChipLabel(Object aField, Object bValue) {
    return '$aField does not start with $bValue';
  }

  @override
  String endsWithChipLabel(Object aField, Object bValue) {
    return '$aField ends with $bValue';
  }

  @override
  String notEndsWithChipLabel(Object aField, Object bValue) {
    return '$aField does not start with $bValue';
  }

  @override
  String containsChipLabel(Object aField, Object bValue) {
    return '$aField contains $bValue';
  }

  @override
  String notContainsChipLabel(Object aField, Object bValue) {
    return '$aField does not contain $bValue';
  }

  @override
  String get listStyleTileLabel => 'Tile';

  @override
  String get listStyleGridLabel => 'Grid';

  @override
  String get emptyListDetailLabel => 'Select something first';

  @override
  String get notEmptyValidationError => 'Please enter some text';

  @override
  String get notEqualValidationError => 'Confirmation does not match';

  @override
  String get someIsBlankValidationError => 'Blank entries not allowed';

  @override
  String get deleteDialogTitle => 'Delete?';

  @override
  String get deleteDialogSubtitle => 'This action cannot be undone.';

  @override
  String deleteDialogDataTitle(Object data) {
    return '$data will be deleted.';
  }

  @override
  String get deletedSuccessfullyLabel => 'Deleted successfully';

  @override
  String get unableToDeleteLabel => 'Unable to delete';

  @override
  String get createdSuccessfullyLabel => 'Created successfully';

  @override
  String get unableToCreateLabel => 'Unable to create';

  @override
  String get updatedSuccessfullyLabel => 'Updated successfully';

  @override
  String get unableToUpdateLabel => 'Unable to update';

  @override
  String get loginSuccessfulLabel => 'Login successful';

  @override
  String get unableToLoginLabel => 'Unable to login';

  @override
  String get unableToLoadListLabel => 'Unable to load list';

  @override
  String get unableToLoadDetailLabel => 'Unable to load detail';

  @override
  String get leaveDirtyFormConfirmationDialogTitle =>
      'Are you sure you want to leave?';

  @override
  String get leaveDirtyFormConfirmationDialogSubtitle =>
      'There are unsaved changes.';

  @override
  String get errorCopiedText => 'Error copied';

  @override
  String gameEditionDataTitle(Object aTitle, Object bEdition) {
    return '$aTitle - $bEdition';
  }

  @override
  String errorCodeNameDataTitle(Object aCode, Object aName) {
    return '$aCode: $aName';
  }

  @override
  String createNewDataLabel(Object data) {
    return 'Create new: \"$data\"';
  }

  @override
  String get linkLabel => 'Link';

  @override
  String totalDataLabel(Object data) {
    return 'Total: $data';
  }

  @override
  String hoursAbbr(num hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'hrs.',
      one: 'hr.',
    );
    return '$hours $_temp0';
  }

  @override
  String minutesAbbr(Object minutes) {
    return '$minutes min.';
  }
}
