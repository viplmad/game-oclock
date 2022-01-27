const String connectRoute = '/';
const String homeRoute = '/home';

const String _settingsRoute = '/settings';
const String repositorySettingsRoute = _settingsRoute + 'repository';

const String _detailRoute = '/detail';
const String _searchRoute = '/search';
const String _localSearchRoute = '/search_local';
const String _statisticsRoute = '/statistics';
const String _calendarRoute = '/calendar';

const String _gameIdentifier = 'game';
const String _dlcIdentifier = 'dlc';
const String _purchaseIdentifier = 'purchase';
const String _storeIdentifier = 'store';
const String _platformIdentifier = 'platform';
const String _systemIdentifier = 'system';
const String _gameTagIdentifier = 'tag';
const String _purchaseTypeIdentifier = 'type';

const String gameDetailRoute = _detailRoute + _gameIdentifier;
const String gameSearchRoute = _searchRoute + _gameIdentifier;
const String gameLocalSearchRoute = _localSearchRoute + _gameIdentifier;
const String gameStatisticsRoute = _statisticsRoute + _gameIdentifier;
const String gameSingleCalendarRoute = _calendarRoute + _gameIdentifier;
const String gameMultiCalendarRoute = _calendarRoute + 'all' + _gameIdentifier;

const String dlcDetailRoute = _detailRoute + _dlcIdentifier;
const String dlcSearchRoute = _searchRoute + _dlcIdentifier;
const String dlcLocalSearchRoute = _localSearchRoute + _dlcIdentifier;
//const String dlcStatisticsRoute = _statisticsRoute + dlcIdentifier;

const String purchaseDetailRoute = _detailRoute + _purchaseIdentifier;
const String purchaseSearchRoute = _searchRoute + _purchaseIdentifier;
const String purchaseLocalSearchRoute = _localSearchRoute + _purchaseIdentifier;
const String purchaseStatisticsRoute = _statisticsRoute + _purchaseIdentifier;

const String storeDetailRoute = _detailRoute + _storeIdentifier;
const String storeSearchRoute = _searchRoute + _storeIdentifier;
const String storeLocalSearchRoute = _localSearchRoute + _storeIdentifier;
//const String storeStatisticsRoute = _statisticsRoute + storeIdentifier;

const String platformDetailRoute = _detailRoute + _platformIdentifier;
const String platformSearchRoute = _searchRoute + _platformIdentifier;
const String platformLocalSearchRoute = _localSearchRoute + _platformIdentifier;
//const String platformStatisticsRoute = _statisticsRoute + platformIdentifier;

//const String systemDetailRoute = _detailRoute + systemIdentifier;
const String systemSearchRoute = _searchRoute + _systemIdentifier;
const String systemLocalSearchRoute = _localSearchRoute + _systemIdentifier;
//const String systemStatisticsRoute = _statisticsRoute + systemIdentifier;

const String gameTagListRoute = '/list' + _gameTagIdentifier;
const String gameTagDetailRoute = _detailRoute + _gameTagIdentifier;
const String gameTagSearchRoute = _searchRoute + _gameTagIdentifier;
const String gameTagLocalSearchRoute = _localSearchRoute + _gameTagIdentifier;
//const String gameTagStatisticsRoute = _statisticsRoute + gameTagIdentifier;

//const String purchaseTypeDetailRoute = _detailRoute + purchaseTypeIdentifier;
const String purchaseTypeSearchRoute = _searchRoute + _purchaseTypeIdentifier;
const String purchaseTypeLocalSearchRoute = _localSearchRoute + _purchaseTypeIdentifier;
//const String purchaseTypeStatisticsRoute = _statisticsRoute + purchaseTypeIdentifier;

const String timeLogAssistantRoute = '/timeLogAssistant';