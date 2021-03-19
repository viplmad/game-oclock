import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'localisations_en.dart';


abstract class GameCollectionLocalisations {
  const GameCollectionLocalisations();

  static String appTitle = 'Game Collection';

  String get connectingString;
  String get failedConnectionString;
  String get retryString;
  String get changeRepositoryString;

  String get repositorySettingsString;
  String get unableToUpdateConnectionString;
  String get saveString;
  String get remoteRepositoryString;
  String get localRepositoryString;
  String get hostString;
  String get portString;
  String get databaseString;
  String get userString;
  String get passwordString;
  String get cloudNameString;
  String get apiKeyString;
  String get apiSecretString;

  String get changeOrderString;
  String get changeStyleString;
  String get changeViewString;
  String get searchInViewString;
  String get statsInViewString;

  String newString(String typeString);
  String get openString;
  String addedString(String typeString);
  String unableToAddString(String typeString);
  String deletedString(String typeString);
  String unableToDeleteString(String typeString);

  String get duplicateString;
  String get deleteString;
  String deleteDialogTitle(String itemString);
  String get deleteDialogSubtitle;

  //#region Common
  String get emptyValueString;
  String get showString;
  String get hideString;
  String get enterTextString;

  String get nameFieldString;
  String get releaseYearFieldString;
  String get finishDateFieldString;
  String get finishDatesFieldString;
  String get emptyFinishDatesString;

  String get mainViewString;
  String get lastCreatedViewString;
  String get yearInReviewViewString;

  String get generalString;
  String get changeYearString;
  List<String> get shortMonths;
  List<String> get shortDaysOfWeek;
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
  String get editionFieldString;
  String get statusFieldString;
  String get ratingFieldString;
  String get thoughtsFieldString;
  String get timeLogFieldString;
  String get timeLogsFieldString;
  String get saveFolderFieldString;
  String get screenshotFolderFieldString;
  String get backupFieldString;
  String get calendarViewString;
  String get editTimeString;
  String get selectedDateIsFinishDateString;
  String get gameCalendarEventsString;
  String get firstTimeLog;
  String get lastTimeLog;
  String get previousTimeLog;
  String get nextTimeLog;
  String get emptyTimeLogsString;
  String get weekString;

  String get playingViewString;
  String get nextUpViewString;
  String get lastPlayedString;
  String get lastFinishedViewString;

  String gamesFromYearString(int year);
  String get totalGamesString;
  String get totalGamesPlayedString;
  String get sumTimeString;
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

  String purchasesFromYearString(int year);
  String get totalPurchasesString;
  String get totalPurchasesWithoutPromotionString;
  String get sumPriceString;
  String get avgPriceString;
  String get avgPriceWithoutPromotionString;
  String get sumExternalCreditString;
  String get avgExternalCreditString;
  String get sumOriginalPriceString;
  String get avgOriginalPriceString;
  String get avgDiscountString;
  String get avgDiscountWithoutPromotionString;
  String get sumSavedString;
  String get avgSavedString;
  String get countByYearString;
  String get sumPriceByYearString;
  String get sumOriginalPriceByYearString;
  String get countByMonthString;
  String get countByPriceString;
  String get sumPriceByMonthString;
  String get sumOriginalPriceByMonthString;
  String get sumSavedByMonthString;
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
  String get platformTypeFieldString;
  //#endregion Platform

  //#region System
  String get systemString;
  String get systemsString;
  //#endregion System

  //#region Tag
  String get tagString;
  String get tagsString;
  //#endregion Tag

  //#region PurchaseType
  String get purchaseTypeString;
  String get purchaseTypesString;
  //#endregion PurchaseType

  String euroString(double amount);
  String percentageString(double amount);
  String timeString(DateTime date);
  String dateString(DateTime date);
  String dateTimeString(DateTime date);
  String durationString(Duration duration);
  String yearString(int year);
  String shortYearString(int year);
  String hoursString(int hours);

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
    GameCollectionLocalisations? localisations = Localizations.of<GameCollectionLocalisations>(context, GameCollectionLocalisations);
    if(localisations == null) {
      throw Exception();
    }

    return localisations;
  }
}

class GameCollectionLocalisationsDelegate extends LocalizationsDelegate<GameCollectionLocalisations> {
  const GameCollectionLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<GameCollectionLocalisations> load(Locale locale) {

    switch (locale.languageCode) {
      case 'en':
        return SynchronousFuture<GameCollectionLocalisations>(GameCollectionLocalisationsEn());
      case 'es':
        //TODO
      default:
        return SynchronousFuture<GameCollectionLocalisations>(GameCollectionLocalisationsEn());
    }

  }

  @override
  bool shouldReload(GameCollectionLocalisationsDelegate old) => false;
}