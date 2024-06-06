import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart'
    show
        GameFinishedReviewDTO,
        GamePlayedReviewDTO,
        GamesFinishedReviewDTO,
        GamesLogDTO,
        GamesPlayedReviewDTO,
        GamesStreakDTO;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/review/review.dart';
import 'package:logic/bloc/review_manager/review_manager.dart';
import 'package:logic/utils/duration_extension.dart';

import 'package:game_oclock/ui/common/year_picker_dialog.dart';
import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/item_view.dart';
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/triangle_banner.dart';
import 'package:game_oclock/ui/common/statistics_histogram.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../theme/theme.dart' show AppTheme, GameTheme;

const int topMax = 5;
const int maxRecentYears = 7;

const List<Icon> topIcons = <Icon>[
  Icon(GameTheme.firstIcon),
  Icon(GameTheme.secondIcon),
  Icon(GameTheme.thirdIcon),
  Icon(GameTheme.fourthIcon),
  Icon(GameTheme.fifthIcon),
];

class ReviewYear extends StatelessWidget {
  const ReviewYear({
    super.key,
    this.year,
  });

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
          title: Text(AppLocalizations.of(context)!.yearInReviewString),
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
  const _ReviewYearBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewManagerBloc, ReviewManagerState>(
      listener: (BuildContext context, ReviewManagerState state) {
        if (state is ReviewNotLoaded) {
          final String message =
              AppLocalizations.of(context)!.unableToLoadReviewString;
          showApiErrorSnackbar(
            context,
            name: message,
            error: state.error,
            errorDescription: state.errorDescription,
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
                      child: ListHeader(
                        text: '${state.year}',
                      ),
                    ),
                    Expanded(
                      child: ListEmpty(
                        emptyTitle:
                            AppLocalizations.of(context)!.emptyPlayTimeString,
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
              final List<int> recentYears = List<int>.generate(
                maxRecentYears,
                (int index) => state.year - index - 1,
              );

              // Get top games
              games.sort(
                (GamePlayedReviewDTO a, GamePlayedReviewDTO b) =>
                    -a.totalTime.compareTo(b.totalTime),
              );
              final Iterable<GamePlayedReviewDTO> topGames = games.take(topMax);

              final Map<String, Color> gamesColour = <String, Color>{
                for (int index = 0; index < games.length; index++)
                  games.elementAt(index).id: GameTheme.chartColors
                      .elementAt(index % GameTheme.chartColors.length),
              };

              final List<Widget> widgets = <Widget>[];
              widgets.add(
                _buildPlayedCard(
                  context,
                  gamesColour,
                  playedData.totalPlayed,
                  playedData.totalFirstPlayed,
                  playedData.totalSessions,
                  games,
                  finishedGames,
                  playedData.totalTime,
                ),
              );
              if (shouldShowFinishedInfo) {
                widgets.add(
                  _buildFinishedCard(
                    context,
                    gamesColour,
                    finishedData.totalFinished,
                    finishedData.totalFirstFinished,
                    playedData.totalPlayed,
                    finishedGames,
                    games,
                    playedData.totalTime,
                  ),
                );
              }
              widgets.add(
                _buildLongestSessionCard(
                  context,
                  gamesColour,
                  playedData.longestSession,
                  games,
                  finishedGames,
                  playedData.totalTime,
                ),
              );
              if (playedData.longestStreak.days > 1) {
                widgets.add(
                  _buildLongestStreakCard(
                    context,
                    gamesColour,
                    playedData.longestStreak,
                    games,
                    finishedGames,
                    playedData.totalTime,
                  ),
                );
              }
              widgets.add(
                const ListDivider(),
              );
              widgets.addAll(
                _buildFirstSessionCard(
                  context,
                  gamesColour,
                  playedData.firstSession,
                  games,
                  finishedGames,
                  playedData.totalTime,
                ),
              );
              widgets.add(
                const MiniDivider(),
              );
              widgets.addAll(
                _buildLastSessionCard(
                  context,
                  gamesColour,
                  playedData.lastSession,
                  games,
                  finishedGames,
                  playedData.totalTime,
                ),
              );
              widgets.add(
                const ListDivider(),
              );
              widgets.addAll(
                _buildTopGames(
                  context,
                  gamesColour,
                  topGames,
                  finishedGames,
                  playedData.totalTime,
                ),
              );
              widgets.add(
                const ListDivider(),
              );
              widgets.add(
                _buildTotalPlayedByReleaseYearChart(
                  context,
                  gamesColour,
                  state.year,
                  recentYears,
                  playedData.totalPlayedByReleaseYear,
                  playedData.totalPlayed,
                  games,
                  finishedGames,
                  playedData.totalTime,
                ),
              );
              if (shouldShowFinishedInfo) {
                widgets.add(
                  _buildTotalFinishedByReleaseYearChart(
                    context,
                    gamesColour,
                    state.year,
                    recentYears,
                    finishedData.totalFinishedByReleaseYear,
                    finishedData.totalFinished,
                    finishedGames,
                    games,
                    playedData.totalTime,
                  ),
                );
              }
              widgets.add(
                _buildTotalTimeByMonthChart(
                  context,
                  gamesColour,
                  playedData.totalTimeByMonth,
                  games,
                  finishedGames,
                  playedData.totalTime,
                ),
              );
              widgets.add(
                _buildTotalTimeByWeekdayChart(
                  context,
                  playedData.totalTimeByWeekday,
                  playedData.totalTime,
                ),
              );
              widgets.add(
                _buildTotalTimeByHourChart(
                  context,
                  playedData.totalTimeByHour,
                  playedData.totalTime,
                ),
              );
              if (playedData.totalRated > 0) {
                widgets.add(
                  _buildTotalRatedByRatingChart(
                    context,
                    gamesColour,
                    playedData.totalRatedByRating,
                    playedData.totalRated,
                    games,
                    finishedGames,
                    playedData.totalTime,
                  ),
                );
              }
              if (shouldShowFinishedInfo) {
                widgets.add(
                  _buildTotalFinishedByMonthChart(
                    context,
                    gamesColour,
                    finishedData.totalFinishedGrouped,
                    finishedData.totalFinished,
                    finishedGames,
                    games,
                    playedData.totalTime,
                  ),
                );
              }

              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                    child: ListHeader(
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
              return ItemError(
                title: AppLocalizations.of(context)!.somethingWentWrongString,
                onRetryTap: () {
                  BlocProvider.of<ReviewBloc>(context).add(ReloadReview());
                },
              );
            }

            return Column(
              children: <Widget>[
                const LinearProgressIndicator(),
                Container(
                  color: Colors.grey,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListHeaderSkeleton(),
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

  List<Widget> _buildFirstSessionCard(
    BuildContext context,
    Map<String, Color> gamesColour,
    GamesLogDTO firstSession,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return _buildSessionCard(
      context,
      gamesColour,
      AppLocalizations.of(context)!
          .firstSessionOfYear(firstSession.startDatetime.year),
      firstSession,
      games,
      finishedGames,
      totalTime,
    );
  }

  List<Widget> _buildLastSessionCard(
    BuildContext context,
    Map<String, Color> gamesColour,
    GamesLogDTO lastSession,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return _buildSessionCard(
      context,
      gamesColour,
      AppLocalizations.of(context)!
          .lastSessionOfYear(lastSession.startDatetime.year),
      lastSession,
      games,
      finishedGames,
      totalTime,
    );
  }

  List<Widget> _buildSessionCard(
    BuildContext context,
    Map<String, Color> gamesColour,
    String title,
    GamesLogDTO session,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    final String gameId = session.gameId;
    final DateTime startDatetime = session.startDatetime;
    final GamePlayedReviewDTO game = _getPlayedGame(games, gameId);
    final GameFinishedReviewDTO? finishedGame =
        _getFinishedGame(finishedGames, gameId);

    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(title),
      ),
      _buildGameCard(
        context,
        gamesColour[game.id]!,
        game,
        finishedGame,
        totalTime,
        <Widget>[],
        subtitle: AppLocalizations.of(context)!.playedOnString(
          AppLocalizationsUtils.formatDayMonth(startDatetime),
        ),
      ),
    ];
  }

  CardWithTap _buildPlayedCard(
    BuildContext context,
    Map<String, Color> gamesColour,
    int totalPlayed,
    int totalFirstPlayed,
    int totalSessions,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return CardWithTap(
      onTap: _onPlayedTap(
        context,
        gamesColour,
        games,
        finishedGames,
        totalTime,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(GameTheme.sessionIcon),
            title: Text(
              AppLocalizations.of(context)!.totalGamesPlayedString(totalPlayed),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.playTimeString(
                    AppLocalizationsUtils.formatDuration(
                      context,
                      totalTime,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.sessionsPlayedString(
                    totalSessions,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(GameTheme.firstPlayedIcon),
            title: Text(
              AppLocalizations.of(context)!.totalFirstPlayedString(
                totalFirstPlayed,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.percentagePlayedStartedThisYear(
                _formatPercentageForCard(
                  totalFirstPlayed / totalPlayed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CardWithTap _buildFinishedCard(
    BuildContext context,
    Map<String, Color> gamesColour,
    int totalFinished,
    int totalFirstFinished,
    int totalPlayed,
    List<GameFinishedReviewDTO> games,
    List<GamePlayedReviewDTO> playedGames,
    Duration totalTime,
  ) {
    return CardWithTap(
      onTap: _onFinishedTap(
        context,
        gamesColour,
        games,
        playedGames,
        totalTime,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(GameTheme.finishedIcon),
            title: Text(
              AppLocalizations.of(context)!.totalGamesFinishedString(
                totalFinished,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.percentagePlayedFinishedString(
                _formatPercentageForCard(
                  totalFinished / totalPlayed,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(GameTheme.firstPlayedIcon),
            title: Text(
              AppLocalizations.of(context)!.totalFirstFinishedString(
                totalFirstFinished,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!
                  .percentageFinishedFirstFinishedThisYearString(
                _formatPercentageForCard(
                  totalFirstFinished / totalFinished,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CardWithTap _buildLongestSessionCard(
    BuildContext context,
    Map<String, Color> gamesColour,
    GamesLogDTO longestSession,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    final GamePlayedReviewDTO longestSessionGame =
        _getPlayedGame(games, longestSession.gameId);
    final GameFinishedReviewDTO? longestSessionFinishedGame =
        _getFinishedGame(finishedGames, longestSessionGame.id);

    return CardWithTap(
      onTap: _onGameTap(
        context,
        gamesColour[longestSessionGame.id]!,
        longestSessionGame,
        longestSessionFinishedGame,
        totalTime,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(GameTheme.longestSessionIcon),
            title: Text(
              AppLocalizations.of(context)!.playTimeLongestSessionString(
                AppLocalizationsUtils.formatDuration(
                  context,
                  longestSession.time,
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
                  '${AppLocalizationsUtils.formatDate(longestSession.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(longestSession.startDatetime), alwaysUse24HourFormat: true)} ⮕ ${AppLocalizationsUtils.formatDate(longestSession.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(longestSession.endDatetime), alwaysUse24HourFormat: true)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CardWithTap _buildLongestStreakCard(
    BuildContext context,
    Map<String, Color> gamesColour,
    GamesStreakDTO longestStreak,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return CardWithTap(
      onTap: _onLongestStreakTap(
        context,
        gamesColour,
        longestStreak.startDate,
        longestStreak.endDate,
        longestStreak.gamesIds
            .map(
              (String streakGameId) => _getPlayedGame(games, streakGameId),
            )
            .toList(growable: false),
        finishedGames,
        totalTime,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(GameTheme.longestStreakIcon),
            title: Text(
              AppLocalizations.of(context)!.daysLongestStreakString(
                longestStreak.days,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.playingDifferentGameString(
                    longestStreak.gamesIds.length,
                  ),
                ),
                Text(
                  '${AppLocalizationsUtils.formatDate(longestStreak.startDate)} ⮕ ${AppLocalizationsUtils.formatDate(longestStreak.endDate)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPlayedByReleaseYearChart(
    BuildContext context,
    Map<String, Color> gamesColour,
    int year,
    List<int> recentYears,
    Map<int, int> totalPlayedByReleaseYear,
    int totalPlayed,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    final int totalCurrentYear = totalPlayedByReleaseYear[year] ?? 0;
    final int totalRecentYears = recentYears
        .map((int recentYear) => totalPlayedByReleaseYear[recentYear] ?? 0)
        .fold(0, (int acc, int val) => acc += val);
    final int totalClassic = totalPlayed - totalCurrentYear - totalRecentYears;

    final List<int> releasedTypeTotals = <int>[
      totalCurrentYear,
      totalRecentYears,
      totalClassic,
    ];

    return _buildChartCard(
      context,
      Icons.new_releases_outlined,
      AppLocalizations.of(context)!.gamesPlayedByReleaseYearString,
      _buildTotalPlayedByReleaseYearPieChart(
        context,
        GameTheme.chartColors.take(3).toList(growable: false),
        releasedTypeTotals,
        totalPlayed,
        (int type) => _onPlayedReleaseYearTypeTap(
          context,
          gamesColour,
          type,
          releasedTypeTotals.elementAt(type),
          totalPlayed,
          year,
          recentYears,
          games,
          finishedGames,
          totalTime,
        ),
      ),
    );
  }

  Widget _buildTotalFinishedByReleaseYearChart(
    BuildContext context,
    Map<String, Color> gamesColour,
    int year,
    List<int> recentYears,
    Map<int, int> totalFinishedByReleaseYear,
    int totalFinished,
    List<GameFinishedReviewDTO> games,
    List<GamePlayedReviewDTO> playedGames,
    Duration totalTime,
  ) {
    final int totalCurrentYear = totalFinishedByReleaseYear[year] ?? 0;
    final int totalRecentYears = recentYears
        .map((int recentYear) => totalFinishedByReleaseYear[recentYear] ?? 0)
        .fold(0, (int acc, int val) => acc += val);
    final int totalClassic =
        totalFinished - totalCurrentYear - totalRecentYears;

    final List<int> releasedTypeTotals = <int>[
      totalCurrentYear,
      totalRecentYears,
      totalClassic,
    ];

    return _buildChartCard(
      context,
      Icons.new_releases_outlined,
      AppLocalizations.of(context)!.gamesFinishedByReleaseYearString,
      _buildTotalFinishedByReleaseYearPieChart(
        context,
        GameTheme.chartColors.take(3).toList(growable: false),
        releasedTypeTotals,
        totalFinished,
        (int type) => _onFinishedReleaseYearTypeTap(
          context,
          gamesColour,
          type,
          releasedTypeTotals.elementAt(type),
          totalFinished,
          year,
          recentYears,
          games,
          playedGames,
          totalTime,
        ),
      ),
    );
  }

  Widget _buildTotalTimeByMonthChart(
    BuildContext context,
    Map<String, Color> gamesColour,
    Map<int, Duration> totalTimeByMonth,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return _buildChartCard(
      context,
      Icons.calendar_month_outlined,
      AppLocalizations.of(context)!.playTimeByMonthString,
      _buildTotalTimeByMonthStackedBarChart(
        context,
        games
            .map(
              (GamePlayedReviewDTO game) => gamesColour[game.id]!,
            )
            .toList(growable: false),
        games
            .map(
              (GamePlayedReviewDTO game) => game.totalTimeByMonth,
            )
            .toList(growable: false),
        totalTime,
        (int month) => _onTotalTimeMonthTap(
          context,
          gamesColour,
          month,
          totalTimeByMonth[month] ?? const Duration(),
          games,
          finishedGames,
          totalTime,
        ),
      ),
    );
  }

  Widget _buildTotalTimeByWeekdayChart(
    BuildContext context,
    Map<int, Duration> totalTimeByWeekday,
    Duration totalTime,
  ) {
    return _buildChartCard(
      context,
      Icons.calendar_month_outlined,
      AppLocalizations.of(context)!.playTimeByWeekdayString,
      _buildTotalTimeByWeekdayLineChart(context, totalTimeByWeekday, totalTime),
    );
  }

  Widget _buildTotalTimeByHourChart(
    BuildContext context,
    Map<int, Duration> totalTimeByHour,
    Duration totalTime,
  ) {
    return _buildChartCard(
      context,
      Icons.calendar_month_outlined,
      AppLocalizations.of(context)!.playTimeByHourString,
      _buildTotalTimeByHourLineChart(context, totalTimeByHour, totalTime),
    );
  }

  Widget _buildTotalRatedByRatingChart(
    BuildContext context,
    Map<String, Color> gamesColour,
    Map<int, int> totalRatedByRating,
    int totalRated,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    return _buildChartCard(
      context,
      GameTheme.ratingIcon,
      AppLocalizations.of(context)!.gamesPlayedByRatingString,
      _buildTotalRatedByRatingBarChart(
        context,
        totalRatedByRating,
        totalRated,
        (int rating) => _onRatedRatingTap(
          context,
          gamesColour,
          rating,
          totalRatedByRating[rating] ?? 0,
          totalRated,
          games,
          finishedGames,
          totalTime,
        ),
      ),
    );
  }

  Widget _buildTotalFinishedByMonthChart(
    BuildContext context,
    Map<String, Color> gamesColour,
    Map<int, int> totalFinishedByMonth,
    int totalFinished,
    List<GameFinishedReviewDTO> games,
    List<GamePlayedReviewDTO> playedGames,
    Duration totalTime,
  ) {
    return _buildChartCard(
      context,
      Icons.calendar_month_outlined,
      AppLocalizations.of(context)!.gamesFinishedByMonthString,
      _buildTotalFinishedByMonthBarChart(
        context,
        totalFinishedByMonth,
        totalFinished,
        (int month) => _onFinishedMonthTap(
          context,
          gamesColour,
          month,
          totalFinishedByMonth[month] ?? 0,
          totalFinished,
          games,
          playedGames,
          totalTime,
        ),
      ),
    );
  }

  Widget _buildChartCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget chartWidget,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: _buildChartWithTitle(context, icon, title, chartWidget),
    );
  }

  Column _buildChartWithTitle(
    BuildContext context,
    IconData icon,
    String title,
    Widget chartWidget,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(icon),
          title: Text(title),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 0.0, // Use blank space to the right
            bottom: 8.0,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            child: chartWidget,
          ),
        ),
      ],
    );
  }

  Widget _buildTopGameCard(
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
      <Widget>[
        _buildGameSessionTime(context, game, totalTime),
        _buildGameLongestSession(context, game),
        _buildGameLongestStreak(context, game),
      ],
    );
  }

  Widget _buildSimpleGameCard(
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
    List<Widget> additionalWidgets, {
    String? subtitle,
  }) {
    return GameTheme.itemCardWithAdditionalWidgets(
      context,
      game,
      additionalWidgets,
      (BuildContext context, _) => _onGameTap(
        context,
        colour,
        game,
        finishedGame,
        totalTime,
      ),
      trailing: SizedBox(
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
      subtitle:
          subtitle ?? (game.releaseYear != null ? '${game.releaseYear}' : ''),
    );
  }

  Widget _buildTotalPlayedByReleaseYearPieChart(
    BuildContext context,
    List<Color> colours,
    List<int> releasedTypeTotals,
    int totalPlayed,
    void Function(int type) onTypeTap,
  ) {
    return StatisticsPieChart<double>(
      id: 'playedByReleaseYear',
      domainLabels: GameTheme.releaseYearTypes(context),
      values: releasedTypeTotals
          .map(
            (int totalReleaseYear) => totalReleaseYear / totalPlayed,
          )
          .toList(growable: false),
      colours: colours,
      valueFormatter: (String domainLabel, _) => domainLabel,
      onTap: onTypeTap,
    );
  }

  Widget _buildTotalFinishedByReleaseYearPieChart(
    BuildContext context,
    List<Color> colours,
    List<int> releasedTypeTotals,
    int totalFinished,
    void Function(int type) onTypeTap,
  ) {
    return StatisticsPieChart<double>(
      id: 'finishedByReleaseYear',
      domainLabels: GameTheme.releaseYearTypes(context),
      values: releasedTypeTotals
          .map(
            (int totalReleaseYear) => totalReleaseYear / totalFinished,
          )
          .toList(growable: false),
      colours: colours,
      valueFormatter: (String domainLabel, _) => domainLabel,
      onTap: onTypeTap,
    );
  }

  Widget _buildTotalTimeByMonthStackedBarChart(
    BuildContext context,
    List<Color> colours,
    List<Map<int, Duration>> gamesTotalTimeByMonth,
    Duration totalTime,
    void Function(int month) onMonthTap,
  ) {
    return StatisticsStackedHistogram<int>(
      id: 'playTimeByMonth',
      domainLabels: AppLocalizationsUtils.monthsAbbr(),
      stackedValues: gamesTotalTimeByMonth
          .map(
            (Map<int, Duration> gameTotalTimeByMonth) =>
                // First normalise entries
                List<int>.generate(
              DateTime.monthsPerYear,
              (int index) {
                final Duration gameMonthTotalTime =
                    gameTotalTimeByMonth[index + 1] ?? const Duration();
                return _preparePercentageForChart(
                  gameMonthTotalTime.inMinutes / totalTime.inMinutes,
                );
              },
            ),
          )
          .toList(growable: false),
      colours: colours,
      hideValueLabels: true,
      measureFormatter: _formatPercentageMeasureForChart,
      onTap: (int domainIndex) => onMonthTap(domainIndex + 1),
    );
  }

  Widget _buildTotalTimeByWeekdayLineChart(
    BuildContext context,
    Map<int, Duration> totalTimeByWeekday,
    Duration totalTime,
  ) {
    return StatisticsLineChart(
      id: 'playTimeByWeekday',
      domainLabels: AppLocalizationsUtils.daysOfWeekAbbr(),
      // First normalise entries
      values: List<int>.generate(DateTime.daysPerWeek, (int index) {
        final Duration weekdayTotalTime =
            totalTimeByWeekday[index + 1] ?? const Duration();
        return _preparePercentageForChart(
          weekdayTotalTime.inMinutes / totalTime.inMinutes,
        );
      }).toList(growable: false),
      hideValueLabels: true,
      measureFormatter: _formatPercentageMeasureForChart,
    );
  }

  Widget _buildTotalTimeByHourLineChart(
    BuildContext context,
    Map<int, Duration> totalTimeByHour,
    Duration totalTime,
  ) {
    return StatisticsLineChart(
      id: 'playTimeByHour',
      domainLabels: const <String>[
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '19',
        '20',
        '21',
        '22',
        '23'
      ],
      // First normalise entries
      values: List<int>.generate(24, (int index) {
        final Duration hourTotalTime =
            totalTimeByHour[index + 1] ?? const Duration();
        return _preparePercentageForChart(
          hourTotalTime.inMinutes / totalTime.inMinutes,
        );
      }).toList(growable: false),
      hideValueLabels: true,
      measureFormatter: _formatPercentageMeasureForChart,
    );
  }

  Widget _buildTotalRatedByRatingBarChart(
    BuildContext context,
    Map<int, int> totalRatedByRating,
    int totalRated,
    void Function(int rating) onRatingTap,
  ) {
    return StatisticsHistogram<int>(
      id: 'ratedByRating',
      domainLabels: List<String>.generate(
        10,
        (int i) => '${i + 1}',
        growable: false,
      ),
      // First normalise entries
      values: List<int>.generate(10, (int index) {
        final int ratingTotalRated = totalRatedByRating[index + 1] ?? 0;
        return ratingTotalRated;
      }).toList(growable: false),
      onDomainTap: (int domainIndex) => onRatingTap(domainIndex + 1),
    );
  }

  Widget _buildTotalFinishedByMonthBarChart(
    BuildContext context,
    Map<int, int> totalFinishedByMonth,
    int totalFinished,
    void Function(int month) onMonthTap,
  ) {
    return StatisticsHistogram<int>(
      id: 'finishedByMonth',
      domainLabels: AppLocalizationsUtils.monthsAbbr(),
      // First normalise entries
      values: List<int>.generate(DateTime.monthsPerYear, (int index) {
        final int monthTotalFinished = totalFinishedByMonth[index + 1] ?? 0;
        return monthTotalFinished;
      }).toList(growable: false),
      onDomainTap: (int domainIndex) => onMonthTap(domainIndex + 1),
    );
  }

  Widget _buildGameTotalTimeByMonthBarChart(
    BuildContext context,
    Color colour,
    Map<int, Duration> gameTotalTimeByMonth,
    Duration totalTime,
  ) {
    return StatisticsHistogram<int>(
      id: 'gamePlayTimeByMonth',
      domainLabels: AppLocalizationsUtils.monthsAbbr(),
      // First normalise entries
      values: List<int>.generate(DateTime.monthsPerYear, (int index) {
        final Duration gameMonthTotalTime =
            gameTotalTimeByMonth[index + 1] ?? const Duration();
        return gameMonthTotalTime.inMinutes;
      }).toList(growable: false),
      colour: colour,
      valueFormatter: (int minutes) =>
          _formatDurationValueForChart(context, minutes),
      measureFormatter: (num? minutes) =>
          _formatDurationMeasureForChart(context, minutes),
    );
  }

  void Function() _onPlayedTap(
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
          // Sort by first play
          games.sort(
            (GamePlayedReviewDTO a, GamePlayedReviewDTO b) => a
                .firstSession.startDatetime
                .compareTo(b.firstSession.startDatetime),
          );

          final SplayTreeMap<int, List<GamePlayedReviewDTO>> monthGamesMap =
              SplayTreeMap<int, List<GamePlayedReviewDTO>>();
          for (final GamePlayedReviewDTO game in games) {
            final int month = game.firstSession.startDatetime.month;
            final List<GamePlayedReviewDTO> monthGames =
                monthGamesMap[month] ?? <GamePlayedReviewDTO>[];
            monthGames.add(game);
            monthGamesMap[month] = monthGames;
          }

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: ListHeader(
                  icon: GameTheme.sessionIcon,
                  text: AppLocalizations.of(context)!.playedString,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: monthGamesMap.entries.map(
                      (MapEntry<int, List<GamePlayedReviewDTO>> monthGames) {
                        final String sectionTitle =
                            AppLocalizationsUtils.months()
                                .elementAt(monthGames.key - 1);

                        return ItemSliverCardSectionBuilder(
                          title: sectionTitle,
                          itemCount: monthGames.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            final GamePlayedReviewDTO game =
                                monthGames.value.elementAt(index);
                            final GameFinishedReviewDTO? finishedGame =
                                _getFinishedGame(finishedGames, game.id);

                            return _buildGameCard(
                              context,
                              gamesColour[game.id]!,
                              game,
                              finishedGame,
                              totalTime,
                              <Widget>[],
                              subtitle: AppLocalizations.of(context)!
                                  .startedOnDayString(
                                AppLocalizationsUtils.formatDay(
                                  game.firstSession.startDatetime,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).toList(growable: false),
                  ),
                ),
              ),
            ],
          );
        },
      );
    };
  }

  void Function() _onFinishedTap(
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
          // Sort by first finish
          games.sort(
            (GameFinishedReviewDTO a, GameFinishedReviewDTO b) =>
                a.firstFinish.compareTo(b.firstFinish),
          );

          final SplayTreeMap<int, List<GameFinishedReviewDTO>> monthGamesMap =
              SplayTreeMap<int, List<GameFinishedReviewDTO>>();
          for (final GameFinishedReviewDTO game in games) {
            final int month = game.firstFinish.month;
            final List<GameFinishedReviewDTO> monthGames =
                monthGamesMap[month] ?? <GameFinishedReviewDTO>[];
            monthGames.add(game);
            monthGamesMap[month] = monthGames;
          }

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: ListHeader(
                  icon: GameTheme.finishedIcon,
                  text: AppLocalizations.of(context)!.finishedString,
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: monthGamesMap.entries.map(
                      (MapEntry<int, List<GameFinishedReviewDTO>> monthGames) {
                        final String sectionTitle =
                            AppLocalizationsUtils.months()
                                .elementAt(monthGames.key - 1);

                        return ItemSliverCardSectionBuilder(
                          title: sectionTitle,
                          itemCount: monthGames.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            final GameFinishedReviewDTO game =
                                monthGames.value.elementAt(index);
                            final GamePlayedReviewDTO playedGame =
                                _getPlayedGame(playedGames, game.id);

                            return _buildGameCard(
                              context,
                              gamesColour[game.id]!,
                              playedGame,
                              game,
                              totalTime,
                              <Widget>[],
                              subtitle: AppLocalizations.of(context)!
                                  .finishedOnDayString(
                                AppLocalizationsUtils.formatDay(
                                  game.firstFinish,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ).toList(growable: false),
                  ),
                ),
              ),
            ],
          );
        },
      );
    };
  }

  void Function() _onLongestStreakTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    DateTime startDate,
    DateTime endDate,
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
          final List<Widget> widgets = <Widget>[];
          widgets.add(
            ListTile(
              title: Text(
                '${AppLocalizationsUtils.formatDate(startDate)} ⮕ ${AppLocalizationsUtils.formatDate(endDate)}',
                textAlign: TextAlign.center,
              ),
            ),
          );
          widgets.addAll(
            games.map((GamePlayedReviewDTO game) {
              final GameFinishedReviewDTO? finishedGame =
                  _getFinishedGame(finishedGames, game.id);

              // TODO show different information for streaks
              return _buildSimpleGameCard(
                context,
                gamesColour[game.id]!,
                game,
                finishedGame,
                totalTime,
              );
            }),
          );

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: ListHeader(
                  icon: GameTheme.longestStreakIcon,
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

  List<Widget> _buildTopGames(
    BuildContext context,
    Map<String, Color> gamesColour,
    Iterable<GamePlayedReviewDTO> topGames,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) {
    final List<Widget> widgets = <Widget>[];
    for (int index = 0; index < topGames.length; index++) {
      final GamePlayedReviewDTO game = topGames.elementAt(index);
      final GameFinishedReviewDTO? finishedGame =
          _getFinishedGame(finishedGames, game.id);

      final Widget topGameCard = _buildTopGameCard(
        context,
        gamesColour[game.id]!,
        game,
        finishedGame,
        totalTime,
      );

      widgets.add(topIcons.elementAt(index));
      widgets.add(topGameCard);

      if (index < topGames.length - 1) {
        widgets.add(const MiniDivider());
      }
    }

    return widgets;
  }

  void _onPlayedReleaseYearTypeTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    int type,
    int typeTotal,
    int totalPlayed,
    int year,
    List<int> recentYears,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) async {
    final List<GamePlayedReviewDTO> releasedTypeGames =
        games.where((GamePlayedReviewDTO game) {
      final int? releaseYear = game.releaseYear;
      // New releases
      if (type == 0) {
        return releaseYear == year;
      }
      // Recent
      if (type == 1) {
        return recentYears.contains(releaseYear);
      }
      // Classic
      if (type == 2) {
        return releaseYear != year && !recentYears.contains(releaseYear);
      }
      return false;
    }).toList(growable: false);
    // Sort by oldest release year
    releasedTypeGames.sort(
      (GamePlayedReviewDTO a, GamePlayedReviewDTO b) =>
          a.releaseYear != null && b.releaseYear != null
              ? a.releaseYear!.compareTo(b.releaseYear!)
              : 0,
    );

    if (releasedTypeGames.isEmpty) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final String typeTitle =
            GameTheme.releaseYearTypes(context).elementAt(type);
        final String typeDescription =
            GameTheme.releaseYearTypeDescriptions(context, maxRecentYears)
                .elementAt(type);
        final String typeLabel = typeDescription.isNotEmpty
            ? '$typeTitle ($typeDescription)'
            : typeTitle;

        final List<Widget> widgets = <Widget>[];
        widgets.add(
          ListTile(
            title: Text(
              '${AppLocalizations.of(context)!.percentagePlayedString(
                _formatPercentageForCard(
                  typeTotal / totalPlayed,
                ),
              )} · ${AppLocalizations.of(context)!.totalPlayedString(
                typeTotal,
              )}',
              textAlign: TextAlign.center,
            ),
          ),
        );
        widgets.addAll(
          releasedTypeGames.map((GamePlayedReviewDTO game) {
            final GameFinishedReviewDTO? finishedGame =
                _getFinishedGame(finishedGames, game.id);

            return _buildSimpleGameCard(
              context,
              gamesColour[game.id]!,
              game,
              finishedGame,
              totalTime,
            );
          }),
        );

        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: ListHeader(
                icon: GameTheme.sessionIcon,
                text: typeLabel,
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
  }

  void _onFinishedReleaseYearTypeTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    int type,
    int typeTotal,
    int totalFinished,
    int year,
    List<int> recentYears,
    List<GameFinishedReviewDTO> games,
    List<GamePlayedReviewDTO> playedGames,
    Duration totalTime,
  ) async {
    final List<GameFinishedReviewDTO> releasedTypeGames =
        games.where((GameFinishedReviewDTO game) {
      final int? releaseYear = game.releaseYear;
      // New releases
      if (type == 0) {
        return releaseYear == year;
      }
      // Recent
      if (type == 1) {
        return recentYears.contains(releaseYear);
      }
      // Classic
      if (type == 2) {
        return releaseYear != year && !recentYears.contains(releaseYear);
      }
      return false;
    }).toList(growable: false);
    // Sort by oldest release year
    releasedTypeGames.sort(
      (GameFinishedReviewDTO a, GameFinishedReviewDTO b) =>
          a.releaseYear != null && b.releaseYear != null
              ? a.releaseYear!.compareTo(b.releaseYear!)
              : 0,
    );

    if (releasedTypeGames.isEmpty) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final String typeTitle =
            GameTheme.releaseYearTypes(context).elementAt(type);
        final String typeDescription =
            GameTheme.releaseYearTypeDescriptions(context, maxRecentYears)
                .elementAt(type);
        final String typeLabel = typeDescription.isNotEmpty
            ? '$typeTitle ($typeDescription)'
            : typeTitle;

        final List<Widget> widgets = <Widget>[];
        widgets.add(
          ListTile(
            title: Text(
              '${AppLocalizations.of(context)!.percentageFinishedString(
                _formatPercentageForCard(
                  typeTotal / totalFinished,
                ),
              )} · ${AppLocalizations.of(context)!.totalFinishedString(
                typeTotal,
              )}',
              textAlign: TextAlign.center,
            ),
          ),
        );
        widgets.addAll(
          releasedTypeGames.map((GameFinishedReviewDTO game) {
            final GamePlayedReviewDTO playedGame =
                _getPlayedGame(playedGames, game.id);

            return _buildSimpleGameCard(
              context,
              gamesColour[game.id]!,
              playedGame,
              game,
              totalTime,
            );
          }),
        );

        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: ListHeader(
                icon: GameTheme.finishedIcon,
                text: typeLabel,
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
  }

  void _onTotalTimeMonthTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    int month,
    Duration monthTotalTime,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) async {
    final List<GamePlayedReviewDTO> playedMonthGames =
        games.where((GamePlayedReviewDTO game) {
      final Duration? monthFinished = game.totalTimeByMonth[month];
      return monthFinished != null && !monthFinished.isZero();
    }).toList(growable: false);
    // Sort by most played
    playedMonthGames.sort(
      (GamePlayedReviewDTO a, GamePlayedReviewDTO b) =>
          -a.totalTimeByMonth[month]!.compareTo(b.totalTimeByMonth[month]!),
    );

    if (playedMonthGames.isEmpty) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final String monthLabel =
            AppLocalizationsUtils.months().elementAt(month - 1);

        final List<Widget> widgets = <Widget>[];
        widgets.add(
          ListTile(
            title: Text(
              '${AppLocalizations.of(context)!.percentagePlayTimeString(
                _formatPercentageForCard(
                  monthTotalTime.inMinutes / totalTime.inMinutes,
                ),
              )} · ${AppLocalizationsUtils.formatDuration(
                context,
                monthTotalTime,
              )}',
              textAlign: TextAlign.center,
            ),
          ),
        );
        widgets.addAll(
          playedMonthGames.map((GamePlayedReviewDTO game) {
            final Duration gameMonthTotalTime = game.totalTimeByMonth[month]!;
            final GameFinishedReviewDTO? finishedGame =
                _getFinishedGame(finishedGames, game.id);
            final Color gameColour = gamesColour[game.id]!;

            return TriangleBanner(
              message: '',
              location: TriangleBannerLocation.start,
              showShadow: false,
              color: gameColour,
              child: _buildGameCard(
                context,
                gameColour,
                game,
                finishedGame,
                totalTime,
                <Widget>[],
                subtitle:
                    '${AppLocalizations.of(context)!.percentageMonthPlayTimeString(
                  _formatPercentageForCard(
                    gameMonthTotalTime.inMinutes / monthTotalTime.inMinutes,
                  ),
                )} · ${AppLocalizationsUtils.formatDuration(
                  context,
                  gameMonthTotalTime,
                )}',
              ),
            );
          }),
        );

        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: ListHeader(
                icon: GameTheme.sessionIcon,
                text: AppLocalizations.of(context)!.playedInString(monthLabel),
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
  }

  void _onRatedRatingTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    int rating,
    int ratingTotalRated,
    int totalRated,
    List<GamePlayedReviewDTO> games,
    List<GameFinishedReviewDTO> finishedGames,
    Duration totalTime,
  ) async {
    final List<GamePlayedReviewDTO> ratingGames = games
        .where((GamePlayedReviewDTO game) => game.rating == rating)
        .toList(growable: false);
    // Sort by oldest release year
    ratingGames.sort(
      (GamePlayedReviewDTO a, GamePlayedReviewDTO b) =>
          a.releaseYear != null && b.releaseYear != null
              ? a.releaseYear!.compareTo(b.releaseYear!)
              : 0,
    );

    if (ratingGames.isEmpty) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final List<Widget> widgets = <Widget>[];
        widgets.add(
          ListTile(
            title: Text(
              '${AppLocalizations.of(context)!.percentageRatedString(
                _formatPercentageForCard(
                  ratingTotalRated / totalRated,
                ),
              )} · ${AppLocalizations.of(context)!.totalRatedString(
                ratingTotalRated,
              )}',
              textAlign: TextAlign.center,
            ),
          ),
        );
        widgets.addAll(
          ratingGames.map((GamePlayedReviewDTO game) {
            final GameFinishedReviewDTO? finishedGame =
                _getFinishedGame(finishedGames, game.id);

            return _buildSimpleGameCard(
              context,
              gamesColour[game.id]!,
              game,
              finishedGame,
              totalTime,
            );
          }),
        );

        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: ListHeader(
                icon: GameTheme.ratingIcon,
                text: AppLocalizations.of(context)!.ratedWithString('$rating'),
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
  }

  void _onFinishedMonthTap(
    BuildContext context,
    Map<String, Color> gamesColour,
    int month,
    int monthTotalFinished,
    int totalFinished,
    List<GameFinishedReviewDTO> games,
    List<GamePlayedReviewDTO> playedGames,
    Duration totalTime,
  ) async {
    final List<GameFinishedReviewDTO> finishedMonthGames =
        games.where((GameFinishedReviewDTO game) {
      final int? monthFinished = game.totalFinishedGrouped[month];
      return monthFinished != null && monthFinished >= 1;
    }).toList(growable: false);
    // Sort by first finish (assumes only one finish per year)
    finishedMonthGames.sort(
      (GameFinishedReviewDTO a, GameFinishedReviewDTO b) =>
          a.firstFinish.compareTo(b.firstFinish),
    );

    if (finishedMonthGames.isEmpty) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        final String monthLabel =
            AppLocalizationsUtils.months().elementAt(month - 1);

        final List<Widget> widgets = <Widget>[];
        widgets.add(
          ListTile(
            title: Text(
              '${AppLocalizations.of(context)!.percentageFinishedString(
                _formatPercentageForCard(
                  monthTotalFinished / totalFinished,
                ),
              )} · ${AppLocalizations.of(context)!.totalFinishedString(
                monthTotalFinished,
              )}',
              textAlign: TextAlign.center,
            ),
          ),
        );
        widgets.addAll(
          finishedMonthGames.map((GameFinishedReviewDTO game) {
            final GamePlayedReviewDTO playedGame =
                _getPlayedGame(playedGames, game.id);

            return _buildGameCard(
              context,
              gamesColour[game.id]!,
              playedGame,
              game,
              totalTime,
              <Widget>[],
              subtitle: AppLocalizationsUtils.formatDate(game.firstFinish),
            );
          }),
        );

        return Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: ListHeader(
                icon: GameTheme.finishedIcon,
                text:
                    AppLocalizations.of(context)!.finishedInString(monthLabel),
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
  }

  void Function() _onGameTap(
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
            _buildGameSessionTime(context, game, totalTime),
            _buildGameLongestSession(context, game),
            _buildGameLongestStreak(context, game),
            const ListDivider(),
            _buildChartWithTitle(
              context,
              Icons.calendar_month_outlined,
              AppLocalizations.of(context)!.playTimeByMonthString,
              _buildGameTotalTimeByMonthBarChart(
                context,
                gameColour,
                game.totalTimeByMonth,
                game.totalTime,
              ),
            ),
          ];

          return Column(
            children: <Widget>[
              Container(
                color: Colors.grey,
                child: ListHeader(
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

  ListTile _buildGameSessionTime(
    BuildContext context,
    GamePlayedReviewDTO game,
    Duration totalTime,
  ) {
    return ListTile(
      leading: const Icon(GameTheme.sessionIcon),
      title: Text(
        AppLocalizations.of(context)!.playTimeString(
          AppLocalizationsUtils.formatDuration(
            context,
            game.totalTime,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.sessionsPlayedString(
              game.totalSessions,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.percentagePlayTimeString(
              _formatPercentageForCard(
                game.totalTime.inMinutes / totalTime.inMinutes,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildGameLongestSession(
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

  ListTile _buildGameLongestStreak(
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

  static int _preparePercentageForChart(double percentage) {
    return (percentage * 100).round();
  }

  static String _formatDurationValueForChart(
    BuildContext context,
    int minutes,
  ) {
    return '${AppLocalizationsUtils.getMinutesAsHours(minutes)}';
  }

  static String _formatPercentageMeasureForChart(num? percentage) {
    return percentage != null ? _formatPercentageForCard(percentage / 100) : '';
  }

  static String _formatDurationMeasureForChart(
    BuildContext context,
    num? minutes,
  ) {
    return minutes != null
        ? AppLocalizationsUtils.formatMinutesAsHours(context, minutes.round())
        : '';
  }

  static String _formatPercentageForCard(double percentage) {
    return percentage >= 0.01
        ? AppLocalizationsUtils.formatPercentage(
            percentage,
          )
        : '<${AppLocalizationsUtils.formatPercentage(
            0.01,
          )}';
  }

  static GameFinishedReviewDTO? _getFinishedGame(
    List<GameFinishedReviewDTO> finishedGames,
    String id,
  ) {
    GameFinishedReviewDTO? finishedGame;
    try {
      finishedGame = finishedGames.firstWhere(
        (GameFinishedReviewDTO g) => g.id == id,
      );
    } on StateError catch (_) {}
    return finishedGame;
  }

  static GamePlayedReviewDTO _getPlayedGame(
    List<GamePlayedReviewDTO> playedGames,
    String id,
  ) {
    return playedGames.firstWhere(
      (GamePlayedReviewDTO g) => g.id == id,
    );
  }
}
