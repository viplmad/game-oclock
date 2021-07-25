import 'localisations.dart';


class GameCollectionLocalisationsEn implements GameCollectionLocalisations {
  const GameCollectionLocalisationsEn();

  @override
  final String connectingString = 'Connecting...';
  @override
  final String failedConnectionString = 'Failed connection';
  @override
  final String retryString = 'Retry';
  @override
  final String changeRepositoryString = 'Change Repository Settings';

  @override
  final String repositorySettingsString = 'Repository settings';
  @override
  final String unableToUpdateConnectionString = 'Unable to update connection';
  @override
  final String saveString = 'Save';
  @override
  final String itemConnectionString = 'Item connection';
  @override
  final String imageConnectionString = 'Image connection';
  @override
  final String hostString = 'Host';
  @override
  final String portString = 'Port';
  @override
  final String databaseString = 'Database';
  @override
  final String userString = 'User';
  @override
  final String passwordString = 'Password';
  @override
  final String cloudNameString = 'Cloud name';
  @override
  final String apiKeyString = 'API Key';
  @override
  final String apiSecretString = 'API Secret';

  @override
  final String changeOrderString = 'Change Order';
  @override
  final String changeStyleString = 'Change Style';
  @override
  final String changeViewString = 'Change View';
  @override
  final String calendarView = 'Calendar View';
  @override
  final String searchInViewString = 'Search in View';
  @override
  final String statsInViewString = 'Stats in View';

  @override
  String newString(String typeString) {
    return 'New $typeString';
  }
  @override
  final String openString = 'Open';
  @override
  String addedString(String typeString) {
    return 'Added $typeString';
  }
  @override
  String unableToAddString(String typeString) {
    return 'Unable to add $typeString';
  }
  @override
  String deletedString(String typeString) {
    return 'Deleted $typeString';
  }
  @override
  String unableToDeleteString(String typeString) {
    return 'Unable to delete $typeString';
  }

  @override
  final String duplicateString = 'Duplicate';
  @override
  final String deleteString = 'Delete';
  @override
  String deleteDialogTitle(String itemString) {
    return 'Are you sure you want to delete $itemString?';
  }
  @override
  final String deleteDialogSubtitle = 'This action cannot be undone';

  //#region Common
  @override
  final String emptyValueString = '';
  @override
  final String showString = 'Show';
  @override
  final String hideString = 'Hide';
  @override
  final String enterTextString = 'Please enter some text';

  @override
  final String nameFieldString = 'Name';
  @override
  final String releaseYearFieldString = 'Release Year';
  @override
  final String finishDateFieldString = 'Finish Date';
  @override
  final String finishDatesFieldString = 'Finish Dates';
  @override
  String get emptyFinishDatesString => 'No $finishDatesFieldString yet';

  @override
  final String mainViewString = 'Main';
  @override
  final String lastCreatedViewString = 'Last Created';
  @override
  final String yearInReviewViewString = 'Year in Review';

  @override
  final String generalString = 'General';
  @override
  final String changeYearString = 'Change year';
  @override
  final List<String> shortMonths = const <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  @override
  final List<String> shortDaysOfWeek = const <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  //#endregion Common

  //#region Game
  @override
  final String gameString = 'Game';
  @override
  String get gamesString => _plural(gameString);
  @override
  final String allString = 'All';
  @override
  final String ownedString = 'Owned';
  @override
  final String romsString = 'Roms';

  @override
  final String lowPriorityString = 'Low Priority';
  @override
  final String nextUpString = 'Next Up';
  @override
  final String playingString = 'Playing';
  @override
  final String playedString = 'Played';
  @override
  final String editionFieldString = 'Edition';
  @override
  final String statusFieldString = 'Status';
  @override
  final String ratingFieldString = 'Rating';
  @override
  final String thoughtsFieldString = 'Thoughts';
  @override
  final String timeLogFieldString = 'Time Log';
  @override
  final String timeLogsFieldString = 'Play Time';
  @override
  final String saveFolderFieldString = 'Save Folder';
  @override
  final String screenshotFolderFieldString = 'Screenshot Folder';
  @override
  final String backupFieldString = 'Backup';
  @override
  String get singleCalendarViewString => '$timeLogsFieldString & $finishDatesFieldString';
  @override
  String get multiCalendarViewString => '$timeLogsFieldString';
  @override
  final String editTimeString = 'Time';
  @override
  final String selectedDateIsFinishDateString = 'Finished this day';
  @override
  final String gameCalendarEventsString = 'Game Event';
  @override
  String get firstTimeLog => 'First $timeLogsFieldString';
  @override
  String get lastTimeLog => 'Last $timeLogsFieldString';
  @override
  String get previousTimeLog => 'Previous $timeLogsFieldString';
  @override
  String get nextTimeLog => 'Next $timeLogsFieldString';
  @override
  String get emptyTimeLogsString => 'No $timeLogsFieldString';
  @override
  final String weekString = 'Week';

