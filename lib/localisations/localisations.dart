import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:backend/model/model.dart'
    show GameStatus, Manufacturer, PlatformType;
import 'package:backend/model/calendar_range.dart';

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

  String get aboutString;
  String get licenseInfoString;

  String get repositorySettingsString;
  String get updatedItemConnectionString;
  String get updatedImageConnectionString;
  String get unableToUpdateConnectionString;
  String get deletedItemConnectionString;
  String get deletedImageConnectionString;
  String get unableToDeleteConnectionString;
  String get saveString;
  String get itemConnectionString;
  String get imageConnectionString;

  static const String postgresString = 'Postgres';
  String get hostString;
  String get portString;
  String get databaseString;
  String get userString;
  String get passwordString;

  static const String cloudinaryString = 'Cloudinary';
  String get cloudNameString;
  String get apiKeyString;
  String get apiSecretString;

  String get localString;

  String get searchAllString;
  String get changeStyleString;
  String get changeViewString;
  String get changeRangeString;
  String get calendarView;
  String get searchInViewString;
  String get statsInViewString;

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
  String get lastCreatedViewString;
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
  String get timeLogFieldString;
  String get timeLogsFieldString;
  String get saveFolderFieldString;
  String get screenshotFolderFieldString;
  String get backupFieldString;

  String get singleCalendarViewString;
  String get multiCalendarViewString;
  String get editTimeString;
  String get selectedDateIsFinishDateString;
  String get gameCalendarEventsString;
  String get firstTimeLog;
  String get lastTimeLog;
  String get previousTimeLog;
  String get nextTimeLog;
  String get emptyTimeLogsString;
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

  //#region Purchase
  String get purchaseString;
  String get purchasesString;

  String get descriptionFieldString;
  String get priceFieldString;
  String get externalCreditsFieldString;
  String get purchaseDateFieldString;
  String get originalPriceFieldString;
  String get discountFieldString;

  String get pendingViewString;
  String get lastPurchasedViewString;

  String get totalMoneySpentString;
  String get totalMoneySavedString;
  String get realValueString;
  String get percentageSavedString;
  //#endregion Purchase

  //#region Store
  String get storeString;
  String get storesString;
  //#endregion Store

  //#region Platform
  String get platformString;
  String get platformsString;

  String get physicalString;
  String get digitalString;
  String platformTypeString(PlatformType? type);
  String get platformTypeFieldString;
  //#endregion Platform

  //#region System
  String get systemString;
  String get systemsString;

  static String manufacturerString(Manufacturer? manufacturer) {
    switch (manufacturer) {
      case Manufacturer.nintendo:
        return 'Nintendo';
      case Manufacturer.sony:
        return 'Sony';
      case Manufacturer.microsoft:
        return 'Microsoft';
      case Manufacturer.sega:
        return 'Sega';
      default:
        return '';
    }
  }
  //#endregion System

  //#region GameTag
  String get gameTagString;
  String get gameTagsString;
  //#endregion GameTag

  //#region PurchaseType
  String get purchaseTypeString;
  String get purchaseTypesString;
  //#endregion PurchaseType

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
  String get moreString;
  String get searchInListString;
  String linkedString(String typeString);
  String unableToLinkString(String typeString);
  String unlinkedString(String typeString);
  String unableToUnlinkString(String typeString);

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
