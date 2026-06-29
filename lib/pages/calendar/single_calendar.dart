import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionInitial,
        ActionStarted,
        CalendarDayFocusBloc,
        CalendarDaySelectBloc,
        CalendarGameYearDatesBloc,
        DeviceGetBloc,
        FunctionActionBloc,
        GameSessionListBloc,
        LastGameSessionGetBloc,
        ListReloaded,
        SessionSelectBloc;
import 'package:game_oclock/components/calendar_list_detail.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/error_detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/skeletons/skeletons.dart';
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
        BlocProvider(
          create: (_) => CalendarGameYearDatesBloc(
            service: RepositoryProvider.of(context),
            gameId: gameId,
          ),
        ),
        BlocProvider(create: (_) => SessionSelectBloc()),
        BlocProvider(
          create: (_) => GameSessionListBloc(
            service: RepositoryProvider.of(context),
            gameId: gameId,
          ),
        ),
        BlocProvider(
          create: (_) => LastGameSessionGetBloc(
            service: RepositoryProvider.of(context),
            gameId: gameId,
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => DeviceGetBloc(
            service: RepositoryProvider.of(context),
            cache: true,
          ),
        ),
      ],
      child:
          CalendarListDetailBuilder<
            SessionDTO,
            SessionDTO,
            SessionSelectBloc,
            GameSessionListBloc,
            CalendarGameYearDatesBloc,
            LastGameSessionGetBloc
          >(
            title: context.localize().calendarTitle,
            firstDay: DateTime(1970),
            lastDay: DateTime.now(),
            endDateGetter: (final data) => data.endDatetime,
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
                SessionDetail(
                  // Recreate on selection change
                  key: Key(data.startDatetime.toIso8601String()),
                  data: data,
                  onBackPressed: onClosed,
                ),
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

class SessionDetail extends StatelessWidget {
  const SessionDetail({
    super.key,
    required this.data,
    required this.onBackPressed,
    this.actions,
  });

  final SessionDTO data;
  final VoidCallback onBackPressed;
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) {
    _loadOnlyInitial<DeviceDTO, DeviceGetBloc>(context, data.deviceId);

    return _info(context);
  }

  Widget _info(final BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: BackButton(onPressed: onBackPressed),
          actions: actions,
        ),
        SingleChildScrollView(
          child: LabelsContainer(
            children: [
              TextLabel(
                label: context.localize().startDateTimeLabel,
                value:
                    '${MaterialLocalizations.of(context).formatCompactDate(data.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.startDatetime))}',
              ),
              TextLabel(
                label: context.localize().endDateTimeLabel,
                value:
                    '${MaterialLocalizations.of(context).formatCompactDate(data.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.endDatetime))}',
              ),
              TextLabel(
                label: context.localize().timeLabel,
                value: context.localize().formatDuration(data.time),
              ),
              if (data.started)
                IconLabel(
                  icon: CommonIcons.first,
                  label: context.localize().startedLabel,
                ),
              if (data.finishedStatus == MediaStatus.completed)
                IconLabel(
                  icon: CommonIcons.finished,
                  label: context.localize().completedLabel,
                ),
              if (data.finishedStatus == MediaStatus.dropped)
                IconLabel(
                  icon: CommonIcons.dropped,
                  label: context.localize().droppedLabel,
                ),
              if (data.deviceId != null)
                GetBuilder<DeviceDTO, DeviceGetBloc>(
                  skeletonBuilder: (_) => const LabelSkeleton(order: 0),
                  errorBuilder: (final context, final onRetryTap) => Center(
                    child: LabelError(
                      label: context.localize().errorDetailLoadTitle,
                      onRetryTap: onRetryTap,
                    ),
                  ),
                  builder: (final context, final device) => TextLabel(
                    label: context.localize().deviceLabel,
                    value: device.name,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _loadOnlyInitial<T, GB extends FunctionActionBloc<String, T>>(
    final BuildContext context,
    final String? id,
  ) {
    if (id == null) {
      return;
    }

    final gb = context.read<GB>();
    if (gb.state is ActionInitial) {
      gb.add(ActionStarted(data: id));
    }
  }
}