  @override
  final String playingViewString = 'Playing';
  @override
  final String nextUpViewString = 'Next Up';
  @override
  final String lastPlayedString = 'Last Played';
  @override
  final String lastFinishedViewString = 'Last Finished';

  @override
  String gamesFromYearString(int year) {
    return 'Finished in ' + yearString(year);
  }
  @override
  String get totalGamesString => 'Total $gamesString';
  @override
  String get totalGamesPlayedString => 'Total played $gamesString';
  @override
  String get sumTimeString => 'Total $timeLogsFieldString';
  @override
  String get avgTimeString => 'Average $timeLogsFieldString';
  @override
  String get avgRatingString => 'Average $ratingFieldString';
  @override
  String get countByStatusString => 'Number of $gamesString by $statusFieldString';
  @override
  String get countByReleaseYearString => 'Number of $gamesString by $releaseYearFieldString';
  @override
  String get sumTimeByFinishDateString => 'Total $timeLogsFieldString by $finishDateFieldString';
  @override
  String get sumTimeByMonth => 'Total $timeLogsFieldString by month';
  @override
  String get countByRatingString => 'Number of $gamesString by $ratingFieldString';
  @override
  String get countByFinishDate => 'Number of $gamesString by $finishDateFieldString';
  @override
  String get countByTimeString => 'Number of $gamesString by $timeLogsFieldString';
  @override
  String get avgRatingByFinishDateString => 'Average $ratingFieldString by $finishDateFieldString';
  //#endregion Game

  //#region DLC
  @override
  final String dlcString = 'DLC';
  @override
  String get dlcsString => _plural(dlcString);

  @override
  final String baseGameFieldString = 'Base Game';
  //#endregion DLC

  //#region Purchase
  @override
  final String purchaseString = 'Purchase';
  @override
  String get purchasesString => _plural(purchaseString);

  @override
  final String descriptionFieldString = 'Description';
  @override
  final String priceFieldString = 'Price';
  @override
  final String externalCreditsFieldString = 'External Credit';
  @override
  final String purchaseDateFieldString = 'Date';
  @override
  final String originalPriceFieldString = 'Original Price';
  @override
  final String discountFieldString = 'Discount';

  @override
  final String pendingViewString = 'Pending';
  @override
  final String lastPurchasedViewString = 'Last Purchased';

  @override
  final String totalMoneySpentString = 'Total Money Spent';
  @override
  final String totalMoneySavedString = 'Total Money Saved';
  @override
  final String realValueString = 'Real Value';
  @override
  final String percentageSavedString = 'Percentage Saved';

  @override
  String purchasesFromYearString(int year) {
    return 'From ' + yearString(year);
  }
  @override
  String get totalPurchasesString => 'Total $purchasesString';
  @override
  String get totalPurchasesWithoutPromotionString => '$totalPurchasesString (without Promotions)';
  @override
  final String sumPriceString = 'Total spent';
  @override
  final String avgPriceString = 'Average spent';
  @override
  String get avgPriceWithoutPromotionString => '$avgPriceString (without Promotions)';
  @override
  String get sumExternalCreditString => 'Total $externalCreditsFieldString spent';
  @override
  String get avgExternalCreditString => 'Average $externalCreditsFieldString spent';
  @override
  String get sumOriginalPriceString => 'Total $originalPriceFieldString';
  @override
  String get avgOriginalPriceString => 'Average $originalPriceFieldString';
  @override
  String get avgDiscountString => 'Average $discountFieldString';
  @override
  String get avgDiscountWithoutPromotionString => '$avgDiscountString (without Promotions)';
  @override
  final String sumSavedString = 'Total saved';
  @override
  final String avgSavedString = 'Average saved';
  @override
  String get countByYearString => 'Number of $purchasesString by year';
  @override
  final String sumPriceByYearString = 'Total spent by year';
  @override
  String get sumOriginalPriceByYearString => 'Total $originalPriceFieldString by year';
  @override
  String get countByMonthString => 'Number of $purchasesString by month';
  @override
  String get countByPriceString => 'Number of $purchasesString by $priceFieldString';
  @override
  final String sumPriceByMonthString = 'Total spent by month';
  @override
  String get sumOriginalPriceByMonthString => 'Total $originalPriceFieldString by month';
  @override
  String get sumSavedByMonthString => 'Total saved by month';
  //#endregion Purchase

