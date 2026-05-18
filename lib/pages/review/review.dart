import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionInProgress,
        ActionInitial,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        FunctionActionBloc,
        ReviewLongestSessionGetBloc,
        ReviewLongestStreakGetBloc,
        ReviewMostUsedDeviceGetBloc,
        ReviewTop5MediasByTotalTimeListBloc,
        ReviewTotalDevicesGetBloc,
        ReviewTotalFinishedMediasGetBloc,
        ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc,
        ReviewTotalFirstFinishedMediasGetBloc,
        ReviewTotalFirstMediasGetBloc,
        ReviewTotalMediasGetBloc,
        ReviewTotalMediasGroupByReleaseDateYearGetBloc,
        ReviewTotalSessionsGetBloc,
        ReviewTotalTimeGetBloc,
        ReviewYearSelectBloc;
import 'package:game_oclock/components/charts/bar_chart.dart';
import 'package:game_oclock/components/full_search_app_bar.dart';
import 'package:game_oclock/components/list/grid_list.dart';
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/constants/constants.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show DeviceWithTime, MediaWithTime, ReviewStartEnd, UnreachableError;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

final List<Color> chartColors = <Color>[
  Colors.redAccent,
  Colors.deepPurpleAccent,
  Colors.blueAccent,
  Colors.lightGreen[700]!,
  Colors.deepOrangeAccent,
  Colors.blueGrey,
  Colors.brown,
  Colors.lime[900]!,
  Colors.indigoAccent,
  Colors.pinkAccent,
  Colors.cyan[700]!,
  Colors.purple[300]!,
  Colors.orangeAccent,
];

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ReviewYearSelectBloc()
                ..add(ActionStarted(data: DateTime.now().year)),
        ),
        BlocProvider(
          create: (_) =>
              ReviewTotalMediasGetBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => ReviewTotalFirstMediasGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalFinishedMediasGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalFirstFinishedMediasGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) =>
              ReviewTotalTimeGetBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => ReviewTotalSessionsGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalDevicesGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewMostUsedDeviceGetBloc(
            service: RepositoryProvider.of(context),
            deviceService: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewLongestSessionGetBloc(
            service: RepositoryProvider.of(context),
            gameService: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewLongestStreakGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        //
        BlocProvider(
          create: (_) => ReviewTotalMediasGroupByReleaseDateYearGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        //
        BlocProvider(
          create: (_) => ReviewTop5MediasByTotalTimeListBloc(
            service: RepositoryProvider.of(context),
            gameService: RepositoryProvider.of(context),
          ),
        ),
      ],
      child: ReviewBuilder(title: context.localize().yearInReviewTitle),
    );
  }
}

class ReviewBuilder extends StatelessWidget {
  const ReviewBuilder({super.key, required this.title});

  final String title;

