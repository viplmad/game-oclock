import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CalendarDaySelectBloc,
        GameLogListBloc,
        GameLogSelectBloc,
        ListLoaded;
import 'package:game_oclock/components/calendar_list_detail.dart';
import 'package:game_oclock/components/list/list_item.dart';
import 'package:game_oclock/models/models.dart' show ListSearch, SearchDTO;

class MultiCalendarPage extends StatelessWidget {
  const MultiCalendarPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  CalendarDaySelectBloc()
                    ..add(ActionStarted(data: DateTime.now())),
        ),
        BlocProvider(create: (_) => GameLogSelectBloc()),
        BlocProvider(
          create:
              (_) =>
                  GameLogListBloc()..add(
                    ListLoaded(
                      search: ListSearch(name: 'default', search: SearchDTO()),
                    ),
                  ),
        ),
      ],
      child: CalendarListDetailBuilder<
        DateTime,
        GameLogSelectBloc,
        GameLogListBloc
      >(
        title: 'Calendar', // TODO i18n
        keyGetter: (final data) => data.day.toString(),
        detailBuilder:
            (final context, final data, final onClosed) =>
                Center(child: Text(data.toIso8601String())),
        listItemBuilder:
            (final context, final data, final onPressed) =>
                TileListItem(title: data.toIso8601String(), onTap: onPressed),
      ),
    );
  }
}
