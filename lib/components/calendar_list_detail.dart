import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionStarted,
        ActionState,
        CalendarDayFocusBloc,
        CalendarDaySelectBloc,
        FunctionActionBloc,
        LayoutTierBloc,
        LayoutTierState,
        ListFinal,
        ListLoadBloc,
        ListState;
import 'package:game_oclock/components/calendar.dart';
import 'package:game_oclock/components/list/sticky_list.dart'
    show StickySideListBuilder;
import 'package:game_oclock/models/models.dart' show LayoutTier;
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock/utils/list_extension.dart';

class CalendarListDetailBuilder<
  T,
  SB extends FunctionActionBloc<T?, T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const CalendarListDetailBuilder({
    super.key,
    required this.title,
    required this.dateGetter,
    required this.detailBuilder,
    required this.listItemBuilder,
  });

  final String title;

  final DateTime Function(T data) dateGetter;
  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(BuildContext context, T data, VoidCallback onPressed)
  listItemBuilder;

  @override
  Widget build(final BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return BlocBuilder<LayoutTierBloc, LayoutTierState>(
      builder: (final context, final layoutState) {
        final layoutTier = layoutState.tier;

        return BlocListener<CalendarDaySelectBloc, ActionState<DateTime>>(
          listener: (final context, final selectDayState) async {
            if (selectDayState is ActionFinal<DateTime, DateTime>) {
              final DateTime selectedDay = selectDayState.data;

              final ListState<T> listState = context.read<LB>().state;
              if (listState is ListFinal<T>) {
                final List<T> data = listState.data;
                final int indexOf = data.indexWhere(
                  (final element) => dateGetter(element).isSameDay(selectedDay),
                );

                if (indexOf >= 0) {
                  await scrollController.animateTo(
                    indexOf * 56.0, // Size of one line ListTile
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInCubic,
                  );
                } // TODO else notify?
              }
            }
          },
          child: BlocBuilder<CalendarDaySelectBloc, ActionState<DateTime>>(
            builder: (final context, final selectDayState) {
              final DateTime selectedDay =
                  (selectDayState is ActionFinal)
                      ? (selectDayState as ActionFinal<DateTime, DateTime>).data
                      : DateTime.now();

              return BlocBuilder<CalendarDayFocusBloc, ActionState<DateTime>>(
                builder: (final context, final focusDayState) {
                  final DateTime focusedDay =
                      (focusDayState is ActionFinal)
                          ? (focusDayState as ActionFinal<DateTime, DateTime>)
                              .data
                          : DateTime.now();

                  return BlocBuilder<SB, ActionState<T?>>(
                    builder: (final context, final selectState) {
                      final selectedData =
                          (selectState is ActionFinal)
                              ? (selectState as ActionFinal<T?, T?>).data
                              : null;

                      if (layoutTier == LayoutTier.compact) {
                        if (selectedData == null) {
                          // TODO hidden calendar
                          return _list(
                            context,
                            selectedData: selectedData,
                            scrollController: scrollController,
                          );
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
                                child: _calendar(
                                  context,
                                  selectedDay: selectedDay,
                                  focusedDay: focusedDay,
                                ),
                              ),
                              const VerticalDivider(width: 1.0),
                              Expanded(
                                flex: 4,
                                child: _list(
                                  context,
                                  selectedData: selectedData,
                                  scrollController: scrollController,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _calendar(
                                  context,
                                  selectedDay: selectedDay,
                                  focusedDay: focusedDay,
                                ),
                              ),
                              const VerticalDivider(width: 1.0),
                              Expanded(
                                flex: 2,
                                child: _list(
                                  context,
                                  selectedData: selectedData,
                                  scrollController: scrollController,
                                ),
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
          ),
        );
      },
    );
  }

  Widget _calendar(
    final BuildContext context, {
    required final DateTime selectedDay,
    required final DateTime focusedDay,
  }) {
    return LogCalendar(
      logDays: Set.unmodifiable([]),
      firstDay: DateTime(1970),
      lastDay: DateTime.now(),
      focusedDay: focusedDay,
      selectedDay: selectedDay,
      onDaySelected:
          (final value) => context.read<CalendarDaySelectBloc>().add(
            ActionStarted(data: value),
          ),
      onPageChanged:
          (final value) => context.read<CalendarDayFocusBloc>().add(
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

  Widget _list(
    final BuildContext context, {
    required final T? selectedData,
    required final ScrollController? scrollController,
  }) {
    return StickySideListBuilder<DateTime, T, LB>(
      controller: scrollController,
      groupTransformer: _groupByDate,
      headerBuilder: (final date) {
        return Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 44.0,
              width: 44.0,
              child: CircleAvatar(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                child: Text(
                  date.day.toString(), // TODO
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
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

  Map<DateTime, List<T>> _groupByDate(final List<T> items) =>
      items.groupBy((final item) => dateGetter(item).normalizeDate());

  void _select(
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
  }) {
    selectBloc.add(ActionStarted(data: data));
  }
}