  //#region Store
  @override
  final String storeString = 'Store';
  @override
  String get storesString => _plural(storeString);
  //#endregion Store

  //#region Platform
  @override
  final String platformString = 'Platform';
  @override
  String get platformsString => _plural(platformString);

  @override
  final String physicalString = 'Physical';
  @override
  final String digitalString = 'Digital';
  @override
  final String platformTypeFieldString = 'Type';
  //#endregion Platform

  //#region System
  @override
  final String systemString = 'System';
  @override
  String get systemsString => _plural(systemString);
  //#endregion System

  //#region Tag
  @override
  final String tagString = 'Tag';
  @override
  String get tagsString => _plural(tagString);
  //#endregion Tag

  //#region PurchaseType
  @override
  final String purchaseTypeString = 'Type';
  @override
  String get purchaseTypesString => _plural(purchaseTypeString);
  //#endregion PurchaseType

  @override
  String euroString(double amount) {
    final String amountString = amount.toStringAsFixed(2);
    return '$amountString €';
  }
  @override
  String percentageString(double amount) {
    final String amountString = amount.toStringAsFixed(2);
    return '$amountString %';
  }
  @override
  String timeString(DateTime date) {
    final String hourString = date.hour.toString().padLeft(2, '0');
    final String minuteString = date.minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
  @override
  String dateString(DateTime date) {
    final String dayString = date.day.toString();
    final String monthString = date.month.toString();
    final String yearString = date.year.toString();
    return '$dayString/$monthString/$yearString';
  }
  @override
  String dateTimeString(DateTime date) {
    return dateString(date) + ' ' + timeString(date);
  }
  @override
  String durationString(Duration duration) {
    final String hoursString = duration.inHours.toString();
    final String minutesString = (duration.inMinutes - (duration.inHours * 60)).toString().padLeft(2, '0');
    return '$hoursString h $minutesString min';
  }
  @override
  String yearString(int year) {
    return year.toString();
  }
  @override
  String shortYearString(int year) {
    return '\'' + year.toString().substring(2);
  }
  @override
  String hoursString(int hours) {
    return '$hours h';
  }

  @override
  String editString(String fieldString) {
    return 'Edit $fieldString';
  }
  @override
  String addString(String fieldString) {
    return 'Add $fieldString';
  }
  @override
  final String fieldUpdatedString = 'Field updated';
  @override
  final String unableToUpdateFieldString = 'Unable to update field';
  @override
  final String uploadImageString = 'Upload image';
  @override
  final String replaceImageString = 'Replace image';
  @override
  final String renameImageString = 'Rename image';
  @override
  final String deleteImageString = 'Delete image';
  @override
  final String imageUpdatedString = 'Image updated';
  @override
  final String unableToUpdateImageString = 'Unable to update image';
  @override
  String unableToLaunchString(String urlString) {
    return 'Could not launch $urlString';
  }

  @override
  String linkString(String typeString) {
    return 'Link $typeString';
  }
  @override
  final String undoString = 'Undo';
  @override
  final String moreString = 'More';
  @override
  final String searchInListString = 'Search in List';
  @override
  String linkedString(String typeString) {
    return 'Linked $typeString';
  }
  @override
  String unableToLinkString(String typeString) {
    return 'Unable to link $typeString';
  }
  @override
  String unlinkedString(String typeString) {
    return 'Unlinked $typeString';
  }
  @override
  String unableToUnlinkString(String typeString) {
    return 'Unable to unlink $typeString';
  }

  @override
  String searchString(String typeString) {
    return 'Search $typeString';
  }
  @override
  final String clearSearchString = 'Clear';
  @override
  String newWithTitleString(String typeString, String titleString) {
    return '+ New $typeString titled \'$titleString\'';
  }
  @override
  final String noSuggestionsString = '';
  @override
  final String noResultsString = 'No results found';

  String _plural(String string) => string + 's';

}