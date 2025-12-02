import 'package:go_router/go_router.dart';

class CommonPaths {
  CommonPaths._();

  static const String loginPath = '/login';

  static const String homePath = gamesPath;
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
  static const String locationPath = locationsPath + _idPathParamPath;
  static const String devicePath = devicesPath + _idPathParamPath;
  static const String tagPath = tagsPath + _idPathParamPath;
  static const String userPath = usersPath + _idPathParamPath;

  static const String _idPath = ':$_idPathParam';
  static const String _idPathParam = 'id';

  static String buildGamePath(final String id) =>
      gamePath.replaceFirst(_idPath, id);
  static String buildGameCalendarPath(final String id) =>
      gameCalendarPath.replaceFirst(_idPath, id);
  static String buildLocationPath(final String id) =>
      locationPath.replaceFirst(_idPath, id);
  static String buildDevicePath(final String id) =>
      devicePath.replaceFirst(_idPath, id);
  static String buildTagPath(final String id) =>
      tagPath.replaceFirst(_idPath, id);
  static String buildUserPath(final String id) =>
      userPath.replaceFirst(_idPath, id);

  static String getIdParameter(final GoRouterState state) =>
      state.pathParameters[CommonPaths._idPathParam]!;
}
