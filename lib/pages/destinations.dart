import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show NavDestination, roleAdmin, roleUser;
import 'package:game_oclock/utils/localisation_extension.dart';

final List<String> _allUsers = List.unmodifiable(<String>[roleUser]);
final List<String> _onlyAdmin = List.unmodifiable(<String>[
  roleUser,
  roleAdmin,
]);

final gamesNavDestination = NavDestination(
  icon: CommonIcons.games,
  labelBuilder: (final context) => context.localize().gamesTitle,
  path: CommonPaths.gamesPath,
  guardRoles: _allUsers,
);

final locationsNavDestination = NavDestination(
  icon: CommonIcons.locations,
  labelBuilder: (final context) => context.localize().locationsTitle,
  path: CommonPaths.locationsPath,
  guardRoles: _allUsers,
);

final devicesNavDestination = NavDestination(
  icon: CommonIcons.devices,
  labelBuilder: (final context) => context.localize().devicesTitle,
  path: CommonPaths.devicesPath,
  guardRoles: _allUsers,
);

final tagsNavDestination = NavDestination(
  icon: CommonIcons.tags,
  labelBuilder: (final context) => context.localize().tagsTitle,
  path: CommonPaths.tagsPath,
  guardRoles: _allUsers,
);

final playthroughsNavDestination = NavDestination(
  icon: CommonIcons.playthroughs,
  labelBuilder: (final context) => context.localize().playthroughsTitle,
  path: CommonPaths.playthroughsPath,
  guardRoles: _allUsers,
);

final calendarNavDestination = NavDestination(
  icon: CommonIcons.calendar,
  labelBuilder: (final context) => context.localize().calendarTitle,
  path: CommonPaths.calendarPath,
  guardRoles: _allUsers,
);

final reviewNavDestination = NavDestination(
  icon: CommonIcons.review,
  labelBuilder: (final context) => context.localize().yearInReviewTitle,
  path: CommonPaths.reviewPath,
  guardRoles: _allUsers,
);

final usersNavDestination = NavDestination(
  icon: CommonIcons.users,
  labelBuilder: (final context) => context.localize().usersTitle,
  path: CommonPaths.usersPath,
  guardRoles: _onlyAdmin,
);

final settingsNavDestination = NavDestination(
  icon: CommonIcons.settings,
  labelBuilder: (final context) => context.localize().settingsTitle,
  path: CommonPaths.settingsPath,
  guardRoles: _allUsers,
);

final List<NavDestination> mainDestinations = List.unmodifiable(
  <NavDestination>[
    gamesNavDestination,
    locationsNavDestination,
    devicesNavDestination,
  ],
);

final List<NavDestination> secondaryDestinations =
    List.unmodifiable(<NavDestination>[
      tagsNavDestination,
      playthroughsNavDestination,
      calendarNavDestination,
      reviewNavDestination,
      usersNavDestination,
    ]);

final List<NavDestination> trailingDestinations = List.unmodifiable(
  <NavDestination>[settingsNavDestination],
);
