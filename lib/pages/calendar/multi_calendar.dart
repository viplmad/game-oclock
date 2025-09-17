import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CalendarDayFocusBloc,
        CalendarDaySelectBloc,
        GameLogListBloc,
        GameLogSelectBloc,
        ListLoaded;
import 'package:game_oclock/components/calendar_list_detail.dart';
import 'package:game_oclock/components/list/list_item.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;
import 'package:game_oclock/utils/localisation_extension.dart';

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
        BlocProvider(create: (_) => GameLogSelectBloc()),
        BlocProvider(
          create: (_) => GameLogListBloc()
            ..add(
              ListLoaded(
                search: ListSearch(name: 'default', search: SearchDTO()),
              ),
            ),
        ),
      ],
      child:
          CalendarListDetailBuilder<
            DateTime,
            GameLogSelectBloc,
            GameLogListBloc
          >(
            title: context.localize().calendarTitle,
            firstDay: DateTime(1970),
            lastDay: DateTime.now(),
            dateGetter: (final data) => data,
            detailBuilder: (final context, final data, final onClosed) =>
                Center(child: Text(data.toIso8601String())),
            listItemBuilder: (final context, final data, final onTap) =>
                TileListItem(title: data.toIso8601String(), onTap: onTap),
          ),
    );
  }
}
