import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:game_collection_client/api.dart' show GameStatus, PlatformType;

import 'package:logic/model/model.dart' show CalendarRange;

import 'localisations_en.dart';
import 'localisations_es.dart';

abstract class GameCollectionLocalisations {
  const GameCollectionLocalisations._();

  static const String appTitle = 'Game Collection';

  String get connectingString;
  String get connectString;
  String get failedConnectionString;
  String get retryString;
  String get changeRepositoryString;

  String get changeStartGameViewString;
  String get startGameViewString;

  String get aboutString;
  String get licenseInfoString;

  String get repositorySettingsString;
  String get updatedItemConnectionString;
  String get updatedImageConnectionString;
  String get unableToUpdateConnectionString;
  String get unableToLoadConnectionString;
  String get deletedItemConnectionString;
  String get deletedImageConnectionString;
  String get unableToDeleteConnectionString;
  String get saveString;
  String get itemConnectionString;
  String get imageConnectionString;

  String get nameString;
  String get hostString;
  String get usernameString;
  String get passwordString;
  String get currentAccessTokenString;
  String get accessTokenCopied;

  String get searchAllString;
  String get changeStyleString;
  String get changeViewString;
  String get changeRangeString;
  String get calendarView;

  String get gameListsString;

  String newString(String typeString);
  String get openString;
  String addedString(String typeString);
  String unableToAddString(String typeString);
  String deletedString(String typeString);
  String unableToDeleteString(String typeString);

  String get deleteString;
  String get deleteButtonLabel;
  String deleteDialogTitle(String itemString);
  String get deleteDialogSubtitle;

  //#region Common
  String get emptyValueString;
  String get showString;
  String get hideString;
  String get enterTextString;

  String get nameFieldString;
  String get filenameString;
  String get releaseYearFieldString;
  String get finishDateFieldString;
  String get finishDatesFieldString;
  String get emptyFinishDatesString;
  String get mainViewString;
  String get lastAddedViewString;
  String get lastUpdatedViewString;
  String get yearInReviewViewString;

  String get generalString;
  String get changeYearString;
  List<String> get daysOfWeek;
  List<String> get shortDaysOfWeek;
  List<String> get months;
  List<String> get shortMonths;
  //#endregion Common

  //#region Game
  String get gameString;
  String get gamesString;
  String get allString;
  String get ownedString;
  String get romsString;

  String get lowPriorityString;
  String get nextUpString;
  String get playingString;
  String get playedString;
  String gameStatusString(GameStatus? status);
  String get editionFieldString;
  String get statusFieldString;
  String get ratingFieldString;
  String get thoughtsFieldString;
  String get gameLogFieldString;
  String get gameLogsFieldString;
  String get saveFolderFieldString;
  String get screenshotFolderFieldString;
  String get backupFieldString;

  String get singleCalendarViewString;
  String get multiCalendarViewString;
  String get editTimeString;
  String get selectedDateIsFinishDateString;
  String get gameCalendarEventsString;
  String get firstGameLog;
  String get lastGameLog;
  String get previousGameLog;
  String get nextGameLog;
  String get emptyGameLogsString;
  String rangeString(CalendarRange range);
  String totalGames(int total);

  String get dateString;
  String get startTimeString;
  String get endTimeString;
  String get durationString;
  String get recalculationModeTitle;
  String get recalculationModeSubtitle;
  String get recalculationModeDurationString;
  String get recalculationModeTimeString;

  String get playingViewString;
  String get nextUpViewString;
  String get lastPlayedString;
  String get lastFinishedViewString;

  String gamesFromYearString(int year);
  String get totalGamesString;
  String get totalGamesPlayedString;
  String get totalTimeString;
  String get avgTimeString;
  String get avgRatingString;
  String get countByStatusString;
  String get countByReleaseYearString;
  String get sumTimeByFinishDateString;
  String get sumTimeByMonth;
  String get countByRatingString;
  String get countByFinishDate;
  String get countByTimeString;
  String get avgRatingByFinishDateString;
  //#endregion Game

  //#region DLC
  String get dlcString;
  String get dlcsString;

  String get baseGameFieldString;
  //#endregion DLC

  //#region Platform
  String get platformString;
  String get platformsString;

  String get physicalString;
  String get digitalString;
  String platformTypeString(PlatformType? type);
  String get platformTypeFieldString;
  //#endregion Platform

  //#region Tag
  String get tagString;
  String get tagsString;
  //#endregion Tag

  String formatEuro(double amount);
  String formatPercentage(double amount);
  String formatTimeOfDay(TimeOfDay time);
  String formatTime(DateTime date);
  String formatDate(DateTime date);
  String formatDateTime(DateTime date);
  String formatDuration(Duration duration);
  String formatMonthYear(DateTime date);
  String formatYear(int year);
  String formatShortYear(int year);
  String formatHours(int hours);
  String formatMinutes(int minutes);

  String editString(String fieldString);
  String addString(String fieldString);
  String get fieldUpdatedString;
  String get unableToUpdateFieldString;
  String get uploadImageString;
  String get replaceImageString;
  String get renameImageString;
  String get deleteImageString;
  String get imageUpdatedString;
  String get unableToUpdateImageString;
  String unableToLaunchString(String urlString);

  String linkString(String typeString);
  String get undoString;
  String get unableToUndoString;
  String get moreString;
  String get searchInListString;
  String linkedString(String typeString);
  String unableToLinkString(String typeString);
  String unlinkedString(String typeString);
  String unableToUnlinkString(String typeString);
  String unableToLoadString(String typeString);
  String get unableToLoadDetailString;
  String get unableToLoadCalendar;

  String searchString(String typeString);
  String get clearSearchString;
  String newWithTitleString(String typeString, String titleString);
  String get noSuggestionsString;
  String get noResultsString;

  static GameCollectionLocalisations of(BuildContext context) {
    final GameCollectionLocalisations? localisations =
        Localizations.of<GameCollectionLocalisations>(
      context,
      GameCollectionLocalisations,
    );
    if (localisations == null) {
      throw Exception();
    }

    return localisations;
  }
}

class LocalisationsUtils {
  LocalisationsUtils._();

  static String padTwoLeadingZeros(int value) {
    return value.toString().padLeft(2, '0');
  }
}

class GameCollectionLocalisationsDelegate
    extends LocalizationsDelegate<GameCollectionLocalisations> {
  const GameCollectionLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  Future<GameCollectionLocalisations> load(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return SynchronousFuture<GameCollectionLocalisations>(
          const GameCollectionLocalisationsEn(),
        );
      case 'es':
        return SynchronousFuture<GameCollectionLocalisations>(
          const GameCollectionLocalisationsEs(),
        );
      default:
        return SynchronousFuture<GameCollectionLocalisations>(
          const GameCollectionLocalisationsEn(),
        );
    }
  }

  @override
  bool shouldReload(GameCollectionLocalisationsDelegate old) => false;
}
