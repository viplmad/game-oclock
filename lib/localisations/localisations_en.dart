import 'package:game_collection/localisations/localisations.dart';


class GameCollectionLocalisationsEn implements GameCollectionLocalisations {
  const GameCollectionLocalisationsEn();

  String get connectingString => 'Connecting...';
  String get failedConnectionString => 'Failed connection';
  String get retryString => 'Retry';
  String get changeRepositoryString => 'Change Repository Settings';

  String get repositorySettingsString => 'Repository settings';
  String get unableToUpdateConnectionString => 'Unable to update connection';
  String get saveString => 'Save';
  String get remoteRepositoryString => 'Remote repository';
  String get localRepositoryString => 'Local repository';
  String get hostString => 'Host';
  String get portString => 'Port';
  String get databaseString => 'Database';
  String get userString => 'User';
  String get passwordString => 'Password';
  String get cloudNameString => 'Cloud name';
  String get apiKeyString => 'API Key';
  String get apiSecretString => 'API Secret';

  String get changeOrderString => 'Change Order';
  String get changeStyleString => 'Change Style';
  String get changeViewString => 'Change View';
  String get searchInViewString => 'Search in View';
  String get statsInViewString => 'Stats in View';

  String newString(String typeString) {
    return 'New $typeString';
  }
  String get openString => 'Open';
  String addedString(String typeString) {
    return 'Added $typeString';
  }
  String unableToAddString(String typeString) {
    return 'Unable to add $typeString';
  }
  String deletedString(String typeString) {
    return 'Deleted $typeString';
  }
  String unableToDeleteString(String typeString) {
    return 'Unable to delete $typeString';
  }
  String get deleteString => 'Delete';
  String deleteDialogTitle(String itemString) {
    return 'Are you sure you want to delete $itemString?';
  }
  String get deleteDialogSubtitle => 'This action cannot be undone';

  //#region Common
  String get emptyValueString => '';
  String get showString => 'Show';
  String get hideString => 'Hide';
  String get enterTextString => 'Please enter some text';

  String get nameFieldString => 'Name';
  String get releaseYearFieldString => 'Release Year';
  String get finishDateFieldString => 'Finish Date';

  String get mainViewString => 'Main';
  String get lastCreatedViewString => 'Last Created';
  String get yearInReviewViewString => 'Year in Review';
  //#endregion Common

  //#region Game
  String get gameString => 'Game';
  String get gamesString => _plural(gameString);
  String get allString => 'All';
  String get ownedString => 'Owned';
  String get romsString => 'Roms';

  String get lowPriorityString => 'Low Priority';
  String get nextUpString => 'Next Up';
  String get playingString => 'Playing';
  String get playedString => 'Played';
  String get editionFieldString => 'Edition';
  String get statusFieldString => 'Status';
  String get ratingFieldString => 'Rating';
  String get thoughtsFieldString => 'Thoughts';
  String get timeFieldString => 'Time';
  String get saveFolderFieldString => 'Save Folder';
  String get screenshotFolderFieldString => 'Screenshot Folder';
  String get backupFieldString => 'Backup';

  String get playingViewString => 'Playing';
  String get nextUpViewString => 'Next Up';
  String get lastFinishedViewString => 'Last Finished';
  //#endregion Game

  //#region DLC
  String get dlcString => 'DLC';
  String get dlcsString => _plural(dlcString);

  String get baseGameFieldString => 'Base Game';
  //#endregion DLC

  //#region Purchase
  String get purchaseString => 'Purchase';
  String get purchasesString => _plural(purchaseString);

  String get descriptionFieldString => 'Description';
  String get priceFieldString => 'Price';
  String get externalCreditsFieldString => 'External Credit';
  String get purchaseDateFieldString => 'Date';
  String get originalPriceFieldString => 'Original Price';
  String get discountFieldString => 'Discount';

  String get pendingViewString => 'Pending';
  String get lastPurchasedViewString => 'Last Purchased';

  String get totalMoneySpentString => 'Total Money Spent';
  String get totalMoneySavedString => 'Total Money Saved';
  String get realValueString => 'Real Value';
  String get percentageSavedString => 'Percentage Saved';
  //#endregion Purchase

  //#region Store
  String get storeString => 'Store';
  String get storesString => _plural(storeString);
  //#endregion Store

  //#region Platform
  String get platformString => 'Platform';
  String get platformsString => _plural(platformString);

  String get physicalString => "Physical";
  String get digitalString => "Digital";
  String get platformTypeFieldString => 'Type';
  //#endregion Platform

  //#region System
  String get systemString => 'System';
  String get systemsString => _plural(systemString);
  //#endregion System

  //#region Tag
  String get tagString => 'Tag';
  String get tagsString => _plural(tagString);
  //#endregion Tag

  //#region PurchaseType
  String get purchaseTypeString => 'Type';
  String get purchaseTypesString => _plural(purchaseTypeString);
  //#endregion PurchaseType

  String euroString(String amountString) {
    return '$amountString €';
  }
  String percentageString(String amountString) {
    return '$amountString %';
  }
  String dateString(String dayString, String monthString, String yearString) {
    return '$dayString/$monthString/$yearString';
  }
  String durationString(String hoursString, String minutesString) {
    return '$hoursString:$minutesString';
  }

  String editString(String fieldString) {
    return 'Edit $fieldString';
  }
  String get fieldUpdatedString => 'Field updated';
  String get unableToUpdateFieldString => 'Unable to update field';
  String get uploadImageString => 'Upload image';
  String get replaceImageString => 'Replace image';
  String get renameImageString => 'Rename image';
  String get deleteImageString => 'Delete image';
  String get imageUpdatedString => 'Image updated';
  String get unableToUpdateImageString => 'Unable to update image';
  String unableToLaunchString(String urlString) {
    return 'Could not launch $urlString';
  }

  String linkString(String typeString) {
    return 'Link $typeString';
  }
  String get undoString => 'Undo';
  String get moreString => 'More';
  String get searchInListString => 'Search in List';
  String linkedString(String typeString) => 'Linked $typeString';
  String unableToLinkString(String typeString) => 'Unable to link $typeString';
  String unlinkedString(String typeString) => 'Unlinked $typeString';
  String unableToUnlinkString(String typeString) => 'Unable to unlink $typeString';

  String searchString(String typeString) {
    return 'Search $typeString';
  }
  String get clearSearchString => 'Clear';
  String newWithTitleString(String typeString, String titleString) {
    return '+ New $typeString titled \'$titleString\'';
  }
  String get noSuggestionsString => '';
  String get noResultsString => 'No results found';

  String _plural(String string) => string + 's';

}