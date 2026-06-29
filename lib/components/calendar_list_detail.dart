import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        CalendarDayFocusBloc,
        CalendarDaySelectBloc,
        FunctionActionBloc,
        IdentityActionBloc,
        ListLoadBloc,
        ListReloaded,
        ListSearchChanged,
        ProducerActionBloc;
import 'package:game_oclock/components/calendar.dart';
import 'package:game_oclock/components/full_search_app_bar.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock_client/api.dart';

class CalendarListDetailBuilder<
  T extends Object,
  L extends Object,
  SB extends IdentityActionBloc<T?>,
  LB extends ListLoadBloc<T>,
  CB extends FunctionActionBloc<DateTime, Set<DateTime>>,
  LSB extends ProducerActionBloc<L?>
>
    extends StatelessWidget {
  const CalendarListDetailBuilder({
    super.key,
    required this.title,
    required this.firstDay,
    required this.lastDay,
    required this.endDateGetter,
    this.floatingActionButton,
    required this.detailBuilder,
    required this.listItemBuilder,
  });

  final String title;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime Function(L data) endDateGetter;
  final FloatingActionButton? floatingActionButton;

  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(
    BuildContext context,
    T data,
    DateTime selectedDay,
    VoidCallback onTap,
  )
  listItemBuilder;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<LSB, ActionState<L?>>(
          listener: (final context, final lastState) {
            if (lastState is ActionFinal<L?, void>) {
              final last = (lastState is ActionSuccess<L?, void>)
                  ? lastState.data
                  : null;
              final lastDate = last == null
                  ? DateTime.now()
                  : endDateGetter(last);

              context.read<CalendarDaySelectBloc>().add(
                ActionStarted(data: lastDate),
              );
              context.read<CalendarDayFocusBloc>().add(
                ActionStarted(data: lastDate),
              );
            }
          },
        ),
        BlocListener<CalendarDaySelectBloc, ActionState<DateTime>>(
          listener: (final context, final selectDayState) {
            if (selectDayState is ActionSuccess<DateTime, DateTime>) {
              final DateTime selectedDay = selectDayState.data;

              context.read<LB>().add(
                ListSearchChanged(
                  search: ListSearchDTO(
                    filter: List.unmodifiable(<FilterDTO>[
                      FilterDTO(
                        field: 'start_date',
                        operator_: OperatorType.lt,
                        value: SearchValue(
                          value: selectedDay.addDays(1).toIso8601WithTzString(),
                        ),
                        chainOperator: ChainOperatorType.and,
                      ),
                      FilterDTO(
                        field: 'end_date',
                        operator_: OperatorType.gte,
                        value: SearchValue(
                          value: selectedDay.toIso8601WithTzString(),
                        ),
                        chainOperator: ChainOperatorType.and,
                      ),
                    ]),
                    sort: List.unmodifiable([
                      SortDTO(field: 'start_date', order: OrderType.asc),
                    ]),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<CalendarDayFocusBloc, ActionState<DateTime>>(
          listener: (final context, final focusDayState) {
            if (focusDayState is ActionSuccess<DateTime, DateTime>) {
              final DateTime focusedDay = focusDayState.data;

              context.read<CB>().add(ActionStarted<DateTime>(data: focusedDay));
            }
          },
        ),
      ],
      child: BlocBuilder<CalendarDaySelectBloc, ActionState<DateTime>>(
        builder: (final context, final selectDayState) {
          final DateTime selectedDay =
              (selectDayState is ActionSuccess<DateTime, DateTime>)
              ? selectDayState.data
              : DateTime.now();

          return BlocBuilder<CalendarDayFocusBloc, ActionState<DateTime>>(
            builder: (final context, final focusDayState) {
              final DateTime focusedDay =
                  (focusDayState is ActionSuccess<DateTime, DateTime>)
                  ? focusDayState.data
                  : DateTime.now();

              return BlocBuilder<SB, ActionState<T?>>(
                builder: (final context, final selectState) {
                  final selectedData = (selectState is ActionSuccess<T?, T?>)
                      ? selectState.data
                      : null;

                  if (layoutTier == LayoutTier.compact) {
                    if (selectedData == null) {
                      return NestedScrollView(
                        headerSliverBuilder: _appBarBuilder,
                        body: Column(
                          children: [
                            ExpansionTile(
                              title: _calendarHeader(
                                context,
                                focusedDay: focusedDay,
                              ),
                              children: [
                                _calendar(
                                  context,
                                  selectedDay: selectedDay,
                                  focusedDay: focusedDay,
                                ),
                              ],
                            ),
                            Expanded(
                              child: _list(
                                context,
                                selectedDay: selectedDay,
                                selectedData: selectedData,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return _detail(
                        context,
                        selectedData: selectedData,
                        selectBloc: context.read<SB>(),
                      );
                    }
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: NestedScrollView(
                            headerSliverBuilder: _appBarBuilder,
                            body: Column(
                              children: [
                                _calendarHeader(
                                  context,
                                  focusedDay: focusedDay,
                                ),
                                _calendar(
                                  context,
                                  selectedDay: selectedDay,
                                  focusedDay: focusedDay,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1.0),
                        Expanded(
                          flex: selectedData == null ? 4 : 2,
                          child: _list(
                            context,
                            selectedDay: selectedDay,
                            selectedData: selectedData,
                          ),
                        ),
                        if (selectedData != null)
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
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _appBarBuilder(
    final BuildContext context,
    final bool innerBoxIsScrolled,
  ) {
    return <Widget>[
      SimpleSliverAppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: CommonIcons.yearPicker,
            tooltip: context.localize().changeYearLabel,
            onPressed: () async {
              final state = context.read<CalendarDayFocusBloc>().state;
              final DateTime focusedDay =
                  (state is ActionSuccess<DateTime, DateTime>)
                  ? state.data
                  : DateTime.now();

              return await showYearPicker(
                context,
                year: focusedDay.year,
                onSuccess: (final context, final data) {
                  context.read<CalendarDayFocusBloc>().add(
                    ActionStarted(
                      data: DateTime(data, focusedDay.month, focusedDay.day),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: CommonIcons.reload,
            tooltip: context.localize().reloadLabel,
            onPressed: () => context.read<CB>().add(const ActionRestarted()),
          ),
        ],
      ),
    ];
  }

  List<Widget> _appBarListBuilder(
    final BuildContext context,
    final bool innerBoxIsScrolled,
    final DateTime selectedDay,
  ) {
    return <Widget>[
      SimpleSliverAppBar(
        pinned: true,
        title: Text(
          MaterialLocalizations.of(context).formatCompactDate(selectedDay),
        ),
        actions: [
          IconButton(
            icon: CommonIcons.reload,
            tooltip: context.localize().reloadLabel,
            onPressed: () => context.read<LB>().add(const ListReloaded()),
          ),
        ],
      ),
    ];
  }

  Widget _calendarHeader(
    final BuildContext context, {
    required final DateTime focusedDay,
  }) {
    return LogCalendarHeader(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      onPageChanged: (final value) => onCalendarPageChanged(context, value),
    );
  }

  Widget _calendar(
    final BuildContext context, {
    required final DateTime selectedDay,
    required final DateTime focusedDay,
  }) {
    return BlocBuilder<CB, ActionState<Set<DateTime>>>(
      builder: (final context, final state) {
        final logs = (state is ActionSuccess<Set<DateTime>, DateTime>)
            ? state.data
            : <DateTime>{}; // TODO build based on state

        return LogCalendar(
          logDays: logs,
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: focusedDay,
          selectedDay: selectedDay,
          onDaySelected: (final value) => context
              .read<CalendarDaySelectBloc>()
              .add(ActionStarted(data: value)),
          onPageChanged: (final value) => onCalendarPageChanged(context, value),
        );
      },
    );
  }

  void onCalendarPageChanged(final BuildContext context, final DateTime date) {
    context.read<CalendarDayFocusBloc>().add(ActionStarted(data: date));
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
    required final DateTime selectedDay,
    required final T? selectedData,
  }) {
    return NestedScrollView(
      headerSliverBuilder: (final context, final innerBoxIsScrolled) =>
          _appBarListBuilder(context, innerBoxIsScrolled, selectedDay),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            children: [
              Expanded(
                child: TileListBuilder<T, LB>(
                  borderRadius: BorderRadius.zero,
                  itemBuilder: (final context, final data, final index) =>
                      listItemBuilder(
                        context,
                        data,
                        selectedDay,
                        () => _selectOrUnselectIfSame(
                          context,
                          selectBloc: context.read<SB>(),
                          data: data,
                          selectedData: selectedData,
                        ),
                      ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: floatingActionButton,
          ),
        ],
      ),
    );
  }

  void _selectOrUnselectIfSame(
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
    required final T? selectedData,
  }) {
    _select(
      context,
      selectBloc: context.read<SB>(),
      data: data == selectedData
          ? null // Remove selection if pressed on the same one
          : data,
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
