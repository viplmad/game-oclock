class CommonPaths {
  CommonPaths._();

  static const String loginPath = '/login';

  static const String gamesPath = '/games';
  static const String locationsPath = '/locations';
  static const String devicesPath = '/devices';
  static const String tagsPath = '/tags';
  static const String usersPath = '/users';

  static const String calendarPath = '/calendar';

  static const String _idPathParamPath = '/:id';
  static const String gamePath = gamesPath + _idPathParamPath;

  static const String idPathParam = 'id';
}