  @override
  Widget build(final BuildContext context) {
    return BlocListener<ReviewYearSelectBloc, ActionState<int?>>(
      listener: (final context, final state) {
        if (state is ActionFinal<int?, int?>) {
          final currentYear = (state is ActionSuccess<int?, int?>)
              ? state.data ?? DateTime.now().year
              : DateTime.now().year;
          final reviewData = ReviewStartEnd(
            start: DateTime(currentYear),
            end: DateTime(currentYear + 1),
          );

          _loadOnlyNotInitial<ReviewTotalMediasGetBloc>(context, reviewData);
          _loadOnlyNotInitial<ReviewTotalFirstMediasGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<ReviewTotalFinishedMediasGetBloc>(
            context,
            reviewData,
          );
          _loadOnlyNotInitial<ReviewTotalFirstFinishedMediasGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<ReviewTotalTimeGetBloc>(context, reviewData);
          _loadOnlyNotInitial<ReviewTotalSessionsGetBloc>(context, reviewData);

          _loadOnlyNotInitial<ReviewLongestSessionGetBloc>(context, reviewData);

          _loadOnlyNotInitial<ReviewLongestStreakGetBloc>(context, reviewData);

          _loadOnlyNotInitial<ReviewTotalMediasGroupByReleaseDateYearGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<
            ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
          >(context, reviewData);

          _loadOnlyNotInitial<ReviewTop5MediasByTotalTimeListBloc>(
            context,
            reviewData,
          );
        }
      },
      child: NestedScrollView(
        headerSliverBuilder: _appBarBuilder,
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildInitialSummaryList(context),
              const Divider(), // TODO
              buildSummaryChartList(context),
              const Divider(), // TODO
              buildTop5SummaryList(context),
              const Divider(), // TODO
              buildPlayTimeChartList(context),
            ],
          ),
        ),
      ),
    );
  }

  void _loadOnlyNotInitial<AB>(
    final BuildContext context,
    final ReviewStartEnd data,
  ) {
    final ab = context.read<AB>() as FunctionActionBloc;
    if (ab.state is! ActionInitial) {
      ab.add(ActionStarted<ReviewStartEnd>(data: data));
    }
  }

  void _loadOnlyInitial<AB>(
    final BuildContext context,
    final ReviewStartEnd data,
  ) {
    final ab = context.read<AB>() as FunctionActionBloc;
    if (ab.state is ActionInitial) {
      ab.add(ActionStarted<ReviewStartEnd>(data: data));
    }
  }

  void _loadOnlyInitialReview<AB>(final BuildContext context) {
    final state = context.read<ReviewYearSelectBloc>().state;
    final currentYear = (state is ActionSuccess<int?, int?>)
        ? state.data ?? DateTime.now().year
        : DateTime.now().year;
    final reviewData = ReviewStartEnd(
      start: DateTime(currentYear),
      end: DateTime(currentYear + 1),
    );

    _loadOnlyInitial<AB>(context, reviewData);
  }

  void _reloadOnlyNotInitial<AB>(final BuildContext context) {
    final ab = context.read<AB>() as FunctionActionBloc;
    if (ab.state is! ActionInitial) {
      ab.add(const ActionRestarted<ReviewStartEnd>());
    }
  }

  Widget buildInitialSummaryList(final BuildContext context) {
    return CenteredGridList(
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
      items: <Test>[
        Test(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalMediasGetBloc>(context);
            _loadOnlyInitialReview<ReviewTotalFirstMediasGetBloc>(context);
          },
          child: buildTotalMediasSummary(),
        ),
        Test(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalFinishedMediasGetBloc>(context);
            _loadOnlyInitialReview<ReviewTotalFirstFinishedMediasGetBloc>(
              context,
            );
          },
          child: buildTotalFinishedMediasSummary(),
        ),
        Test(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalTimeGetBloc>(context);
            _loadOnlyInitialReview<ReviewTotalSessionsGetBloc>(context);
          },
          child: buildTotalTimeSummary(),
        ),
        Test(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalDevicesGetBloc>(context);
            _loadOnlyInitialReview<ReviewMostUsedDeviceGetBloc>(context);
          },
          child: buildDevicesSummary(),
        ),
        Test(
          onRender: () {
            _loadOnlyInitialReview<ReviewLongestSessionGetBloc>(context);
          },
          child: buildLongestSessionSummary(),
        ),
        Test(
          onRender: () {
            _loadOnlyInitialReview<ReviewLongestStreakGetBloc>(context);
          },
          child: buildLongestStreakSummary(),
        ),
      ],
      itemBuilder: (final context, final item, final index) {
        item.onRender();
        return item.child;
      },
      itemAspectRatio: 1.5,
      columns: (MediaQuery.sizeOf(context).width / 500).ceil(),
    );
  }

  Widget buildSummaryChartList(final BuildContext context) {
    return CenteredGridList(
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
      items: <Test>[
        Test(
          onRender: () {
            _loadOnlyInitialReview<
              ReviewTotalMediasGroupByReleaseDateYearGetBloc
            >(context);
          },
          child: buildTotalMediasGroupByReleaseDateYearChart(),
        ),
        Test(
          onRender: () {
            _loadOnlyInitialReview<
              ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
            >(context);
          },
          child: buildTotalFinishedMediasGroupByReleaseDateYearChart(),
        ),
        Test(onRender: () {}, child: buildTotalMediasGroupByGenreChart()),
      ],
      itemBuilder: (final context, final item, final index) {
        item.onRender();
        return item.child;
      },
      itemAspectRatio: 2,
      columns: (MediaQuery.sizeOf(context).width / 700).ceil(),
    );
  }

  Widget buildTop5SummaryList(final BuildContext context) {
    _loadOnlyInitialReview<ReviewTop5MediasByTotalTimeListBloc>(context);
    return BlocBuilder<
      ReviewTop5MediasByTotalTimeListBloc,
      ActionState<List<MediaWithTime>>
    >(
      builder: (final context, final state) {
        List<MediaWithTime> items = [];
        if (state is ActionInProgress<List<MediaWithTime>>) {
          if (state.data == null || state.data!.isEmpty) {
            return CenteredGridListSkeleton(
              borderRadius: const BorderRadius.all(
                Radius.circular(kCardBorderRadius),
              ),
              itemBuilder: (final index) =>
                  CenteredGridListSkeletonItem(order: index),
              itemAspectRatio: 2,
              itemCount: 5,
              columns: (MediaQuery.sizeOf(context).width / 700).ceil(),
            );
          }
          items = state.data!;
        } else if (state is ActionFinal<List<MediaWithTime>, ReviewStartEnd>) {
          if (state is ActionSuccess<List<MediaWithTime>, ReviewStartEnd>) {
            if (state.data.isEmpty) {
              return Center(child: Text(context.localize().emptyListLabel));
            }
            items = state.data;
          }
          if (state is ActionFailure<List<MediaWithTime>, ReviewStartEnd>) {
            return buildErrorWidget(
              context,
              onRetryTap: () => context
                  .read<ReviewTop5MediasByTotalTimeListBloc>()
                  .add(const ActionRestarted()),
            );
          }
        }

        return CenteredGridList(
          items: items,
          itemBuilder: (final context, final item, final index) => buildCard(
            primary: buildStatContainer('Media', item.media.media.title),
            secondary: buildStatContainer(
              'Time',
              context.localize().formatDuration(item.time),
            ),
          ),
          itemAspectRatio: 2,
          columns: (MediaQuery.sizeOf(context).width / 700).ceil(),
        );
      },
    );
  }

  Widget buildPlayTimeChartList(final BuildContext context) {
    return CenteredGridList(
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
      items: [31, 32, 33, 34, 35, 36, 37, 38, 39],
      itemBuilder: (final context, final item, final index) => Container(
        color: Colors.red,
        child: Center(child: Text('$item')),
      ),
      itemAspectRatio: 2,
      columns: (MediaQuery.sizeOf(context).width / 500).ceil(),
    );
  }

  Widget buildTotalMediasSummary() {
    return BlocBuilder<ReviewTotalMediasGetBloc, ActionState<int>>(
      builder: (final context, final state) {
        return BlocBuilder<ReviewTotalFirstMediasGetBloc, ActionState<int>>(
          builder: (final context, final firstState) {
            return buildFromState(
              context,
              state: state,
              onRetryTap: () => context.read<ReviewTotalMediasGetBloc>().add(
                const ActionRestarted(),
              ),
              builder: (final context, final data) => buildFromState(
                context,
                state: firstState,
                onRetryTap: () => context
                    .read<ReviewTotalFirstMediasGetBloc>()
                    .add(const ActionRestarted()),
                builder: (final context, final firstData) => buildCard(
                  primary: buildStatContainer(
                    context.localize().totalMediasLabel,
                    data.toString(),
                  ),
                  secondary: buildStatContainer(
                    context.localize().totalFirstMediasLabel,
                    firstData.toString(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTotalFinishedMediasSummary() {
    return BlocBuilder<ReviewTotalFinishedMediasGetBloc, ActionState<int>>(
      builder: (final context, final state) {
        return BlocBuilder<
          ReviewTotalFirstFinishedMediasGetBloc,
          ActionState<int>
        >(
          builder: (final context, final firstState) {
            return buildFromState(
              context,
              state: state,
              onRetryTap: () => context
                  .read<ReviewTotalFinishedMediasGetBloc>()
                  .add(const ActionRestarted()),
              builder: (final context, final data) => buildFromState(
                context,
                state: firstState,
                onRetryTap: () => context
                    .read<ReviewTotalFirstFinishedMediasGetBloc>()
                    .add(const ActionRestarted()),
                builder: (final context, final firstData) => buildCard(
                  primary: buildStatContainer(
                    context.localize().totalFinishedMediasLabel,
                    data.toString(),
                  ),
                  secondary: buildStatContainer(
                    context.localize().totalFirstFinishedMediasLabel,
                    firstData.toString(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTotalTimeSummary() {
    return BlocBuilder<ReviewTotalTimeGetBloc, ActionState<Duration>>(
      builder: (final context, final state) {
        return BlocBuilder<ReviewTotalSessionsGetBloc, ActionState<int>>(
          builder: (final context, final sessionsState) {
            return buildFromState(
              context,
              state: state,
              onRetryTap: () => context.read<ReviewTotalTimeGetBloc>().add(
                const ActionRestarted(),
              ),
              builder: (final context, final data) => buildFromState(
                context,
                state: sessionsState,
                onRetryTap: () => context
                    .read<ReviewTotalSessionsGetBloc>()
                    .add(const ActionRestarted()),
                builder: (final context, final sessionsData) => buildCard(
                  primary: buildStatContainer(
                    context.localize().totalTimeLabel,
                    context.localize().formatDuration(data),
                  ),
                  secondary: buildStatContainer(
                    context.localize().totalSessionsLabel,
                    sessionsData.toString(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildDevicesSummary() {
    return BlocBuilder<ReviewTotalDevicesGetBloc, ActionState<int>>(
      builder: (final context, final state) {
        return BlocBuilder<
          ReviewMostUsedDeviceGetBloc,
          ActionState<DeviceWithTime?>
        >(
          builder: (final context, final mostState) {
            return buildFromState(
              context,
              state: state,
              onRetryTap: () => context.read<ReviewMostUsedDeviceGetBloc>().add(
                const ActionRestarted(),
              ),
              builder: (final context, final data) => buildFromState(
                context,
                state: mostState,
                onRetryTap: () => context
                    .read<ReviewMostUsedDeviceGetBloc>()
                    .add(const ActionRestarted()),
                builder: (final context, final mostData) => mostData == null
                    ? buildEmptyCard(context)
                    : buildCard(
                        primary: buildStatContainer(
                          context.localize().totalDevicesLabel,
                          data.toString(),
                        ),
                        secondary: buildStatContainer(
                          context.localize().mostUsedDeviceLabel,
                          '${mostData.device.name} - ${context.localize().formatDuration(mostData.time)}',
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildLongestSessionSummary() {
    return BlocBuilder<
      ReviewLongestSessionGetBloc,
      ActionState<MediaSessionDTO?>
    >(
      builder: (final context, final state) {
        return buildFromState(
          context,
          state: state,
          onRetryTap: () => context.read<ReviewLongestSessionGetBloc>().add(
            const ActionRestarted(),
          ),
          builder: (final context, final data) => data == null
              ? buildEmptyCard(context)
              : buildCard(
                  primary: buildStatContainer(
                    context.localize().longestSessionLabel,
                    data.media.media.title,
                  ),
                  secondary: buildStatContainer(
                    'Start end', // TODO
                    '${data.session.startDatetime.toIso8601String()} - ${data.session.endDatetime.toIso8601String()}',
                  ),
                ),
        );
      },
    );
  }

  Widget buildFromState<T>(
    final BuildContext context, {
    required final ActionState<T> state,
    required final VoidCallback onRetryTap,
    required final Widget Function(BuildContext context, T data) builder,
  }) {
    T data;
    if (state is ActionInProgress<T>) {
      return const CenteredGridListSkeletonItem();
    } else if (state is ActionFinal<T, ReviewStartEnd>) {
      if (state is ActionFailure<T, ReviewStartEnd>) {
        return buildErrorWidget(context, onRetryTap: onRetryTap);
      } else if (state is ActionSuccess<T, ReviewStartEnd>) {
        data = state.data;
      } else {
        throw UnreachableError();
      }
    } else {
      return const SizedBox();
    }

    return builder(context, data);
  }

  Widget buildErrorWidget(
    final BuildContext context, {
    required final VoidCallback onRetryTap,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(context.localize().errorPageLoadTitle),
          OutlinedButton.icon(
            icon: CommonIcons.reload,
            label: Text(context.localize().retryLabel),
            onPressed: onRetryTap,
          ),
        ],
      ),
    );
  }

  Widget buildLongestStreakSummary() {
    return BlocBuilder<
      ReviewLongestStreakGetBloc,
      ActionState<SessionStreakDTO>
    >(
      builder: (final context, final state) {
        return buildFromState(
          context,
          state: state,
          onRetryTap: () => context.read<ReviewLongestStreakGetBloc>().add(
            const ActionRestarted(),
          ),
          builder: (final context, final data) => buildCard(
            primary: buildStatContainer(
              context.localize().longestStreakLabel,
              data.days.toString(),
            ),
            secondary: buildStatContainer(
              'Start end', // TODO
              '${MaterialLocalizations.of(context).formatCompactDate(data.startDate)} - ${MaterialLocalizations.of(context).formatCompactDate(data.endDate)}',
            ),
          ),
        );
      },
    );
  }

  Widget buildTotalMediasGroupByReleaseDateYearChart() {
    return BlocBuilder<
      ReviewTotalMediasGroupByReleaseDateYearGetBloc,
      ActionState<List<AggregateGroupResultDTO<int, int>>>
    >(
      builder: (final context, final state) {
        return buildFromState(
          context,
          state: state,
          onRetryTap: () => context
              .read<ReviewTotalMediasGroupByReleaseDateYearGetBloc>()
              .add(const ActionRestarted()),
          builder: (final context, final data) => StatisticsBarChart<int>(
            id: 'total-medias-by-release-year',
            values: SplayTreeMap.fromIterable(
              data,
              key: (final element) => element.key.toString(),
              value: (final element) => element.value,
            ),
            colour: chartColors.first,
          ),
        );
      },
    );
  }

  Widget buildTotalFinishedMediasGroupByReleaseDateYearChart() {
    return BlocBuilder<
      ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc,
      ActionState<List<AggregateGroupResultDTO<int, int>>>
    >(
      builder: (final context, final state) {
        return buildFromState(
          context,
          state: state,
          onRetryTap: () => context
              .read<ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc>()
              .add(const ActionRestarted()),
          builder: (final context, final data) => StatisticsBarChart<int>(
            id: 'total-finished-medias-by-release-year',
            values: SplayTreeMap.fromIterable(
              data,
              key: (final element) => element.key.toString(),
              value: (final element) => element.value,
            ),
            colour: chartColors.first,
          ),
        );
      },
    );
  }

  Widget buildTotalMediasGroupByGenreChart() {
    return Container();
  }

  Widget buildStatContainer(final String title, final String value) {
    return ListTile(title: Text(title), subtitle: Text(value));
  }

  Widget buildEmptyCard(final BuildContext context) {
    return CardWithTap(
      borderRadius: BorderRadius.all(Radius.circular(kCardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ListTile(title: Text(context.localize().noDataLabel))],
      ),
    );
  }

  Widget buildCard({
    required final Widget primary,
    required final Widget secondary,
  }) {
    return CardWithTap(
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: primary),
          Expanded(flex: 1, child: secondary),
        ],
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
              final state = context.read<ReviewYearSelectBloc>().state;
              final currentYear = (state is ActionSuccess<int?, int?>)
                  ? state.data ?? DateTime.now().year
                  : DateTime.now().year;

              return await showReturningDialog<int>(
                context,
                builder: (final context) => YearPickerDialog(year: currentYear),
                onSuccess: (final context, final data) {
                  context.read<ReviewYearSelectBloc>().add(
                    ActionStarted(data: data),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: CommonIcons.reload,
            tooltip: context.localize().reloadLabel,
            onPressed: () {
              _reloadOnlyNotInitial<ReviewTotalMediasGetBloc>(context);
              _reloadOnlyNotInitial<ReviewTotalFirstMediasGetBloc>(context);

              _reloadOnlyNotInitial<ReviewTotalFinishedMediasGetBloc>(context);
              _reloadOnlyNotInitial<ReviewTotalFirstFinishedMediasGetBloc>(
                context,
              );

              _reloadOnlyNotInitial<ReviewTotalTimeGetBloc>(context);
              _reloadOnlyNotInitial<ReviewTotalSessionsGetBloc>(context);

              _reloadOnlyNotInitial<ReviewLongestSessionGetBloc>(context);

              _reloadOnlyNotInitial<ReviewLongestStreakGetBloc>(context);

              _reloadOnlyNotInitial<
                ReviewTotalMediasGroupByReleaseDateYearGetBloc
              >(context);

              _reloadOnlyNotInitial<
                ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
              >(context);

              _reloadOnlyNotInitial<ReviewTop5MediasByTotalTimeListBloc>(
                context,
              );
            },
          ),
        ],
      ),
    ];
  }
}

class Test {
  Test({required this.child, required this.onRender});

  final Widget child;
  final VoidCallback onRender;
}

class CardWithTap extends StatelessWidget {
  const CardWithTap({
    super.key,
    required this.child,
    this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final void Function()? onTap;

  @override
  Widget build(final BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: onTap == null
          ? child
          : InkWell(borderRadius: borderRadius, onTap: onTap, child: child),
    );
  }
}
