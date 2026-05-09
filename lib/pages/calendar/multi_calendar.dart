import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CalendarDayFocusBloc,
        CalendarDaySelectBloc,
        GameSessionSelectBloc,
        ListSearchChanged,
        SessionListBloc;
import 'package:game_oclock/components/calendar_list_detail.dart';
import 'package:game_oclock/shared/list_item/game_session_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

class MultiCalendarPage extends StatelessWidget {
  const MultiCalendarPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CalendarDaySelectBloc()..add(ActionStarted(data: DateTime.now())),
        ),
        BlocProvider(
          create: (_) =>
              CalendarDayFocusBloc()..add(ActionStarted(data: DateTime.now())),
        ),
        BlocProvider(create: (_) => GameSessionSelectBloc()),
        BlocProvider(
          create: (_) =>
              SessionListBloc(service: RepositoryProvider.of(context))
                ..add(ListSearchChanged(search: ListSearchDTO())),
        ),
      ],
      child:
          CalendarListDetailBuilder<
            SessionDTO,
            GameSessionSelectBloc,
            SessionListBloc
          >(
            title: context.localize().calendarTitle,
            firstDay: DateTime(1970),
            lastDay: DateTime.now(),
            dateGetter: (final data) => data.startDatetime,
            detailBuilder: (final context, final data, final onClosed) =>
                Center(child: Text(data.startDatetime.toIso8601String())),
            listItemBuilder: (final context, final data, final onTap) =>
                GameSessionTileListItem(data: data, onTap: onTap),
          ),
    );
  }
}
