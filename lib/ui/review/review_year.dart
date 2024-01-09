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
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/statistics_histogram.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';
import '../detail/detail_arguments.dart';
import '../theme/theme.dart' show AppTheme, GameTheme;

const int topMax = 5;

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
                // TODO when tap see played games
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(GameTheme.sessionIcon),
                        title: Text(
                          AppLocalizations.of(context)!
                              .totalGamesPlayedString(playedData.totalPlayed),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.totalFirstPlayedString(
                            playedData.totalFirstPlayed,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!
                                .sessionsPlayedString(playedData.totalSessions),
                          ),
                          Text(
                            AppLocalizations.of(context)!.playTimeString(
                              AppLocalizationsUtils.formatDuration(
                                context,
                                playedData.totalTime,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .percentagePlayedStartedThisYear(
                              AppLocalizationsUtils.formatPercentage(
                                playedData.totalFirstPlayed /
                                    playedData.totalPlayed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              if (shouldShowFinishedInfo) {
                widgets.add(
                  // TODO when tap see finished games
                  Card(
                    margin: const EdgeInsets.all(0.0),
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
                                .totalFirstFinishedString(
                              finishedData.totalFirstFinished,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!
                                  .percentagePlayedFinishedString(
                                AppLocalizationsUtils.formatPercentage(
                                  finishedData.totalFinished /
                                      playedData.totalPlayed,
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .percentageFinishedFirstFinishedThisYearString(
                                AppLocalizationsUtils.formatPercentage(
                                  finishedData.totalFirstFinished /
                                      finishedData.totalFinished,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              widgets.add(
                Card(
                  margin: const EdgeInsets.all(0.0),
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
                        subtitle: Text(
                          AppLocalizations.of(context)!.playingGameString(
                            GameTheme.itemTitle(
                              games.firstWhere(
                                (GamePlayedReviewDTO g) =>
                                    g.id == playedData.longestSession.gameId,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${AppLocalizationsUtils.formatDate(playedData.longestSession.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(playedData.longestSession.startDatetime), alwaysUse24HourFormat: true)} ⮕ ${AppLocalizationsUtils.formatDate(playedData.longestSession.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(playedData.longestSession.endDatetime), alwaysUse24HourFormat: true)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              widgets.add(
                // TODO when tap see games involved
                Card(
                  margin: const EdgeInsets.all(0.0),
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
                        subtitle: Text(
                          AppLocalizations.of(context)!
                              .playingDifferentGameString(
                            playedData.longestStreak.gamesIds.length,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${AppLocalizationsUtils.formatDate(playedData.longestStreak.startDate)} ⮕ ${AppLocalizationsUtils.formatDate(playedData.longestStreak.endDate)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              widgets.addAll(
                games.take(topMax).map((GamePlayedReviewDTO game) {
                  GameFinishedReviewDTO? finishedGame;
                  try {
                    finishedGame = finishedData.games.firstWhere(
                        (GameFinishedReviewDTO g) => g.id == game.id);
                  } on StateError catch (_) {}

                  return GameTheme.itemCardWithAdditionalWidgets(
                    context,
                    game,
                    <Widget>[
                      // TODO convert to ListTile
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!
                                .percentagePlayTimeString(
                              AppLocalizationsUtils.formatPercentage(
                                game.totalTime!.inMinutes /
                                    playedData.totalTime.inMinutes,
                              ),
                            ),
                          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!
                                .playTimeLongestSessionString(
                              AppLocalizationsUtils.formatDuration(
                                context,
                                game.longestSession.time,
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .daysLongestStreakString(
                              game.longestStreak.days,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          game.firstPlayed
                              ? Text(
                                  AppLocalizations.of(context)!
                                      .startedThisYearString,
                                )
                              : const SizedBox(),
                          finishedGame != null && finishedGame.firstFinished
                              ? Text(
                                  AppLocalizations.of(context)!
                                      .firstFinishedThisYearString,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                    (BuildContext context, _) => onGameTap(
                      context,
                      gamesColour[game.id]!,
                      game,
                      finishedGame,
                    ),
                  );
                }),
              );
              widgets.add(
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: buildTotalPlayedByReleaseYearPieChart(
                    context,
                    playedData.totalPlayedByReleaseYear,
                    playedData.totalPlayed,
                    state.year,
                    7,
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
                      7,
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
                          // TODO separators / section headers
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

  void Function()? onGameTap(
    BuildContext context,
    Color gameColour,
    GamePlayedReviewDTO game,
    GameFinishedReviewDTO? finishedGame,
  ) {
    return () async {
      showModalBottomSheet<void>(
        showDragHandle: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          final List<Widget> widgets = <Widget>[
            ListTile(
              leading: Icon(game.firstPlayed
                  ? GameTheme.firstPlayedIcon
                  : GameTheme.notFirstPlayedIcon),
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
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
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(GameTheme.longestStreakIcon),
                  title: Text(
                    AppLocalizations.of(context)!.daysLongestStreakString(
                      game.longestStreak.days,
                    ),
                  ),
                  subtitle: Text(
                    '${AppLocalizationsUtils.formatDate(game.longestStreak.startDate)} ⮕ ${AppLocalizationsUtils.formatDate(game.longestStreak.endDate)}',
                  ),
                ),
              ],
            ),
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
                      // TODO separators / section headers
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
