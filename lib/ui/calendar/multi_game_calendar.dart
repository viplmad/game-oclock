import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_oclock_client/api.dart' show GameWithLogsDTO, GameDTO;

import 'package:logic/model/model.dart' show CalendarRange;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/calendar/multi_calendar.dart';
import 'package:logic/bloc/calendar_manager/calendar_manager.dart';
import 'package:logic/utils/duration_extension.dart';

import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/skeleton.dart';
import 'package:game_oclock/ui/utils/app_localizations_utils.dart';

import '../route_constants.dart';
import '../theme/theme.dart' show AppTheme, GameTheme, CalendarTheme;
import '../detail/detail_arguments.dart';
import 'calendar_utils.dart';

class MultiGameCalendar extends StatelessWidget {
  const MultiGameCalendar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CalendarManagerBloc managerBloc = CalendarManagerBloc();

    final MultiCalendarBloc bloc = MultiCalendarBloc(
      collectionService: RepositoryProvider.of<GameOClockService>(context),
      managerBloc: managerBloc,
    );

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<MultiCalendarBloc>(
          create: (BuildContext context) {
            return bloc..add(LoadMultiCalendar(DateTime.now().year));
          },
        ),
        BlocProvider<CalendarManagerBloc>(
          create: (BuildContext context) {
            return managerBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.calendarViewString,
          ),
          // Fixed elevation so background colour doesn't change on scroll
          elevation: 1.0,
          scrolledUnderElevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(CalendarTheme.firstIcon),
              tooltip: AppLocalizations.of(context)!.firstLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateFirst());
              },
            ),
            IconButton(
              icon: const Icon(CalendarTheme.previousIcon),
              tooltip: AppLocalizations.of(context)!.previousLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDatePrevious());
              },
            ),
            IconButton(
              icon: const Icon(CalendarTheme.nextIcon),
              tooltip: AppLocalizations.of(context)!.nextLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateNext());
              },
            ),
            IconButton(
              icon: const Icon(CalendarTheme.lastIcon),
              tooltip: AppLocalizations.of(context)!.lastLabel,
              onPressed: () {
                bloc.add(UpdateSelectedDateLast());
              },
            ),
            PopupMenuButton<CalendarRange>(
              icon: const Icon(AppTheme.changeRangeIcon),
              tooltip: AppLocalizations.of(context)!.changeRangeString,
              itemBuilder: (BuildContext context) {
                return CalendarRange.values
                    .map<PopupMenuItem<CalendarRange>>((CalendarRange range) {
                  return PopupMenuItem<CalendarRange>(
                    value: range,
                    child: ListTile(
                      title: Text(
                        CalendarUtils.rangeString(context, range),
                      ),
                    ),
                  );
                }).toList(growable: false);
              },
              onSelected: (CalendarRange range) {
                bloc.add(UpdateCalendarRange(range));
              },
            ),
            IconButton(
              icon: const Icon(CalendarTheme.changeStyleIcon),
              tooltip: AppLocalizations.of(context)!.changeStyleString,
              onPressed: () {
                bloc.add(UpdateCalendarStyle());
              },
            ),
          ],
        ),
        body: bodyBuilder(),
      ),
    );
  }

  // ignore: library_private_types_in_public_api
  _MultiGameCalendarBody bodyBuilder() {
    return const _MultiGameCalendarBody();
  }
}

class _MultiGameCalendarBody extends StatelessWidget {
  const _MultiGameCalendarBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarManagerBloc, CalendarManagerState>(
      listener: (BuildContext context, CalendarManagerState state) {
        if (state is CalendarNotLoaded) {
          final String message =
              AppLocalizations.of(context)!.unableToLoadCalendarString;
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
          BlocProvider.of<MultiCalendarBloc>(context)
              .add(ReloadMultiCalendar());
        },
        child: BlocBuilder<MultiCalendarBloc, CalendarState>(
          builder: (BuildContext context, CalendarState state) {
            if (state is MultiCalendarLoaded) {
              Widget gameLogsWidget;
              if (state.selectedTotalTime.isZero()) {
                gameLogsWidget = ListEmpty(
                  emptyTitle: AppLocalizations.of(context)!.emptyPlayTimeString,
                );
              } else {
                if (state is MultiCalendarGraphLoaded) {
                  gameLogsWidget = CalendarUtils.buildGameLogsGraph(
                    context,
                    state.selectedGameLogs,
                    state.range,
                  );
                } else {
                  gameLogsWidget =
                      _buildGameLogsList(context, state.selectedGamesWithLogs);
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildTableCalendar(
                    context,
                    state.logDates,
                    state.focusedDate,
                    state.selectedDate,
                  ),
                  const ListDivider(),
                  ListTile(
                    title: Text(
                      CalendarUtils.titleString(
                        context,
                        state.selectedDate,
                        state.range,
                      ),
                    ),
                    trailing: !state.selectedTotalTime.isZero()
                        ? Text(
                            '${AppLocalizations.of(context)!.totalGamesString(state.selectedTotalGames)} / ${AppLocalizationsUtils.formatDuration(context, state.selectedTotalTime)}',
                          )
                        : null,
                  ),
                  Expanded(child: gameLogsWidget),
                ],
              );
            }
            if (state is CalendarError) {
              return ItemError(
                title: AppLocalizations.of(context)!.somethingWentWrongString,
                onRetryTap: () => BlocProvider.of<MultiCalendarBloc>(context)
                    .add(ReloadMultiCalendar()),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const LinearProgressIndicator(),
                Skeleton(
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
                const ListDivider(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableCalendar(
    BuildContext context,
    Set<DateTime> logDates,
    DateTime focusedDate,
    DateTime selectedDate,
  ) {
    return CalendarUtils.buildTableCalendar(
      context,
      firstDay: DateTime(1970),
      lastDay: DateTime.now(),
      focusedDay: focusedDate,
      selectedDay: selectedDate,
      logDays: logDates,
      onDaySelected: (DateTime newSelectedDay) {
        BlocProvider.of<MultiCalendarBloc>(context).add(
          UpdateSelectedDate(
            newSelectedDay,
          ),
        );
      },
      onPageChanged: (DateTime date) {
        BlocProvider.of<MultiCalendarBloc>(context).add(
          LoadMultiCalendar(
            date.year,
          ),
        );
      },
    );
  }

  Widget _buildGameLogsList(
    BuildContext context,
    List<GameWithLogsDTO> gamesWithLogs,
  ) {
    return ItemListBuilder(
      itemCount: gamesWithLogs.length,
      itemBuilder: (BuildContext context, int index) {
        final GameWithLogsDTO gameWithLogs = gamesWithLogs.elementAt(index);

        return GameTheme.itemCardWithTime(
          context,
          gameWithLogs,
          gameWithLogs.totalTime ?? const Duration(),
          onTap,
        );
      },
    );
  }

  void Function()? onTap(BuildContext context, GameDTO item) {
    return () async {
      Navigator.pushNamed(
        context,
        gameDetailRoute,
        arguments: DetailArguments<GameDTO>(
          item: item,
          // No action on change
        ),
      );
    };
  }
}
