import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart' show NavDestination;
import 'package:game_oclock/utils/localisation_extension.dart';

final List<NavDestination> mainDestinations =
    List.unmodifiable(<NavDestination>[
      NavDestination(
        icon: CommonIcons.games,
        labelBuilder: (final context) => context.localize().gamesTitle,
        path: CommonPaths.gamesPath,
      ),
      NavDestination(
        icon: CommonIcons.locations,
        labelBuilder: (final context) => context.localize().locationsTitle,
        path: CommonPaths.locationsPath,
      ),
      NavDestination(
        icon: CommonIcons.devices,
        labelBuilder: (final context) => context.localize().devicesTitle,
        path: CommonPaths.devicesPath,
      ),
    ]);

final List<NavDestination> secondaryDestinations =
    List.unmodifiable(<NavDestination>[
      NavDestination(
        icon: CommonIcons.tags,
        labelBuilder: (final context) => context.localize().tagsTitle,
        path: CommonPaths.tagsPath,
      ),
      NavDestination(
        icon: CommonIcons.calendar,
        labelBuilder: (final context) => context.localize().calendarTitle,
        path: CommonPaths.calendarPath,
      ),
      NavDestination(
        icon: CommonIcons.review,
        labelBuilder: (final context) => context.localize().yearInReviewTitle,
        path: CommonPaths.reviewPath,
      ),
      NavDestination(
        icon: CommonIcons.users,
        labelBuilder: (final context) => context.localize().usersTitle,
        path: CommonPaths.usersPath,
      ),
      NavDestination(
        icon: CommonIcons.settings,
        labelBuilder: (final context) => context.localize().settingsTitle,
        path: CommonPaths.settingsPath,
      ),
    ]);
