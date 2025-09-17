// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get gameLabel => 'Game';

  @override
  String get tagLabel => 'Tag';

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
  String get statusLabel => 'Status';

  @override
  String get ratingLabel => 'Rating';

  @override
  String get notesLabel => 'Notes';

  @override
  String get hostLabel => 'Host';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginLabel => 'Login';

  @override
  String get detailLabel => 'Detail';

  @override
  String get addLabel => 'Add';

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
  String get reloadLabel => 'Reload';

  @override
  String get searchLabel => 'Search';

  @override
  String get openLabel => 'Open';

  @override
  String get modifiedLabel => 'Modified';

  @override
  String get stayLabel => 'Stay';

  @override
  String get discardChangesLabel => 'Discard changes';

  @override
  String get emptySessionsOnSelectedDayMessage => 'No sessions on selected day';

  @override
  String get showLabel => 'Show';

  @override
  String get hideLabel => 'Hide';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

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
  String get listStyleTileLabel => 'Tile';

  @override
  String get listStyleGridLabel => 'Grid';

  @override
  String get emptyListDetailLabel => 'Select something first';

  @override
  String get notEmptyValidationError => 'Please enter some text';

  @override
  String get deleteDialogTitle => 'Delete?';

  @override
  String get deleteDialogSubtitle => 'This action cannot be undone.';

  @override
  String deleteDialogDataTitle(Object data) {
    return '$data will be deleted.';
  }

  @override
  String get leaveDirtyFormConfirmationDialogTitle =>
      'Are you sure you want to leave?';

  @override
  String get leaveDirtyFormConfirmationDialogSubtitle =>
      'There are unsaved changes.';

  @override
  String gameEditionDataTitle(Object aTitle, Object bEdition) {
    return '$aTitle - $bEdition';
  }
}
