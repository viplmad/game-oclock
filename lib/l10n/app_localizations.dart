import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @errorListPageLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Error loading page.'**
  String get errorListPageLoadTitle;

  /// No description provided for @errorDetailLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Error loading detail.'**
  String get errorDetailLoadTitle;

  /// No description provided for @errorPageLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading error.'**
  String get errorPageLoadTitle;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @emptyListLabel.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyListLabel;

  /// No description provided for @gamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get gamesTitle;

  /// No description provided for @locationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locationsTitle;

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTitle;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @yearInReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Year in Review'**
  String get yearInReviewTitle;

  /// No description provided for @tagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsTitle;

  /// No description provided for @playthroughsTitle.
  ///
  /// In en, this message translates to:
  /// **'Playthroughs'**
  String get playthroughsTitle;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @chooseThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose theme'**
  String get chooseThemeLabel;

  /// No description provided for @darkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkLabel;

  /// No description provided for @lightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightLabel;

  /// No description provided for @systemDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefaultLabel;

  /// No description provided for @systemDefaultLabelData.
  ///
  /// In en, this message translates to:
  /// **'System default ({data})'**
  String systemDefaultLabelData(Object data);

  /// No description provided for @chooseLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguageLabel;

  /// No description provided for @chooseStartingDayOfWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose starting day of week'**
  String get chooseStartingDayOfWeekLabel;

  /// No description provided for @chooseTimeFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose time format'**
  String get chooseTimeFormatLabel;

  /// No description provided for @chooseDateFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose date format'**
  String get chooseDateFormatLabel;

  /// No description provided for @gameLabel.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameLabel;

  /// No description provided for @tagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tagLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @calendarLabel.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarLabel;

  /// No description provided for @creatingTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating'**
  String get creatingTitle;

  /// No description provided for @editingTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get editingTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @fieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get fieldLabel;

  /// No description provided for @operatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get operatorLabel;

  /// No description provided for @valueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueLabel;

  /// No description provided for @selectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectedLabel;

  /// No description provided for @predefinedLabel.
  ///
  /// In en, this message translates to:
  /// **'Built-in'**
  String get predefinedLabel;

  /// No description provided for @addedDatetimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Added Date'**
  String get addedDatetimeLabel;

  /// No description provided for @updatedDatetimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated Date'**
  String get updatedDatetimeLabel;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'Id'**
  String get idLabel;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @editionLabel.
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get editionLabel;

  /// No description provided for @releaseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDateLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @genresLabel.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genresLabel;

  /// No description provided for @seriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get seriesLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @startDateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startDateTimeLabel;

  /// No description provided for @endDateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endDateTimeLabel;

  /// No description provided for @deviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get deviceLabel;

  /// No description provided for @playthroughLabel.
  ///
  /// In en, this message translates to:
  /// **'Playthrough'**
  String get playthroughLabel;

  /// No description provided for @startedLabel.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get startedLabel;

  /// No description provided for @finishedLabel.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finishedLabel;

  /// No description provided for @hostLabel.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get hostLabel;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @roleUserLabel.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUserLabel;

  /// No description provided for @roleAdminLabel.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdminLabel;

  /// No description provided for @confirmationLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmationLabel;

  /// No description provided for @loginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLabel;

  /// No description provided for @detailLabel.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detailLabel;

  /// No description provided for @backLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backLabel;

  /// No description provided for @addFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Add filter'**
  String get addFilterLabel;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceLabel;

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addLabel;

  /// No description provided for @createLabel.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createLabel;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @viewLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewLabel;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @clearLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearLabel;

  /// No description provided for @reloadLabel.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reloadLabel;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// No description provided for @wishlistLabel.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistLabel;

  /// No description provided for @lowPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Low Priority'**
  String get lowPriorityLabel;

  /// No description provided for @nextUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Up'**
  String get nextUpLabel;

  /// No description provided for @playingLabel.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playingLabel;

  /// No description provided for @playedLabel.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get playedLabel;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @retiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get retiredLabel;

  /// No description provided for @openLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLabel;

  /// No description provided for @modifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modifiedLabel;

  /// No description provided for @stayLabel.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stayLabel;

  /// No description provided for @discardChangesLabel.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get discardChangesLabel;

  /// No description provided for @changeYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Change year'**
  String get changeYearLabel;

  /// No description provided for @allLabel.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allLabel;

  /// No description provided for @addSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Add session'**
  String get addSessionLabel;

  /// No description provided for @emptySessionsOnSelectedDayMessage.
  ///
  /// In en, this message translates to:
  /// **'No sessions on selected day'**
  String get emptySessionsOnSelectedDayMessage;

  /// No description provided for @showLabel.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get showLabel;

  /// No description provided for @hideLabel.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hideLabel;

  /// No description provided for @showDatePicker.
  ///
  /// In en, this message translates to:
  /// **'Show Date Picker'**
  String get showDatePicker;

  /// No description provided for @showTimePicker.
  ///
  /// In en, this message translates to:
  /// **'Show Time Picker'**
  String get showTimePicker;

  /// No description provided for @showDurationPicker.
  ///
  /// In en, this message translates to:
  /// **'Show Duration Picker'**
  String get showDurationPicker;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @totalSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Sessions'**
  String get totalSessionsLabel;

  /// No description provided for @totalTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTimeLabel;

  /// No description provided for @totalMediasLabel.
  ///
  /// In en, this message translates to:
  /// **'Total games'**
  String get totalMediasLabel;

  /// No description provided for @totalFirstMediasLabel.
  ///
  /// In en, this message translates to:
  /// **'Total games first played'**
  String get totalFirstMediasLabel;

  /// No description provided for @totalFinishedMediasLabel.
  ///
  /// In en, this message translates to:
  /// **'Total games finished'**
  String get totalFinishedMediasLabel;

  /// No description provided for @totalFirstFinishedMediasLabel.
  ///
  /// In en, this message translates to:
  /// **'Total games first finished'**
  String get totalFirstFinishedMediasLabel;

  /// No description provided for @longestSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Longest session'**
  String get longestSessionLabel;

  /// No description provided for @longestStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreakLabel;

  /// No description provided for @totalMediasByReleaseYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Total games by release year'**
  String get totalMediasByReleaseYearLabel;

  /// No description provided for @equalLabel.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get equalLabel;

  /// No description provided for @notEqualLabel.
  ///
  /// In en, this message translates to:
  /// **'Not equal'**
  String get notEqualLabel;

  /// No description provided for @greaterThanLabel.
  ///
  /// In en, this message translates to:
  /// **'Greater than'**
  String get greaterThanLabel;

  /// No description provided for @greaterThanEqualLabel.
  ///
  /// In en, this message translates to:
  /// **'Greater than or equal'**
  String get greaterThanEqualLabel;

  /// No description provided for @lessThanLabel.
  ///
  /// In en, this message translates to:
  /// **'Less than'**
  String get lessThanLabel;

  /// No description provided for @lessThanEqualLabel.
  ///
  /// In en, this message translates to:
  /// **'Less than or equal'**
  String get lessThanEqualLabel;

  /// No description provided for @startsWithLabel.
  ///
  /// In en, this message translates to:
  /// **'Starts with'**
  String get startsWithLabel;

  /// No description provided for @notStartsWithLabel.
  ///
  /// In en, this message translates to:
  /// **'Does not start with'**
  String get notStartsWithLabel;

  /// No description provided for @endsWithLabel.
  ///
  /// In en, this message translates to:
  /// **'Ends with'**
  String get endsWithLabel;

  /// No description provided for @notEndsWithLabel.
  ///
  /// In en, this message translates to:
  /// **'Does not end with'**
  String get notEndsWithLabel;

  /// No description provided for @containsLabel.
  ///
  /// In en, this message translates to:
  /// **'Contains'**
  String get containsLabel;

  /// No description provided for @notContainsLabel.
  ///
  /// In en, this message translates to:
  /// **'Does not contain'**
  String get notContainsLabel;

  /// No description provided for @nullLabel.
  ///
  /// In en, this message translates to:
  /// **'Null'**
  String get nullLabel;

  /// No description provided for @notNullLabel.
  ///
  /// In en, this message translates to:
  /// **'Not Null'**
  String get notNullLabel;

  /// No description provided for @andLabel.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get andLabel;

  /// No description provided for @orLabel.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orLabel;

  /// No description provided for @thenLabel.
  ///
  /// In en, this message translates to:
  /// **'then'**
  String get thenLabel;

  /// No description provided for @quote.
  ///
  /// In en, this message translates to:
  /// **'\'{data}\''**
  String quote(Object data);

  /// No description provided for @equalChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} = {bValue}'**
  String equalChipLabel(Object aField, Object bValue);

  /// No description provided for @notEqualChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} != {bValue}'**
  String notEqualChipLabel(Object aField, Object bValue);

  /// No description provided for @greaterThanChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} > {bValue}'**
  String greaterThanChipLabel(Object aField, Object bValue);

  /// No description provided for @greaterThanEqualChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} >= {bValue}'**
  String greaterThanEqualChipLabel(Object aField, Object bValue);

  /// No description provided for @lessThanChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} < {bValue}'**
  String lessThanChipLabel(Object aField, Object bValue);

  /// No description provided for @lessThanEqualChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} <= {bValue}'**
  String lessThanEqualChipLabel(Object aField, Object bValue);

  /// No description provided for @inChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} is in [{bValue}]'**
  String inChipLabel(Object aField, Object bValue);

  /// No description provided for @notInChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} is not in [{bValue}]'**
  String notInChipLabel(Object aField, Object bValue);

  /// No description provided for @startsWithChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} starts with {bValue}'**
  String startsWithChipLabel(Object aField, Object bValue);

  /// No description provided for @notStartsWithChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} does not start with {bValue}'**
  String notStartsWithChipLabel(Object aField, Object bValue);

  /// No description provided for @endsWithChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} ends with {bValue}'**
  String endsWithChipLabel(Object aField, Object bValue);

  /// No description provided for @notEndsWithChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} does not start with {bValue}'**
  String notEndsWithChipLabel(Object aField, Object bValue);

  /// No description provided for @containsChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} contains {bValue}'**
  String containsChipLabel(Object aField, Object bValue);

  /// No description provided for @notContainsChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} does not contain {bValue}'**
  String notContainsChipLabel(Object aField, Object bValue);

  /// No description provided for @nullChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} is null'**
  String nullChipLabel(Object aField);

  /// No description provided for @notNullChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{aField} is not null'**
  String notNullChipLabel(Object aField);

  /// No description provided for @listStyleTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Tile'**
  String get listStyleTileLabel;

  /// No description provided for @listStyleGridLabel.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get listStyleGridLabel;

  /// No description provided for @emptyListDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Select something first'**
  String get emptyListDetailLabel;

  /// No description provided for @notEmptyValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get notEmptyValidationError;

  /// No description provided for @notEqualValidationError.
  ///
  /// In en, this message translates to:
  /// **'Confirmation does not match'**
  String get notEqualValidationError;

  /// No description provided for @someIsBlankValidationError.
  ///
  /// In en, this message translates to:
  /// **'Blank entries not allowed'**
  String get someIsBlankValidationError;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteDialogSubtitle;

  /// No description provided for @deleteDialogDataTitle.
  ///
  /// In en, this message translates to:
  /// **'{data} will be deleted.'**
  String deleteDialogDataTitle(Object data);

  /// No description provided for @deletedSuccessfullyLabel.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deletedSuccessfullyLabel;

  /// No description provided for @unableToDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete'**
  String get unableToDeleteLabel;

  /// No description provided for @createdSuccessfullyLabel.
  ///
  /// In en, this message translates to:
  /// **'Created successfully'**
  String get createdSuccessfullyLabel;

  /// No description provided for @unableToCreateLabel.
  ///
  /// In en, this message translates to:
  /// **'Unable to create'**
  String get unableToCreateLabel;

  /// No description provided for @updatedSuccessfullyLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updatedSuccessfullyLabel;

  /// No description provided for @unableToUpdateLabel.
  ///
  /// In en, this message translates to:
  /// **'Unable to update'**
  String get unableToUpdateLabel;

  /// No description provided for @loginSuccessfulLabel.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessfulLabel;

  /// No description provided for @unableToLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Unable to login'**
  String get unableToLoginLabel;

  /// No description provided for @unableToLoadListLabel.
  ///
  /// In en, this message translates to:
  /// **'Unable to load list'**
  String get unableToLoadListLabel;

  /// No description provided for @unableToLoadDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Unable to load detail'**
  String get unableToLoadDetailLabel;

  /// No description provided for @leaveDirtyFormConfirmationDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave?'**
  String get leaveDirtyFormConfirmationDialogTitle;

  /// No description provided for @leaveDirtyFormConfirmationDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'There are unsaved changes.'**
  String get leaveDirtyFormConfirmationDialogSubtitle;

  /// No description provided for @errorCopiedText.
  ///
  /// In en, this message translates to:
  /// **'Error copied'**
  String get errorCopiedText;

  /// No description provided for @gameEditionDataTitle.
  ///
  /// In en, this message translates to:
  /// **'{aTitle} - {bEdition}'**
  String gameEditionDataTitle(Object aTitle, Object bEdition);

  /// No description provided for @errorCodeNameDataTitle.
  ///
  /// In en, this message translates to:
  /// **'{aCode}: {aName}'**
  String errorCodeNameDataTitle(Object aCode, Object aName);

  /// No description provided for @createNewDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Create new: \"{data}\"'**
  String createNewDataLabel(Object data);

  /// No description provided for @linkLabel.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkLabel;

  /// No description provided for @totalDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Total: {data}'**
  String totalDataLabel(Object data);

  /// No description provided for @hoursAbbr.
  ///
  /// In en, this message translates to:
  /// **'{hours} {hours, plural, =1{hr.} other{hrs.}}'**
  String hoursAbbr(num hours);

  /// No description provided for @minutesAbbr.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min.'**
  String minutesAbbr(Object minutes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
