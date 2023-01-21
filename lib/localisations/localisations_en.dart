import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart' show GameStatus, PlatformType;

import 'package:backend/model/calendar_range.dart';
import 'package:backend/utils/duration_extension.dart';

import 'localisations.dart';

class GameCollectionLocalisationsEn implements GameCollectionLocalisations {
  const GameCollectionLocalisationsEn();

  @override
  final String connectingString = 'Connecting...';
  @override
  final String connectString = 'Connect';
  @override
  final String failedConnectionString = 'Failed connection';
  @override
  final String retryString = 'Retry';
  @override
  final String changeRepositoryString = 'Change connection settings';

  @override
  final String changeStartGameViewString = 'Change start Game View';
  @override
  final String startGameViewString = 'Start Game View';

  @override
  final String aboutString = 'About';
  @override
  final String licenseInfoString = 'Released under the MIT License';

  @override
  final String repositorySettingsString = 'Connection settings';
  @override
  final String updatedItemConnectionString = 'Item connection updated';
  @override
  final String updatedImageConnectionString = 'Image connection updated';
  @override
  final String unableToUpdateConnectionString = 'Unable to update connection';
  @override
  final String unableToLoadConnectionString = 'Unable to load connection';
  @override
  final String deletedItemConnectionString = 'Item connection deleted';
  @override
  final String deletedImageConnectionString = 'Image connection deleted';
  @override
  final String unableToDeleteConnectionString = 'Unable to delete connection';
  @override
  final String saveString = 'Save';
  @override
  final String itemConnectionString = 'Item connection';
  @override
  final String imageConnectionString = 'Image connection';

  @override
  final String nameString = 'Name';
  @override
  final String hostString = 'Host';
  @override
  final String usernameString = 'User';
  @override
  final String passwordString = 'Password';
  @override
  final String currentAccessTokenString = 'Current Access Token';
  @override
  final String accessTokenCopied = 'Access Token copied';

  @override
  final String searchAllString = 'Global Search';
  @override
  final String changeStyleString = 'Change Style';
  @override
  final String changeViewString = 'Change View';
  @override
  final String changeRangeString = 'Change Range';
  @override
  final String calendarView = 'Calendar View';

  @override
  final String gameListsString = 'Game Lists';

  @override
  String newString(String typeString) {
    return 'New $typeString';
  }

  @override
  final String openString = 'Open';
  @override
  String addedString(String typeString) {
    return '$typeString added';
  }

  @override
  String unableToAddString(String typeString) {
    return 'Unable to add $typeString';
  }

  @override
  String deletedString(String typeString) {
    return '$typeString deleted';
  }

  @override
  String unableToDeleteString(String typeString) {
    return 'Unable to delete $typeString';
  }

  @override
  final String deleteString = 'Delete';
  @override
  final String deleteButtonLabel = 'DELETE';
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
  final String filenameString = 'Filename';
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
  final List<String> daysOfWeek = const <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
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
  @override
  final List<String> months = const <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
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
  String gameStatusString(GameStatus? status) {
    switch (status) {
      case GameStatus.lowPriority:
        return lowPriorityString;
      case GameStatus.nextUp:
        return nextUpString;
      case GameStatus.playing:
        return playingString;
      case GameStatus.played:
        return playedString;
      default:
        return '';
    }
  }

  @override
  final String editionFieldString = 'Edition';
  @override
  final String statusFieldString = 'Status';
  @override
  final String ratingFieldString = 'Rating';
  @override
  final String thoughtsFieldString = 'Thoughts';
  @override
  final String gameLogFieldString = 'Time Log';
  @override
  final String gameLogsFieldString = 'Play Time';
  @override
  final String saveFolderFieldString = 'Save Folder';
  @override
  final String screenshotFolderFieldString = 'Screenshot Folder';
  @override
  final String backupFieldString = 'Backup';

  @override
  String get singleCalendarViewString =>
      '$gameLogsFieldString & $finishDatesFieldString';
  @override
  String get multiCalendarViewString => gameLogsFieldString;
  @override
  final String editTimeString = 'Time';
  @override
  final String selectedDateIsFinishDateString = 'Finished this day';
  @override
  final String gameCalendarEventsString = 'Calendar Event';
  @override
  String get firstGameLog => 'First $gameLogsFieldString';
  @override
  String get lastGameLog => 'Last $gameLogsFieldString';
  @override
  String get previousGameLog => 'Previous $gameLogsFieldString';
  @override
  String get nextGameLog => 'Next $gameLogsFieldString';
  @override
  String get emptyGameLogsString => 'No $gameLogsFieldString';
  @override
  String rangeString(CalendarRange range) {
    switch (range) {
      case CalendarRange.day:
        return 'Day';
      case CalendarRange.week:
        return 'Week';
      case CalendarRange.month:
        return 'Month';
      case CalendarRange.year:
        return 'Year';
    }
  }

  @override
  String totalGames(int total) {
    return '$total ${total > 1 ? gamesString : gameString}';
  }

