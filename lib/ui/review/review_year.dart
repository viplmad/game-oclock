import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection_client/api.dart'
    show GameDTO, GamesWithLogsExtendedDTO, GameWithLogsExtendedDTO;

import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/review/review.dart';
import 'package:logic/bloc/review_manager/review_manager.dart';

import 'package:game_oclock/ui/common/year_picker_dialog.dart';
import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';
import '../detail/detail_arguments.dart';
import '../theme/theme.dart' show GameTheme;

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
          // Fixed elevation so background color doesn't change on scroll
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
                  icon: const Icon(Icons.date_range),
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
              final GamesWithLogsExtendedDTO data = state.data;
              final List<GameWithLogsExtendedDTO> games = data.gamesWithLogs;
              final List<Widget> widgets =
                  games.map((GameWithLogsExtendedDTO game) {
                final double percentagePlayed =
                    game.totalTime!.inMinutes / data.totalTime.inMinutes;

                return GameTheme.itemCardWithAdditionalWidgets(
                  context,
                  game,
                  <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!
                              .percentagePlayTimeString(
                            AppLocalizationsUtils.formatPercentage(
                              percentagePlayed,
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.sessionsPlayedString(
                            game.totalSessions,
                          ),
                        ),
                      ],
                    ),
                  ],
                  onTap,
                );
              }).toList();
              widgets.insert(
                0,
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: const Icon(Icons.generating_tokens),
                    title: Text(
                      AppLocalizations.of(context)!
                          .totalGamesPlayedString(data.count),
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context)!.totalNewGamesString(-1),
                    ),
                  ),
                ),
              );
              widgets.insert(
                1,
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.generating_tokens),
                        title: Text(
                          AppLocalizations.of(context)!
                              .daysLongestStreakString(data.longestStreak.days),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.totalGamesPlayedString(
                            data.longestStreak.gamesIds.length,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${AppLocalizationsUtils.formatDate(data.longestStreak.startDate)} ⮕ ${AppLocalizationsUtils.formatDate(data.longestStreak.endDate)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
              widgets.insert(
                2,
                Card(
                  margin: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.generating_tokens),
                        title: Text(
                          AppLocalizations.of(context)!
                              .durationLongestSessionString(
                            AppLocalizationsUtils.formatDuration(
                              context,
                              data.longestSession.time,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!
                              .playingGameString(data.longestSession.gameId),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${AppLocalizationsUtils.formatDate(data.longestSession.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.longestSession.startDatetime), alwaysUse24HourFormat: true)} ⮕ ${AppLocalizationsUtils.formatDate(data.longestSession.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.longestSession.endDatetime), alwaysUse24HourFormat: true)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

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
              return Container();
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

  void Function()? onTap(BuildContext context, GameDTO game) {
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
