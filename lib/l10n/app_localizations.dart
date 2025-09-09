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

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTitle;

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

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addLabel;

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

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

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

  /// No description provided for @gameEditionDataTitle.
  ///
  /// In en, this message translates to:
  /// **'{aTitle} - {bEdition}'**
  String gameEditionDataTitle(Object aTitle, Object bEdition);
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
