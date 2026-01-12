import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart' show NavDestination, roleAdmin;
import 'package:game_oclock/utils/localisation_extension.dart';

final gamesNavDestination = NavDestination(
  icon: CommonIcons.games,
  labelBuilder: (final context) => context.localize().gamesTitle,
  path: CommonPaths.gamesPath,
);

final locationsNavDestination = NavDestination(
  icon: CommonIcons.locations,
  labelBuilder: (final context) => context.localize().locationsTitle,
  path: CommonPaths.locationsPath,
);

final devicesNavDestination = NavDestination(
  icon: CommonIcons.devices,
  labelBuilder: (final context) => context.localize().devicesTitle,
  path: CommonPaths.devicesPath,
);

final tagsNavDestination = NavDestination(
  icon: CommonIcons.tags,
  labelBuilder: (final context) => context.localize().tagsTitle,
  path: CommonPaths.tagsPath,
);

final playthroughsNavDestination = NavDestination(
  icon: CommonIcons.playthroughs,
  labelBuilder: (final context) => context.localize().playthroughsTitle,
  path: CommonPaths.playthroughsPath,
);

final calendarNavDestination = NavDestination(
  icon: CommonIcons.calendar,
  labelBuilder: (final context) => context.localize().calendarTitle,
  path: CommonPaths.calendarPath,
);

final reviewNavDestination = NavDestination(
  icon: CommonIcons.review,
  labelBuilder: (final context) => context.localize().yearInReviewTitle,
  path: CommonPaths.reviewPath,
);

final usersNavDestination = NavDestination(
  icon: CommonIcons.users,
  labelBuilder: (final context) => context.localize().usersTitle,
  path: CommonPaths.usersPath,
  guardRole: roleAdmin,
);

final settingsNavDestination = NavDestination(
  icon: CommonIcons.settings,
  labelBuilder: (final context) => context.localize().settingsTitle,
  path: CommonPaths.settingsPath,
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
