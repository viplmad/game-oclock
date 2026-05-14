import 'package:game_oclock/models/nav_destination.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

const roleAdmin = 'ROLE_ADMIN';
const roleUser = 'ROLE_USER';

final userRoleUser = OptionTextField(
  value: roleUser,
  labelBuilder: (final context) => context.localize().roleUserLabel,
);

final userRoleAdmin = OptionTextField(
  value: roleAdmin,
  labelBuilder: (final context) => context.localize().roleAdminLabel,
);

final List<OptionTextField<String>> userRoleOptions = List.unmodifiable(
  <OptionTextField<String>>[userRoleUser, userRoleAdmin],
);

class NewUser extends NewUserDTO {
  NewUser({super.username, required this.password});

  final String password;
}

// TODO Move
class ReviewStartEnd {
  ReviewStartEnd({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

// TODO Move
class NewMediaSession extends NewSessionDTO {
  NewMediaSession({
    required this.gameId,
    required super.deviceId,
    required super.endDatetime,
    super.finishedStatus,
    required super.groupId,
    required super.startDatetime,
    required super.started,
  });

  final String gameId;
}

class AggregateGroupSearch {
  AggregateGroupSearch({this.filter = const [], this.size, this.sort});

  List<FilterDTO>? filter;

  /// Minimum value: 0
  int? size;

  AggregateGroupSortDTO? sort;
}

class AggregateSearch {
  AggregateSearch({this.filter = const []});

  List<FilterDTO>? filter;
}

const sourceIgdb = 'igdb';

class UserChangePassword {
  final String currentPassword;
  final String newPassword;

  const UserChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}