  @override
  final String dateString = 'Date';
  @override
  final String startTimeString = 'Start Time';
  @override
  final String endTimeString = 'End Time';
  @override
  final String durationString = 'Duration';
  @override
  final String recalculationModeTitle = 'Recalculation Mode';
  @override
  final String recalculationModeSubtitle =
      'Affects the value to be recalculated if other values change';
  @override
  final String recalculationModeDurationString = 'Recalculate duration';
  @override
  final String recalculationModeTimeString = 'Recalculate time';

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
    return 'Finished in ${formatYear(year)}';
  }

  @override
  String get totalGamesString => 'Total $gamesString';
  @override
  String get totalGamesPlayedString => 'Total played $gamesString';
  @override
  String get totalTimeString => 'Total $gameLogsFieldString';
  @override
  String get avgTimeString => 'Average $gameLogsFieldString';
  @override
  String get avgRatingString => 'Average $ratingFieldString';
  @override
  String get countByStatusString =>
      'Number of $gamesString by $statusFieldString';
  @override
  String get countByReleaseYearString =>
      'Number of $gamesString by $releaseYearFieldString';
  @override
  String get sumTimeByFinishDateString =>
      'Total $gameLogsFieldString by $finishDateFieldString';
  @override
  String get sumTimeByMonth => 'Total $gameLogsFieldString by month';
  @override
  String get countByRatingString =>
      'Number of $gamesString by $ratingFieldString';
  @override
  String get countByFinishDate =>
      'Number of $gamesString by $finishDateFieldString';
  @override
  String get countByTimeString =>
      'Number of $gamesString by $gameLogsFieldString';
  @override
  String get avgRatingByFinishDateString =>
      'Average $ratingFieldString by $finishDateFieldString';
  //#endregion Game

  //#region DLC
  @override
  final String dlcString = 'DLC';
  @override
  String get dlcsString => _plural(dlcString);

  @override
  final String baseGameFieldString = 'Base Game';
  //#endregion DLC

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
  String platformTypeString(PlatformType? type) {
    switch (type) {
      case PlatformType.physical:
        return physicalString;
      case PlatformType.digital:
        return digitalString;
      default:
        return '';
    }
  }

  @override
  final String platformTypeFieldString = 'Type';
  //#endregion Platform

  //#region Tag
  @override
  final String tagString = 'Tag';
  @override
  String get tagsString => _plural(tagString);
  //#endregion Tag

  @override
  String formatEuro(double amount) {
    final String amountString = amount.toStringAsFixed(2);
    return '$amountString €';
  }

  @override
  String formatPercentage(double amount) {
    final String amountString = amount.toStringAsFixed(2);
    return '$amountString %';
  }

  @override
  String formatTimeOfDay(TimeOfDay time) {
    return _timeString(time.hour, time.minute);
  }

  @override
  String formatTime(DateTime date) {
    return _timeString(date.hour, date.minute);
  }

  String _timeString(int hour, int minute) {
    final String hourString = LocalisationsUtils.padTwoLeadingZeros(hour);
    final String minuteString = LocalisationsUtils.padTwoLeadingZeros(minute);
    return '$hourString:$minuteString';
  }

  @override
  String formatDate(DateTime date) {
    final String dayString = date.day.toString();
    final String monthString = date.month.toString();
    final String yearString = date.year.toString();
    return '$dayString/$monthString/$yearString';
  }

  @override
  String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${formatTime(date)}';
  }

  @override
  String formatDuration(Duration duration) {
    if (duration.isZero()) {
      return '0';
    }

    final int hours = duration.inHours;
    final int minutes = duration.extractNormalisedMinutes();

    final String hourString = formatHours(hours);
    final String minuteString = formatMinutes(minutes);

    if (hours == 0) {
      return minuteString;
    } else if (minutes == 0) {
      return hourString;
    }

    return '$hourString $minuteString';
  }

  @override
  String formatMonthYear(DateTime date) {
    final String month = months.elementAt(date.month - 1);
    final String year = formatYear(date.year);
    return '$month $year';
  }

  @override
  String formatYear(int year) {
    return year.toString();
  }

  @override
  String formatShortYear(int year) {
    return '\'${year.toString().substring(2)}';
  }

  @override
  String formatHours(int hours) {
    return '$hours h';
  }

  @override
  String formatMinutes(int minutes) {
    return '$minutes min.';
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
  final String unableToUndoString = 'Unable to undo action';
  @override
  final String moreString = 'More';
  @override
  final String searchInListString = 'Search in list';
  @override
  String linkedString(String typeString) {
    return '$typeString linked';
  }

  @override
  String unableToLinkString(String typeString) {
    return 'Unable to link $typeString';
  }

  @override
  String unlinkedString(String typeString) {
    return '$typeString unlinked';
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
  String unableToLoadString(String typeString) {
    return 'Unable to load $typeString';
  }

  @override
  final String unableToLoadDetailString = 'Unable to load details';
  @override
  final String unableToLoadCalendar = 'Unable to load calendar';

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

  String _plural(String string) => '${string}s';
}
