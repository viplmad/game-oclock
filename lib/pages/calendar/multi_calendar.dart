import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionInitial,
        ActionStarted,
        CalendarDayFocusBloc,
        CalendarDaySelectBloc,
        CalendarYearDatesBloc,
        DeviceGetBloc,
        FunctionActionBloc,
        LastSessionGetBloc,
        SessionWithMediaListBloc,
        SessionWithMediaSelectBloc;
import 'package:game_oclock/components/calendar_list_detail.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/error_detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/shared/list_item/game_session_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

class MultiCalendarPage extends StatelessWidget {
  const MultiCalendarPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarDaySelectBloc()),
        BlocProvider(create: (_) => CalendarDayFocusBloc()),
        BlocProvider(
          create: (_) =>
              CalendarYearDatesBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(create: (_) => SessionWithMediaSelectBloc()),
        BlocProvider(
          create: (_) => SessionWithMediaListBloc(
            service: RepositoryProvider.of(context),
            gameService: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) =>
              LastSessionGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted.empty()),
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
            MediaSessionDTO,
            SessionDTO,
            SessionWithMediaSelectBloc,
            SessionWithMediaListBloc,
            CalendarYearDatesBloc,
            LastSessionGetBloc
          >(
            title: context.localize().calendarTitle,
            firstDay: DateTime(1970),
            lastDay: DateTime.now(),
            endDateGetter: (final data) => data.endDatetime,
            detailBuilder: (final context, final data, final onClosed) =>
                SessionWithMediaDetail(
                  // Recreate on selection change
                  key: Key(data.session.startDatetime.toIso8601String()),
                  data: data,
                  onBackPressed: onClosed,
                ),
            listItemBuilder:
                (final context, final data, final selectedDay, final onTap) =>
                    SessionWithMediaTileListItem(
                      data: data,
                      selectedDay: selectedDay,
                      onTap: onTap,
                    ),
          ),
    );
  }
}

class SessionWithMediaDetail extends StatelessWidget {
  const SessionWithMediaDetail({
    super.key,
    required this.data,
    required this.onBackPressed,
    this.actions,
  });

  final MediaSessionDTO data;
  final VoidCallback onBackPressed;
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) {
    _loadOnlyInitial<DeviceDTO, DeviceGetBloc>(context, data.session.deviceId);

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
                label: context.localize().titleLabel,
                value: data.media.media.title,
              ),
              TextLabel(
                label: context.localize().editionLabel,
                value: data.media.media.edition,
              ),
              TextLabel(
                label: context.localize().startDateTimeLabel,
                value:
                    '${MaterialLocalizations.of(context).formatCompactDate(data.session.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.session.startDatetime))}',
              ),
              TextLabel(
                label: context.localize().endDateTimeLabel,
                value:
                    '${MaterialLocalizations.of(context).formatCompactDate(data.session.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.session.endDatetime))}',
              ),
              TextLabel(
                label: context.localize().timeLabel,
                value: context.localize().formatDuration(data.session.time),
              ),
              if (data.session.started)
                IconLabel(
                  icon: CommonIcons.first,
                  label: context.localize().startedLabel,
                ),
              if (data.session.finishedStatus == MediaStatus.completed)
                IconLabel(
                  icon: CommonIcons.finished,
                  label: context.localize().completedLabel,
                ),
              if (data.session.finishedStatus == MediaStatus.dropped)
                IconLabel(
                  icon: CommonIcons.dropped,
                  label: context.localize().droppedLabel,
                ),
              if (data.session.deviceId != null)
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
