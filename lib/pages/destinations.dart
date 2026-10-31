import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show NavDestination, roleAdmin, roleUser;
import 'package:game_oclock/utils/localisation_extension.dart';

final List<String> _allUsers = List.unmodifiable(<String>[roleUser, roleAdmin]);
final List<String> _onlyAdmin = List.unmodifiable(<String>[roleAdmin]);

final gamesNavDestination = NavDestination(
  icon: CommonIcons.games,
  labelBuilder: (context) => context.localize().gamesTitle,
  path: CommonPaths.gamesPath,
  guardRoles: _allUsers,
);

final locationsNavDestination = NavDestination(
  icon: CommonIcons.locations,
  labelBuilder: (context) => context.localize().locationsTitle,
  path: CommonPaths.locationsPath,
  guardRoles: _allUsers,
);

final devicesNavDestination = NavDestination(
  icon: CommonIcons.devices,
  labelBuilder: (context) => context.localize().devicesTitle,
  path: CommonPaths.devicesPath,
  guardRoles: _allUsers,
);

final tagsNavDestination = NavDestination(
  icon: CommonIcons.tags,
  labelBuilder: (context) => context.localize().tagsTitle,
  path: CommonPaths.tagsPath,
  guardRoles: _allUsers,
);

final playthroughsNavDestination = NavDestination(
  icon: CommonIcons.playthroughs,
  labelBuilder: (context) => context.localize().playthroughsTitle,
  path: CommonPaths.playthroughsPath,
  guardRoles: _allUsers,
);

final searchNavDestination = NavDestination(
  icon: CommonIcons.search,
  labelBuilder: (context) => context.localize().searchTitle,
  path: CommonPaths.searchPath,
  guardRoles: _allUsers,
);

final calendarNavDestination = NavDestination(
  icon: CommonIcons.calendar,
  labelBuilder: (context) => context.localize().calendarTitle,
  path: CommonPaths.calendarPath,
  guardRoles: _allUsers,
);

final reviewNavDestination = NavDestination(
  icon: CommonIcons.review,
  labelBuilder: (context) => context.localize().yearInReviewTitle,
  path: CommonPaths.reviewPath,
  guardRoles: _allUsers,
);

final usersNavDestination = NavDestination(
  icon: CommonIcons.users,
  labelBuilder: (context) => context.localize().usersTitle,
  path: CommonPaths.usersPath,
  guardRoles: _onlyAdmin,
);

final logoutNavDestination = NavDestination(
  icon: CommonIcons.logout,
  labelBuilder: (context) => context.localize().logoutLabel,
  path: CommonPaths.logoutPath,
  guardRoles: _allUsers,
);

final settingsNavDestination = NavDestination(
  icon: CommonIcons.settings,
  labelBuilder: (context) => context.localize().settingsTitle,
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

final List<NavDestination> secondaryDestinations = List.unmodifiable(
  <NavDestination>[
    tagsNavDestination,
    playthroughsNavDestination,
    searchNavDestination,
    calendarNavDestination,
    reviewNavDestination,
    usersNavDestination,
  ],
);

final List<NavDestination> trailingDestinations = List.unmodifiable(
  <NavDestination>[logoutNavDestination, settingsNavDestination],
);
