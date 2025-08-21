import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionStarted,
        ActionState,
        CalendarDaySelectBloc,
        FunctionActionBloc,
        LayoutTierBloc,
        LayoutTierState,
        ListLoadBloc;
import 'package:game_oclock/components/calendar.dart';
import 'package:game_oclock/components/list/sticky_list.dart'
    show ListTileSliverHeader, StickyListBuilder;
import 'package:game_oclock/models/models.dart' show LayoutTier;

class CalendarListDetailBuilder<
  T,
  SB extends FunctionActionBloc<T?, T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const CalendarListDetailBuilder({
    super.key,
    required this.title,
    required this.keyGetter,
    required this.detailBuilder,
    required this.listItemBuilder,
  });

  final String title;

  final String Function(T data) keyGetter;
  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(BuildContext context, T data, VoidCallback onPressed)
  listItemBuilder;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LayoutTierBloc, LayoutTierState>(
      builder: (final context, final layoutState) {
        final layoutTier = layoutState.tier;

        return BlocBuilder<CalendarDaySelectBloc, ActionState<DateTime>>(
          builder: (final context, final selectDayState) {
            final DateTime selectedDay =
                (selectDayState is ActionFinal)
                    ? (selectDayState as ActionFinal<DateTime, DateTime>).data
                    : DateTime.now();

            return BlocBuilder<SB, ActionState<T?>>(
              builder: (final context, final selectState) {
                final selectedData =
                    (selectState is ActionFinal)
                        ? (selectState as ActionFinal<T?, T?>).data
                        : null;

                if (layoutTier == LayoutTier.compact) {
                  if (selectedData == null) {
                    return _list(context, selectedData: selectedData);
                  } else {
                    return _detail(
                      context,
                      selectedData: selectedData,
                      selectBloc: context.read<SB>(),
                    );
                  }
                } else {
                  if (selectedData == null) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _calendar(context, selectedDay: selectedDay),
                        ),
                        Expanded(
                          flex: 4,
                          child: _list(context, selectedData: selectedData),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _calendar(context, selectedDay: selectedDay),
                        ),
                        Expanded(
                          flex: 2,
                          child: _list(context, selectedData: selectedData),
                        ),
                        Expanded(
                          flex: 2,
                          child: _detail(
                            context,
                            selectedData: selectedData,
                            selectBloc: context.read<SB>(),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _calendar(
    final BuildContext context, {
    required final DateTime selectedDay,
  }) {
    return LogCalendar(
      logDays: Set.unmodifiable([]),
      firstDay: DateTime(1970),
      lastDay: DateTime.now(),
      focusedDay: selectedDay,
      selectedDay: selectedDay,
      onDaySelected:
          (final value) => context.read<CalendarDaySelectBloc>().add(
            ActionStarted(data: value),
          ),
    );
  }

  Widget _detail(
    final BuildContext context, {
    required final T selectedData,
    required final SB selectBloc,
  }) {
    return detailBuilder(
      context,
      selectedData,
      () => _select(context, selectBloc: selectBloc, data: null),
    );
  }

  static Map<String, List<T>> groupBy<T>(
    final Iterable<T> items,
    final String Function(T item) keyGetter,
  ) {
    final map = <String, List<T>>{};
    for (final item in items) {
      (map[keyGetter(item)] ??= []).add(item);
    }
    return map;
  }

  Widget _list(final BuildContext context, {required final T? selectedData}) {
    return StickyListBuilder<T, LB>(
      groupTransformer:
          (final items) => groupBy(items, (final item) => keyGetter(item)),
      headerBuilder:
          (final context, final title) => ListTileSliverHeader(title: title),
      itemBuilder:
          (final context, final data, final index) => listItemBuilder(
            context,
            data,
            () => _select(
              context,
              selectBloc: context.read<SB>(),
              data:
                  data == selectedData
                      ? null // Remove selection if pressed on the same one
                      : data,
            ),
          ),
    );
  }

  void _select(
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
  }) {
    selectBloc.add(ActionStarted(data: data));
  }
}
