const String connectRoute = '/';
const String homeRoute = '/home';

const String _settingsRoute = '/settings';
const String serverSettingsRoute = '${_settingsRoute}server';

const String _detailRoute = '/detail';
const String _listRoute = '/list';
const String _searchRoute = '/search';
const String _calendarRoute = '/calendar';
const String _reviewRoute = '/review';

const String _gameIdentifier = 'game';
const String _dlcIdentifier = 'dlc';
const String _platformIdentifier = 'platform';
const String _tagIdentifier = 'tag';
const String _gameWishlistedIdentifier = '${_gameIdentifier}Wishlisted';

const String gameDetailRoute = _detailRoute + _gameIdentifier;
const String gameSearchRoute = _searchRoute + _gameIdentifier;
const String gameSingleCalendarRoute = _calendarRoute + _gameIdentifier;
const String gameMultiCalendarRoute = '${_calendarRoute}all$_gameIdentifier';

const String dlcDetailRoute = _detailRoute + _dlcIdentifier;
const String dlcSearchRoute = _searchRoute + _dlcIdentifier;

const String platformDetailRoute = _detailRoute + _platformIdentifier;
const String platformSearchRoute = _searchRoute + _platformIdentifier;

const String tagListRoute = _listRoute + _tagIdentifier;
const String tagDetailRoute = _detailRoute + _tagIdentifier;
const String tagSearchRoute = _searchRoute + _tagIdentifier;

const String gameWishlistedListRoute = _listRoute + _gameWishlistedIdentifier;
const String gameWishlistedSearchRoute =
    _searchRoute + _gameWishlistedIdentifier;

const String gameLogAssistantRoute = '/gameLogAssistant';

const String reviewYearRoute = '${_reviewRoute}year';
