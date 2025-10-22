class CommonPaths {
  CommonPaths._();

  static const String loginPath = '/login';

  static const String gamesPath = '/games';
  static const String locationsPath = '/locations';
  static const String devicesPath = '/devices';
  static const String tagsPath = '/tags';
  static const String usersPath = '/users';
  static const String settingsPath = '/settings';

  static const String calendarPath = '/calendar';
  static const String reviewPath = '/review';

  static const String _idPathParamPath = '/$_idPath';
  static const String gamePath = gamesPath + _idPathParamPath;
  static const String gameCalendarPath = gamePath + calendarPath;

  static const String _idPath = ':$idPathParam';
  static const String idPathParam = 'id';

  static String buildGamePath(final String id) =>
      gamePath.replaceFirst(_idPath, id);
  static String buildGameCalendarPath(final String id) =>
      gameCalendarPath.replaceFirst(_idPath, id);
}
