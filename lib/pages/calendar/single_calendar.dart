import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CalendarDayFocusBloc,
        CalendarDaySelectBloc,
        CalendarGameYearDatesBloc,
        GameSessionListBloc,
        GameSessionSelectBloc,
        LastGameSessionGetBloc,
        ListReloaded;
import 'package:game_oclock/components/calendar_list_detail.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/shared/forms/game_session_form.dart';
import 'package:game_oclock/shared/list_item/game_session_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

class SingleCalendarPage extends StatelessWidget {
  const SingleCalendarPage({super.key, required this.gameId});

  final String gameId;

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarDaySelectBloc()),
        BlocProvider(create: (_) => CalendarDayFocusBloc()),
        BlocProvider(create: (_) => GameSessionSelectBloc()),
        BlocProvider(
          create: (_) => LastGameSessionGetBloc(
            service: RepositoryProvider.of(context),
            gameId: gameId,
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => GameSessionListBloc(
            service: RepositoryProvider.of(context),
            gameId: gameId,
          ),
        ),
        BlocProvider(
          create: (_) => CalendarGameYearDatesBloc(
            service: RepositoryProvider.of(context),
            gameId: gameId,
          ),
        ),
      ],
      child:
          CalendarListDetailBuilder<
            SessionDTO,
            GameSessionSelectBloc,
            GameSessionListBloc,
            CalendarGameYearDatesBloc,
            LastGameSessionGetBloc
          >(
            title: context.localize().calendarTitle,
            firstDay: DateTime(1970),
            lastDay: DateTime.now(),
            dateGetter: (final data) => data.endDatetime,
            floatingActionButton: FloatingActionButton(
              tooltip: context.localize().addSessionLabel,
              onPressed: () => showReturningDialog(
                context,
                builder: (final context) =>
                    GameSessionCreateForm(gameId: gameId),
                onSuccess: (final context, _) => context
                    .read<GameSessionListBloc>()
                    .add(const ListReloaded()),
              ),
              child: CommonIcons.addSession,
            ),
            detailBuilder: (final context, final data, final onClosed) =>
                Center(child: Text(data.startDatetime.toIso8601String())),
            listItemBuilder:
                (final context, final data, final selectedDay, final onTap) =>
                    SessionTileListItem(
                      data: data,
                      selectedDay: selectedDay,
                      onTap: onTap,
                    ),
          ),
    );
  }
}
