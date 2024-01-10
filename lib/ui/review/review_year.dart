import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart'
    show
        GameDTO,
        GameFinishedReviewDTO,
        GamePlayedReviewDTO,
        GamesFinishedReviewDTO,
        GamesPlayedReviewDTO;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/review/review.dart';
import 'package:logic/bloc/review_manager/review_manager.dart';
import 'package:logic/utils/duration_extension.dart';

import 'package:game_oclock/ui/common/year_picker_dialog.dart';
import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/item_view.dart';
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/statistics_histogram.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';
import '../detail/detail_arguments.dart';
import '../theme/theme.dart' show AppTheme, GameTheme;

const int topMax = 5;
const int maxRecentYears = 7;

class ReviewYear extends StatelessWidget {
  const ReviewYear({
    Key? key,
    this.year,
  }) : super(key: key);

  final int? year;

  @override
  Widget build(BuildContext context) {
    final GameOClockService collectionService =
        RepositoryProvider.of<GameOClockService>(context);

    final ReviewManagerBloc managerBloc = ReviewManagerBloc();

    final ReviewBloc bloc = ReviewBloc(
      collectionService: collectionService,
      managerBloc: managerBloc,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<ReviewBloc>(
          create: (BuildContext context) {
            return bloc..add(LoadReview(year));
          },
        ),
        BlocProvider<ReviewManagerBloc>(
          create: (BuildContext context) {
            return managerBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.yearInReviewViewString),
          // Fixed elevation so background colour doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
          actions: <Widget>[
            BlocBuilder<ReviewBloc, ReviewState>(
              builder: (BuildContext context, ReviewState state) {
                int? selectedYear;
                if (state is ReviewLoaded) {
                  selectedYear = state.year;
                }

                return IconButton(
                  icon: const Icon(AppTheme.changeRangeIcon),
                  tooltip: AppLocalizations.of(context)!.changeYearString,
                  onPressed: () async {
                    showDialog<int?>(
                      context: context,
                      builder: (BuildContext context) {
                        return YearPickerDialog(
                          year: selectedYear,
                        );
                      },
                    ).then((int? year) {
                      if (year != null) {
                        BlocProvider.of<ReviewBloc>(context)
                            .add(LoadReview(year));
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
        body: const _ReviewYearBody(),
      ),
    );
  }
}

class _ReviewYearBody extends StatelessWidget {
  const _ReviewYearBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewManagerBloc, ReviewManagerState>(
      listener: (BuildContext context, ReviewManagerState state) {
        if (state is ReviewNotLoaded) {
          final String message =
              AppLocalizations.of(context)!.unableToLoadReview;
          showSnackBar(
            context,
            message: message,
            snackBarAction: dialogSnackBarAction(
              context,
              label: AppLocalizations.of(context)!.moreString,
              title: message,
              content: state.error,
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<ReviewBloc>(context).add(ReloadReview());
        },
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (BuildContext context, ReviewState state) {
            if (state is ReviewLoaded) {
              if (state.playedData.totalTime.isZero()) {
                return Column(
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                      child: HeaderText(
                        text: '${state.year}',
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.emptyPlayTime,
                        ),
                      ),
                    ),
                  ],
                );
              }

              final GamesPlayedReviewDTO playedData = state.playedData;
              final GamesFinishedReviewDTO finishedData = state.finishedData;
              final List<GamePlayedReviewDTO> games = playedData.games;
              final List<GameFinishedReviewDTO> finishedGames =
                  finishedData.games;
              final bool shouldShowFinishedInfo =
                  finishedData.totalFinished > 0;

              // Sort by most played
              games.sort(
                (GamePlayedReviewDTO a, GamePlayedReviewDTO b) =>
                    -a.totalTime!.compareTo(b.totalTime!),
              );
              final Map<String, Color> gamesColour = <String, Color>{
                for (int index = 0; index < games.length; index++)
                  games.elementAt(index).id: GameTheme.chartColors
                      .elementAt(index % GameTheme.chartColors.length),
              };

              final List<Widget> widgets = <Widget>[];
              widgets.add(
                CardWithTap(
                  onTap: onPlayedTap(
                    context,
                    gamesColour,
                    games,
                    finishedGames,
                    playedData.totalTime,
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(GameTheme.sessionIcon),
                        title: Text(
                          AppLocalizations.of(context)!
                              .totalGamesPlayedString(playedData.totalPlayed),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!
                                  .sessionsPlayedString(
                                playedData.totalSessions,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.playTimeString(
                                AppLocalizationsUtils.formatDuration(
                                  context,
                                  playedData.totalTime,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(GameTheme.firstPlayedIcon),
                        title: Text(
                          AppLocalizations.of(context)!.totalFirstPlayedString(
                            playedData.totalFirstPlayed,
                          ),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!
                              .percentagePlayedStartedThisYear(
                            formatPercentageForCard(
                              playedData.totalFirstPlayed /
                                  playedData.totalPlayed,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              if (shouldShowFinishedInfo) {
                widgets.add(
                  CardWithTap(
                    onTap: onFinishedTap(
                      context,
                      gamesColour,
                      finishedGames,
                      games,
                      playedData.totalTime,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(GameTheme.finishIcon),
                          title: Text(
                            AppLocalizations.of(context)!
                                .totalGamesFinishedString(
                              finishedData.totalFinished,
                            ),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .percentagePlayedFinishedString(
                              formatPercentageForCard(
                                finishedData.totalFinished /
                                    playedData.totalPlayed,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(GameTheme.firstPlayedIcon),
                          title: Text(
                            AppLocalizations.of(context)!
                                .totalFirstFinishedString(
                              finishedData.totalFirstFinished,
                            ),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!
                                .percentageFinishedFirstFinishedThisYearString(
                              formatPercentageForCard(
                                finishedData.totalFirstFinished /
                                    finishedData.totalFinished,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final GamePlayedReviewDTO longestSessionGame = games.firstWhere(
                (GamePlayedReviewDTO g) =>
                    g.id == playedData.longestSession.gameId,
              );
              GameFinishedReviewDTO? longestSessionFinishedGame;
              try {
                longestSessionFinishedGame = finishedGames.firstWhere(
                  (GameFinishedReviewDTO g) => g.id == longestSessionGame.id,
                );
              } on StateError catch (_) {}
              widgets.add(
                CardWithTap(
                  // TODO different info
                  onTap: onGameTap(
                    context,
                    gamesColour[longestSessionGame.id]!,
                    longestSessionGame,
                    longestSessionFinishedGame,
                    playedData.totalTime,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(GameTheme.longestSessionIcon),
                        title: Text(
                          AppLocalizations.of(context)!
                              .playTimeLongestSessionString(
                            AppLocalizationsUtils.formatDuration(
                              context,
                              playedData.longestSession.time,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.playingGameString(
                                GameTheme.itemTitle(longestSessionGame),
                              ),
                            ),
                            Text(
                              '${AppLocalizationsUtils.formatDate(playedData.longestSession.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(playedData.longestSession.startDatetime), alwaysUse24HourFormat: true)} ⮕ ${AppLocalizationsUtils.formatDate(playedData.longestSession.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(playedData.longestSession.endDatetime), alwaysUse24HourFormat: true)}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              widgets.add(
                CardWithTap(
                  onTap: onLongestStreakTap(
                    context,
                    gamesColour,
                    playedData.longestStreak.gamesIds
                        .map(
                          (String streakGameId) => games.firstWhere(
                            (GamePlayedReviewDTO g) => g.id == streakGameId,
                          ),
                        )
                        .toList(growable: false),
                    finishedGames,
                    playedData.totalTime,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(GameTheme.longestStreakIcon),
                        title: Text(
                          AppLocalizations.of(context)!.daysLongestStreakString(
                            playedData.longestStreak.days,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!
                                  .playingDifferentGameString(
                                playedData.longestStreak.gamesIds.length,
                              ),
                            ),
                            Text(
                              '${AppLocalizationsUtils.formatDate(playedData.longestStreak.startDate)} ⮕ ${AppLocalizationsUtils.formatDate(playedData.longestStreak.endDate)}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              widgets.add(
                const Divider(height: 4.0),
              );
              final List<Icon> topIcons = <Icon>[
                const Icon(GameTheme.firstIcon),
                const Icon(GameTheme.secondIcon),
                const Icon(GameTheme.thirdIcon),
                const Icon(GameTheme.fourthIcon),
                const Icon(GameTheme.fifthIcon),
              ];
              final Iterable<Widget> topGames =
                  games.take(topMax).map((GamePlayedReviewDTO game) {
                GameFinishedReviewDTO? finishedGame;
                try {
                  finishedGame = finishedGames.firstWhere(
                    (GameFinishedReviewDTO g) => g.id == game.id,
                  );
                } on StateError catch (_) {}

                return buildTopGameCard(
                  context,
                  gamesColour[game.id]!,
                  game,
                  finishedGame,
                  playedData.totalTime,
                );
              });
              for (int index = 0; index < topGames.length; index++) {
                widgets.add(topIcons.elementAt(index));
                widgets.add(topGames.elementAt(index));
              }
              widgets.add(
                const Divider(height: 4.0),
              );
              widgets.add(
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: buildTotalPlayedByReleaseYearPieChart(
                    context,
                    playedData.totalPlayedByReleaseYear,
                    playedData.totalPlayed,
                    state.year,
                    maxRecentYears,
                  ),
                ),
              );
              if (shouldShowFinishedInfo) {
                widgets.add(
                  Card(
                    margin: const EdgeInsets.all(0.0),
                    child: buildTotalFinishedByReleaseYearPieChart(
                      context,
                      finishedData.totalFinishedByReleaseYear,
                      finishedData.totalFinished,
                      state.year,
                      maxRecentYears,
                    ),
                  ),
                );
              }
              widgets.add(
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: buildTotalTimeByMonthStackedBarChart(
                    context,
                    games
                        .map(
                          (GamePlayedReviewDTO game) => gamesColour[game.id]!,
                        )
                        .toList(growable: false),
                    games
                        .map(
                          (GamePlayedReviewDTO game) => game.totalTimeGrouped,
                        )
                        .toList(growable: false),
                    playedData.totalTime,
                  ),
                ),
              );
              widgets.add(
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: buildTotalSessionsByMonthStackedBarChart(
                    context,
                    games
                        .map(
                          (GamePlayedReviewDTO game) => gamesColour[game.id]!,
                        )
                        .toList(growable: false),
                    games
                        .map(
                          (GamePlayedReviewDTO game) =>
                              game.totalSessionsGrouped,
                        )
                        .toList(growable: false),
                    playedData.totalSessions,
                  ),
                ),
              );
              if (shouldShowFinishedInfo) {
                widgets.add(
                  Card(
                    margin: const EdgeInsets.all(0.0),
                    child: buildTotalFinishedByMonthBarChart(
                      context,
                      finishedData.totalFinishedGrouped,
                      finishedData.totalFinished,
                    ),
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                    child: HeaderText(
                      text: '${state.year}',
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ItemListBuilder(
                        itemCount: widgets.length,
                        itemBuilder: (BuildContext context, int index) {
                          return widgets.elementAt(index);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state is ReviewError) {
              return const SizedBox();
            }

            return Column(
              children: <Widget>[
                const LinearProgressIndicator(),
                Container(
                  color: Colors.grey,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      HeaderSkeleton(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildTopGameCard(
    BuildContext context,
    Color colour,
    GamePlayedReviewDTO game,
    GameFinishedReviewDTO? finishedGame,
    Duration totalTime,
  ) {
    return _buildGameCard(
        context, colour, game, finishedGame, totalTime, <Widget>[
      buildGameSessionTime(context, game, totalTime),
      buildGameLongestSession(context, game),
      buildGameLongestStreak(context, game),
    ]);
  }

  Widget buildSimpleGameCard(
    BuildContext context,
    Color colour,
    GamePlayedReviewDTO game,
    GameFinishedReviewDTO? finishedGame,
    Duration totalTime,
  ) {
    return _buildGameCard(
      context,
      colour,
      game,
      finishedGame,
      totalTime,
      <Widget>[],
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    Color colour,
    GamePlayedReviewDTO game,
    GameFinishedReviewDTO? finishedGame,
    Duration totalTime,
    List<Widget> additionalWidgets,
  ) {
    return GameTheme.itemCardWithAdditionalWidgets(
      context,
      game,
      SizedBox(
        height: kMinInteractiveDimension,
        width: kMinInteractiveDimension,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            game.firstPlayed
                ? const Icon(GameTheme.firstPlayedIcon)
                : const SizedBox(),
            finishedGame != null && finishedGame.firstFinished
                ? const Icon(GameTheme.firstFinishedIcon)
                : const SizedBox(),
          ],
        ),
      ),
      additionalWidgets,
      (BuildContext context, _) => onGameTap(
        context,
        colour,
        game,
        finishedGame,
        totalTime,
      ),
    );
  }

  SizedBox buildTotalPlayedByReleaseYearPieChart(
    BuildContext context,
    Map<int, int> totalPlayedByReleaseYear,
    int totalPlayed,
    int year,
    int recentYearsMax,
  ) {
    final int totalCurrentYear = totalPlayedByReleaseYear[year] ?? 0;
    final int totalRecentYears = List<int>.generate(
      recentYearsMax,
      (int index) => totalPlayedByReleaseYear[year - index - 1] ?? 0,
    ).fold(0, (int acc, int val) => acc += val);
    final int totalRest = totalPlayed - totalCurrentYear - totalRecentYears;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: StatisticsPieChart<double>(
        name: AppLocalizations.of(context)!.gamesPlayedByReleaseYearString,
        domainLabels: <String>[
          AppLocalizations.of(context)!.newRelasesString,
          AppLocalizations.of(context)!.recentString,
          AppLocalizations.of(context)!.classicGamesString,
        ].toList(growable: false),
        values: <int>[totalCurrentYear, totalRecentYears, totalRest]
            .map(
              (int totalReleaseYear) => totalReleaseYear / totalPlayed,
            )
            .toList(growable: false),
        colours: GameTheme.chartColors.take(3).toList(growable: false),
        valueFormatter: (String domainLabel, double percentage) =>
            '$domainLabel - ${AppLocalizationsUtils.formatPercentage(percentage)}',
      ),
    );
  }

  SizedBox buildTotalFinishedByReleaseYearPieChart(
    BuildContext context,
    Map<int, int> totalFinishedByReleaseYear,
    int totalFinished,
    int year,
    int recentYearsMax,
  ) {
    final int totalCurrentYear = totalFinishedByReleaseYear[year] ?? 0;
    final int totalRecentYears = List<int>.generate(
      recentYearsMax,
      (int index) => totalFinishedByReleaseYear[year - index - 1] ?? 0,
    ).fold(0, (int acc, int val) => acc += val);
    final int totalRest = totalFinished - totalCurrentYear - totalRecentYears;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: StatisticsPieChart<double>(
        name: AppLocalizations.of(context)!.gamesFinishedByReleaseYearString,
        domainLabels: <String>[
          AppLocalizations.of(context)!.newRelasesString,
          AppLocalizations.of(context)!.recentString,
          AppLocalizations.of(context)!.classicGamesString,
        ].toList(growable: false),
        values: <int>[totalCurrentYear, totalRecentYears, totalRest]
            .map(
              (int totalReleaseYear) => totalReleaseYear / totalFinished,
            )
            .toList(growable: false),
        colours: GameTheme.chartColors.take(3).toList(growable: false),
        valueFormatter: (String domainLabel, double percentage) =>
            '$domainLabel - ${AppLocalizationsUtils.formatPercentage(percentage)}',
      ),
    );
  }

  SizedBox buildTotalTimeByMonthStackedBarChart(
    BuildContext context,
    List<Color> colours,
    List<Map<int, Duration>> gamesTotalTimeGrouped,
    Duration totalTime,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: StatisticsStackedHistogram<int>(
        name: AppLocalizations.of(context)!.playTimeByByMonthString,
        domainLabels: AppLocalizationsUtils.monthsAbbr(),
        stackedValues: gamesTotalTimeGrouped
            .map(
              (Map<int, Duration> gameTotalTimeGrouped) =>
                  // First normalise entries
                  List<int>.generate(
                DateTime.monthsPerYear,
                (int index) {
                  final Duration gameMonthTotalTime =
                      gameTotalTimeGrouped[index + 1] ?? const Duration();
                  return preparePercentageForChart(
                    gameMonthTotalTime.inMinutes / totalTime.inMinutes,
                  );
                },
              ),
            )
            .toList(growable: false),
        colours: colours,
        valueFormatter: (int percentage) =>
            AppLocalizationsUtils.formatPercentage(percentage / 100),
      ),
    );
  }

  SizedBox buildTotalSessionsByMonthStackedBarChart(
    BuildContext context,
    List<Color> colours,
    List<Map<int, int>> gamesTotalSessionsGrouped,
    int totalSessions,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: StatisticsStackedHistogram<int>(
        name: AppLocalizations.of(context)!.sessionsPlayedByMonthString,
        domainLabels: AppLocalizationsUtils.monthsAbbr(),
        stackedValues: gamesTotalSessionsGrouped
            .map(
              (Map<int, int> gameTotalSessionsGrouped) =>
                  // First normalise entries
                  List<int>.generate(
                DateTime.monthsPerYear,
                (int index) {
                  final int gameMonthTotalSessions =
                      gameTotalSessionsGrouped[index + 1] ?? 0;
                  return preparePercentageForChart(
                    gameMonthTotalSessions / totalSessions,
                  );
                },
              ),
            )
            .toList(growable: false),
        colours: colours,
        valueFormatter: (int percentage) =>
            AppLocalizationsUtils.formatPercentage(percentage / 100),
      ),
    );
  }

  SizedBox buildTotalFinishedByMonthBarChart(
    BuildContext context,
    Map<int, int> totalFinishedGrouped,
    int totalFinished,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: StatisticsHistogram<int>(
        name: AppLocalizations.of(context)!.gamesFinishedByMonthString,
        domainLabels: AppLocalizationsUtils.monthsAbbr(),
        // First normalise entries
        values: List<int>.generate(DateTime.monthsPerYear, (int index) {
          final int monthTotalFinished = totalFinishedGrouped[index + 1] ?? 0;
          return preparePercentageForChart(monthTotalFinished / totalFinished);
        }).toList(growable: false),
        valueFormatter: (int percentage) =>
            AppLocalizationsUtils.formatPercentage(percentage / 100),
      ),
    );
  }

  SizedBox buildGameTotalTimeByMonthBarChart(
    BuildContext context,
    Color colour,
    Map<int, Duration> gameTotalTimeGrouped,
    Duration totalTime,
  ) {
    // TODO y axis 100 / 75 / 50 / 25 / <1
    return buildTotalTimeByMonthStackedBarChart(
      context,
      <Color>[colour],
      <Map<int, Duration>>[gameTotalTimeGrouped],
      totalTime,
    );
  }

  SizedBox buildGameTotalSessionsByMonthBarChart(
    BuildContext context,
    Color colour,
    Map<int, int> gameTotalSessionsGrouped,
    int totalSessions,
  ) {
    return buildTotalSessionsByMonthStackedBarChart(
      context,
      <Color>[colour],
      <Map<int, int>>[gameTotalSessionsGrouped],
      totalSessions,
    );
  }

  static int preparePercentageForChart(double percentage) {
    return (percentage * 100).round();
  }

  static String formatPercentageForCard(double percentage) {
    return percentage >= 0.01
        ? AppLocalizationsUtils.formatPercentage(
            percentage,
          )
        : '<${AppLocalizationsUtils.formatPercentage(
            0.01,
          )}';
  }

  void Function()? onPlayedTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return () async {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          final List<Widget> widgets = games.map((GamePlayedReviewDTO game) {
            GameFinishedReviewDTO? finishedGame;
            try {
              finishedGame = finishedGames.firstWhere(
                (GameFinishedReviewDTO g) => g.id == game.id,
              );
            } on StateError catch (_) {}

            // TODO show different information for played, ordered by first play or grouped by month
            return buildSimpleGameCard(
              context,
              gamesColour[game.id]!,
              game,
              finishedGame,
              totalTime,
            );
          }).toList(growable: false);

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: HeaderText(
                  text: AppLocalizations.of(context)!.playedString,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ItemListBuilder(
                    itemCount: widgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widgets.elementAt(index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    };
  }

  void Function()? onFinishedTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    List<GameFinishedReviewDTO> games,
    List<GamePlayedReviewDTO> playedGames,
    Duration totalTime,
  ) {
    return () async {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          final List<Widget> widgets = games.map((GameFinishedReviewDTO game) {
            final GamePlayedReviewDTO playedGame = playedGames.firstWhere(
              (GamePlayedReviewDTO g) => g.id == game.id,
            );

            // TODO show different information for finished, ordered by first finished or grouped by month finished
            return buildSimpleGameCard(
              context,
              gamesColour[game.id]!,
              playedGame,
              game,
              totalTime,
            );
          }).toList(growable: false);

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: HeaderText(
                  text: AppLocalizations.of(context)!.finishedString,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ItemListBuilder(
                    itemCount: widgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widgets.elementAt(index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    };
  }

  void Function()? onLongestStreakTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return () async {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          final List<Widget> widgets = games.map((GamePlayedReviewDTO game) {
            GameFinishedReviewDTO? finishedGame;
            try {
              finishedGame = finishedGames.firstWhere(
                (GameFinishedReviewDTO g) => g.id == game.id,
              );
            } on StateError catch (_) {}

            // TODO show different information for streaks
            return buildSimpleGameCard(
              context,
              gamesColour[game.id]!,
              game,
              finishedGame,
              totalTime,
            );
          }).toList(growable: false);

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: HeaderText(
                  text: AppLocalizations.of(context)!.longestStreakString,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ItemListBuilder(
                    itemCount: widgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widgets.elementAt(index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    };
  }

  void Function()? onGameTap(
    BuildContext context,
    Color gameColour,
    GamePlayedReviewDTO game,
    GameFinishedReviewDTO? finishedGame,
    Duration totalTime,
  ) {
    return () async {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          final List<Widget> widgets = <Widget>[
            ListTile(
              leading: Icon(
                game.firstPlayed
                    ? GameTheme.firstPlayedIcon
                    : GameTheme.notFirstPlayedIcon,
              ),
              title: Text(
                game.firstPlayed
                    ? AppLocalizations.of(context)!.startedThisYearString
                    : AppLocalizations.of(context)!.pickedBackThisYearString,
              ),
            ),
            finishedGame != null
                ? ListTile(
                    leading: Icon(
                      finishedGame.firstFinished
                          ? GameTheme.firstFinishedIcon
                          : GameTheme.notFirstFinishedIcon,
                    ),
                    title: Text(
                      finishedGame.firstFinished
                          ? AppLocalizations.of(context)!
                              .firstFinishedThisYearString
                          : AppLocalizations.of(context)!
                              .finishedAgainThisYearString,
                    ),
                  )
                : const SizedBox(),
            buildGameSessionTime(context, game, totalTime),
            buildGameLongestSession(context, game),
            buildGameLongestStreak(context, game),
            buildGameTotalTimeByMonthBarChart(
              context,
              gameColour,
              game.totalTimeGrouped,
              game.totalTime!,
            ),
            buildGameTotalSessionsByMonthBarChart(
              context,
              gameColour,
              game.totalSessionsGrouped,
              game.totalSessions,
            ),
          ];

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: HeaderText(
                  text: GameTheme.itemTitle(game),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: ItemListBuilder(
                    itemCount: widgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widgets.elementAt(index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    };
  }

  ListTile buildGameSessionTime(
    BuildContext context,
    GamePlayedReviewDTO game,
    Duration totalTime,
  ) {
    return ListTile(
      leading: const Icon(GameTheme.sessionIcon),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.sessionsPlayedString(
              game.totalSessions,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.playTimeString(
              AppLocalizationsUtils.formatDuration(
                context,
                game.totalTime!,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.percentagePlayTimeString(
          formatPercentageForCard(
              game.totalTime!.inMinutes / totalTime.inMinutes),
        ),
      ),
    );
  }

  ListTile buildGameLongestSession(
    BuildContext context,
    GamePlayedReviewDTO game,
  ) {
    return ListTile(
      leading: const Icon(GameTheme.longestSessionIcon),
      title: Text(
        AppLocalizations.of(context)!.playTimeLongestSessionString(
          AppLocalizationsUtils.formatDuration(
            context,
            game.longestSession.time,
          ),
        ),
      ),
      subtitle: Text(
        '${AppLocalizationsUtils.formatDate(game.longestSession.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(game.longestSession.startDatetime), alwaysUse24HourFormat: true)} ⮕ ${AppLocalizationsUtils.formatDate(game.longestSession.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(game.longestSession.endDatetime), alwaysUse24HourFormat: true)}',
      ),
    );
  }

  ListTile buildGameLongestStreak(
    BuildContext context,
    GamePlayedReviewDTO game,
  ) {
    return ListTile(
      leading: const Icon(GameTheme.longestStreakIcon),
      title: Text(
        AppLocalizations.of(context)!.daysLongestStreakString(
          game.longestStreak.days,
        ),
      ),
      subtitle: Text(
        '${AppLocalizationsUtils.formatDate(game.longestStreak.startDate)} ⮕ ${AppLocalizationsUtils.formatDate(game.longestStreak.endDate)}',
      ),
    );
  }

  // TODO go to game detail somewhere
  void Function()? onGameDetailTap(BuildContext context, GameDTO game) {
    return () async {
      Navigator.pushNamed(
        context,
        gameDetailRoute,
        arguments: DetailArguments<GameDTO>(
          item: game,
          onChange: () {
            BlocProvider.of<ReviewBloc>(context).add(ReloadReview());
          },
        ),
      );
    };
  }
}
