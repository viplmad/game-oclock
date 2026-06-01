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
        ReviewTotalFinishedMediasGroupByMonthGetBloc,
        ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc,
        ReviewTotalFirstFinishedMediasGetBloc,
        ReviewTotalFirstMediasGetBloc,
        ReviewTotalMediasGetBloc,
        ReviewTotalMediasGroupByGenreGetBloc,
        ReviewTotalMediasGroupByRatingGetBloc,
        ReviewTotalMediasGroupByReleaseDateYearGetBloc,
        ReviewTotalSessionsGetBloc,
        ReviewTotalTimeGetBloc,
        ReviewTotalTimeGroupByHourGetBloc,
        ReviewTotalTimeGroupByMonthThenMediaGetBloc,
        ReviewTotalTimeGroupByWeekdayGetBloc,
        ReviewYearSelectBloc;
import 'package:game_oclock/components/charts/bar_chart.dart';
import 'package:game_oclock/components/charts/line_chart.dart';
import 'package:game_oclock/components/charts/pie_chart.dart';
import 'package:game_oclock/components/charts/series_element.dart';
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

const int maxRecentYears = 7;

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
        BlocProvider(
          create: (_) => ReviewTotalMediasGroupByGenreGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalTimeGroupByMonthThenMediaGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalMediasGroupByRatingGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalFinishedMediasGroupByMonthGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalTimeGroupByWeekdayGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) => ReviewTotalTimeGroupByHourGetBloc(
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

          _loadOnlyNotInitial<ReviewTotalDevicesGetBloc>(context, reviewData);
          _loadOnlyNotInitial<ReviewMostUsedDeviceGetBloc>(context, reviewData);

          _loadOnlyNotInitial<ReviewLongestSessionGetBloc>(context, reviewData);

          _loadOnlyNotInitial<ReviewLongestStreakGetBloc>(context, reviewData);

          _loadOnlyNotInitial<ReviewTotalMediasGroupByReleaseDateYearGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<
            ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
          >(context, reviewData);

          _loadOnlyNotInitial<ReviewTotalMediasGroupByGenreGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<ReviewTotalTimeGroupByMonthThenMediaGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<ReviewTotalMediasGroupByRatingGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<ReviewTotalFinishedMediasGroupByMonthGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<ReviewTotalTimeGroupByWeekdayGetBloc>(
            context,
            reviewData,
          );

          _loadOnlyNotInitial<ReviewTotalTimeGroupByHourGetBloc>(
            context,
            reviewData,
          );

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
      items: <LazyRender>[
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalMediasGetBloc>(context);
            _loadOnlyInitialReview<ReviewTotalFirstMediasGetBloc>(context);
          },
          child: buildTotalMediasSummary(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalFinishedMediasGetBloc>(context);
            _loadOnlyInitialReview<ReviewTotalFirstFinishedMediasGetBloc>(
              context,
            );
          },
          child: buildTotalFinishedMediasSummary(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalTimeGetBloc>(context);
            _loadOnlyInitialReview<ReviewTotalSessionsGetBloc>(context);
          },
          child: buildTotalTimeSummary(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalDevicesGetBloc>(context);
            _loadOnlyInitialReview<ReviewMostUsedDeviceGetBloc>(context);
          },
          child: buildDevicesSummary(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewLongestSessionGetBloc>(context);
          },
          child: buildLongestSessionSummary(),
        ),
        LazyRender(
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
      items: <LazyRender>[
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<
              ReviewTotalMediasGroupByReleaseDateYearGetBloc
            >(context);
          },
          child: buildTotalMediasGroupByReleaseDateYearChart(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<
              ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
            >(context);
          },
          child: buildTotalFinishedMediasGroupByReleaseDateYearChart(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalMediasGroupByGenreGetBloc>(
              context,
            );
          },
          child: buildTotalMediasGroupByGenreChart(),
        ),
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
          itemBuilder: (final context, final item, final index) =>
              buildStatCard(
                primary: buildStatContainer(
                  context,
                  'Media',
                  item.media.media.title,
                ),
                secondary: buildStatContainer(
                  context,
                  'Time', // TODO
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
      items: <LazyRender>[
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalTimeGroupByMonthThenMediaGetBloc>(
              context,
            );
          },
          child: buildPlayMonthMediaChart(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalMediasGroupByRatingGetBloc>(
              context,
            );
          },
          child: buildTotalMediasGroupByRatingChart(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<
              ReviewTotalFinishedMediasGroupByMonthGetBloc
            >(context);
          },
          child: buildTotalFinishedMediasGroupByMonthChart(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalTimeGroupByWeekdayGetBloc>(
              context,
            );
          },
          child: buildPlayWeekdayChart(),
        ),
        LazyRender(
          onRender: () {
            _loadOnlyInitialReview<ReviewTotalTimeGroupByHourGetBloc>(context);
          },
          child: buildPlayHourChart(),
        ),
      ],
      itemBuilder: (final context, final item, final index) {
        item.onRender();
        return item.child;
      },
      itemAspectRatio: 2,
      columns: (MediaQuery.sizeOf(context).width / 800).ceil(),
    );
  }

  Widget buildPlayMonthMediaChart() {
    return BlocBuilder<ReviewTotalTimeGetBloc, ActionState<Duration>>(
      builder: (final context, final totalState) {
        return BlocBuilder<
          ReviewTotalTimeGroupByMonthThenMediaGetBloc,
          ActionState<
            List<
              AggregateGroupResultDTO<
                int,
                List<AggregateGroupResultDTO<String, Duration>>
              >
            >
          >
        >(
          builder: (final context, final state) => buildFromState(
            context,
            state: totalState,
            onRetryTap: () => context.read<ReviewTotalTimeGetBloc>().add(
              const ActionRestarted(),
            ),
            builder: (final context, final totalData) => buildFromState(
              context,
              state: state,
              onRetryTap: () => context
                  .read<ReviewTotalTimeGroupByMonthThenMediaGetBloc>()
                  .add(const ActionRestarted()),
              builder: (final context, final data) => buildChartCard(
                title: context.localize().playtimeByMonthTitle,
                chart: StatisticsStackedBarChart<int>(
                  id: 'total-time-by-month-then-media',
                  // Generate from fixed length in case some months have no data
                  values: List.generate(DateTime.monthsPerYear, (final index) {
                    final month = index + 1;
                    final l =
                        data
                            .where((final el) => el.key == month)
                            .firstOrNull
                            ?.value ??
                        [];
                    return SeriesEntry(
                      key: context.localize().monthAbbr(month),
                      value: l
                          .map(
                            (final el) => SeriesEntry(
                              key: el.key,
                              value: el.value.inMinutes,
                            ),
                          )
                          .toList(growable: false),
                    );
                  }, growable: false),
                  hideValueLabels: true,
                  measureFormatter: (final measure) =>
                      _preparePercentageMeasure(context, measure, totalData),
                  colourGetter: (_, _, _, final index) =>
                      chartColors.elementAt(index % chartColors.length),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTotalMediasGroupByRatingChart() {
    return BlocBuilder<
      ReviewTotalMediasGroupByRatingGetBloc,
      ActionState<List<AggregateGroupResultDTO<int, int>>>
    >(
      builder: (final context, final state) => buildFromState(
        context,
        state: state,
        onRetryTap: () => context
            .read<ReviewTotalMediasGroupByRatingGetBloc>()
            .add(const ActionRestarted()),
        builder: (final context, final data) => buildChartCard(
          title: context.localize().playedByRatingTitle,
          chart: StatisticsBarChart<int>(
            id: 'total-medias-by-rating',
            // Generate from fixed length in case some ratings have no data
            values: List.generate(10, (final index) {
              final rating = index + 1;
              return SeriesEntry(
                key: '$rating',
                value: data
                    .where((final el) => el.key == rating)
                    .fold(0, (final prev, final el) => prev + el.value),
              );
            }, growable: false),
            hideValueLabels: true,
            colourGetter: (_, _) => chartColors.elementAt(0),
          ),
        ),
      ),
    );
  }

  Widget buildTotalFinishedMediasGroupByMonthChart() {
    return BlocBuilder<
      ReviewTotalFinishedMediasGroupByMonthGetBloc,
      ActionState<List<AggregateGroupResultDTO<int, int>>>
    >(
      builder: (final context, final state) => buildFromState(
        context,
        state: state,
        onRetryTap: () => context
            .read<ReviewTotalFinishedMediasGroupByMonthGetBloc>()
            .add(const ActionRestarted()),
        builder: (final context, final data) => buildChartCard(
          title: context.localize().finishedByMonthTitle,
          chart: StatisticsBarChart<int>(
            id: 'total-finished-medias-by-month',
            // Generate from fixed length in case some months have no data
            values: List.generate(DateTime.monthsPerYear, (final index) {
              final month = index + 1;
              return SeriesEntry(
                key: context.localize().monthAbbr(month),
                value: data
                    .where((final el) => el.key == month)
                    .fold(0, (final prev, final el) => prev + el.value),
              );
            }, growable: false),
            hideValueLabels: true,
            colourGetter: (_, _) => chartColors.elementAt(0),
          ),
        ),
      ),
    );
  }

  Widget buildPlayWeekdayChart() {
    return BlocBuilder<ReviewTotalTimeGetBloc, ActionState<Duration>>(
      builder: (final context, final totalState) {
        return BlocBuilder<
          ReviewTotalTimeGroupByWeekdayGetBloc,
          ActionState<List<AggregateGroupResultDTO<int, Duration>>>
        >(
          builder: (final context, final state) => buildFromState(
            context,
            state: totalState,
            onRetryTap: () => context.read<ReviewTotalTimeGetBloc>().add(
              const ActionRestarted(),
            ),
            builder: (final context, final totalData) => buildFromState(
              context,
              state: state,
              onRetryTap: () => context
                  .read<ReviewTotalTimeGroupByWeekdayGetBloc>()
                  .add(const ActionRestarted()),
              builder: (final context, final data) => buildChartCard(
                title: context.localize().playtimeByWeekdayTitle,
                chart: StatisticsLineChart<int>(
                  id: 'total-time-by-weekday',
                  // Generate from fixed length in case some weekdays have no data
                  values: List.generate(DateTime.daysPerWeek, (final index) {
                    final weekday = index + 1;
                    // TODO take into account date config starting day of week
                    return SeriesEntry(
                      key: context.localize().weekdayAbbr(weekday),
                      value: data
                          .where((final el) => el.key == weekday)
                          .fold(
                            0,
                            (final prev, final el) => prev + el.value.inMinutes,
                          ),
                    );
                  }, growable: false),
                  hideValueLabels: true,
                  measureFormatter: (final measure) =>
                      _preparePercentageMeasure(context, measure, totalData),
                  colourGetter: (_, _) => chartColors.elementAt(0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPlayHourChart() {
    return BlocBuilder<ReviewTotalTimeGetBloc, ActionState<Duration>>(
      builder: (final context, final totalState) {
        return BlocBuilder<
          ReviewTotalTimeGroupByHourGetBloc,
          ActionState<List<AggregateGroupResultDTO<int, Duration>>>
        >(
          builder: (final context, final state) => buildFromState(
            context,
            state: totalState,
            onRetryTap: () => context.read<ReviewTotalTimeGetBloc>().add(
              const ActionRestarted(),
            ),
            builder: (final context, final totalData) => buildFromState(
              context,
              state: state,
              onRetryTap: () => context
                  .read<ReviewTotalTimeGroupByHourGetBloc>()
                  .add(const ActionRestarted()),
              builder: (final context, final data) => buildChartCard(
                title: context.localize().playtimeByHourTitle,
                chart: StatisticsLineChart<int>(
                  id: 'total-time-by-hour',
                  // Generate from fixed length in case some hours have no data
                  values: List.generate(TimeOfDay.hoursPerDay, (final index) {
                    final hour = index;
                    return SeriesEntry(
                      key: context.localize().formatHour(hour),
                      value: data
                          .where((final el) => el.key == hour)
                          .fold(
                            0,
                            (final prev, final el) => prev + el.value.inMinutes,
                          ),
                    );
                  }, growable: false),
                  hideValueLabels: true,
                  measureFormatter: (final measure) =>
                      _preparePercentageMeasure(context, measure, totalData),
                  colourGetter: (_, _) => chartColors.elementAt(0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String _preparePercentageMeasure(
    final BuildContext context,
    final num? measure,
    final Duration totalData,
  ) {
    final percentage = (measure ?? 0) / totalData.inMinutes;
    return percentage < 0.01
        ? '<${context.localize().formatPercentage(0.01)}'
        : context.localize().formatPercentage(percentage);
  }

  Widget buildTotalMediasSummary() {
    return BlocBuilder<ReviewTotalMediasGetBloc, ActionState<int>>(
      builder: (final context, final totalState) {
        return BlocBuilder<ReviewTotalFirstMediasGetBloc, ActionState<int>>(
          builder: (final context, final firstState) {
            return buildFromState(
              context,
              state: totalState,
              onRetryTap: () => context.read<ReviewTotalMediasGetBloc>().add(
                const ActionRestarted(),
              ),
              builder: (final context, final totalData) => buildFromState(
                context,
                state: firstState,
                onRetryTap: () => context
                    .read<ReviewTotalFirstMediasGetBloc>()
                    .add(const ActionRestarted()),
                builder: (final context, final firstData) => buildStatCard(
                  primary: buildStatContainer(
                    context,
                    context.localize().totalMediasLabel,
                    '$totalData',
                  ),
                  secondary: buildStatContainer(
                    context,
                    context.localize().totalFirstMediasLabel,
                    '$firstData (${context.localize().formatPercentage(firstData / totalData)})',
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
    return BlocBuilder<ReviewTotalMediasGetBloc, ActionState<int>>(
      builder: (final context, final totalTotalState) {
        return BlocBuilder<ReviewTotalFinishedMediasGetBloc, ActionState<int>>(
          builder: (final context, final totalState) {
            return BlocBuilder<
              ReviewTotalFirstFinishedMediasGetBloc,
              ActionState<int>
            >(
              builder: (final context, final firstState) => buildFromState(
                context,
                state: totalTotalState,
                onRetryTap: () => context.read<ReviewTotalMediasGetBloc>().add(
                  const ActionRestarted(),
                ),
                builder: (final context, final totalTotalData) => buildFromState(
                  context,
                  state: totalState,
                  onRetryTap: () => context
                      .read<ReviewTotalFinishedMediasGetBloc>()
                      .add(const ActionRestarted()),
                  builder: (final context, final totalData) => buildFromState(
                    context,
                    state: firstState,
                    onRetryTap: () => context
                        .read<ReviewTotalFirstFinishedMediasGetBloc>()
                        .add(const ActionRestarted()),
                    builder: (final context, final firstData) => buildStatCard(
                      primary: buildStatContainer(
                        context,
                        context.localize().totalFinishedMediasLabel,
                        '$totalData (${context.localize().formatPercentage(totalData / totalTotalData)})',
                      ),
                      secondary: buildStatContainer(
                        context,
                        context.localize().totalFirstFinishedMediasLabel,
                        '$firstData (${context.localize().formatPercentage(firstData / totalData)})',
                      ),
                    ),
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
                builder: (final context, final sessionsData) => buildStatCard(
                  primary: buildStatContainer(
                    context,
                    context.localize().totalTimeLabel,
                    context.localize().formatDuration(data),
                  ),
                  secondary: buildStatContainer(
                    context,
                    context.localize().totalSessionsLabel,
                    '$sessionsData',
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
                    : buildStatCard(
                        primary: buildStatContainer(
                          context,
                          context.localize().totalDevicesLabel,
                          '$data',
                        ),
                        secondary: buildStatContainer(
                          context,
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
              : buildStatCard(
                  primary: buildStatContainer(
                    context,
                    context.localize().longestSessionLabel,
                    context.localize().formatDuration(data.session.time),
                  ),
                  secondary: buildStatContainer(
                    context,
                    '${MaterialLocalizations.of(context).formatCompactDate(data.session.startDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.session.startDatetime))} ⮕ ${MaterialLocalizations.of(context).formatCompactDate(data.session.endDatetime)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(data.session.endDatetime))}',
                    data.media.media.title,
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
          builder: (final context, final data) => buildStatCard(
            primary: buildStatContainer(
              context,
              context.localize().longestStreakLabel,
              context.localize().daysLabel(data.days),
            ),
            secondary: buildStatContainer(
              context,
              '${MaterialLocalizations.of(context).formatCompactDate(data.startDate)} ⮕ ${MaterialLocalizations.of(context).formatCompactDate(data.endDate)}',
              context.localize().gamesLabel(data.mediaIds.length),
            ),
          ),
        );
      },
    );
  }

  Widget buildTotalMediasGroupByReleaseDateYearChart() {
    return BlocBuilder<ReviewYearSelectBloc, ActionState<int?>>(
      builder: (final context, final yearState) {
        final currentYear = (yearState is ActionSuccess<int?, int?>)
            ? yearState.data ?? DateTime.now().year
            : DateTime.now().year;
        final recentYear = currentYear - maxRecentYears;

        return BlocBuilder<ReviewTotalMediasGetBloc, ActionState<int>>(
          builder: (final context, final totalState) {
            return BlocBuilder<
              ReviewTotalMediasGroupByReleaseDateYearGetBloc,
              ActionState<List<AggregateGroupResultDTO<int, int>>>
            >(
              builder: (final context, final state) => buildFromState(
                context,
                state: totalState,
                onRetryTap: () => context.read<ReviewTotalMediasGetBloc>().add(
                  const ActionRestarted(),
                ),
                builder: (final context, final totalData) => buildFromState(
                  context,
                  state: state,
                  onRetryTap: () => context
                      .read<ReviewTotalMediasGroupByReleaseDateYearGetBloc>()
                      .add(const ActionRestarted()),
                  builder: (final context, final data) => buildChartCard(
                    title: context.localize().playedByReleaseYearTitle,
                    chart: StatisticsPieChart<int>(
                      id: 'total-medias-by-release-year',
                      values: List.unmodifiable(<SeriesEntry<int>>[
                        SeriesEntry(
                          key: context.localize().newReleasesLabel,
                          value: data
                              .where((final el) => el.key == currentYear)
                              .fold(
                                0,
                                (final prev, final el) => prev + el.value,
                              ),
                        ),
                        SeriesEntry(
                          key: context.localize().recentLabel,
                          value: data
                              .where(
                                (final el) =>
                                    el.key < currentYear &&
                                    el.key >= recentYear,
                              )
                              .fold(
                                0,
                                (final prev, final el) => prev + el.value,
                              ),
                        ),
                        SeriesEntry(
                          key: context.localize().classicLabel,
                          value: data
                              .where((final el) => el.key < recentYear)
                              .fold(
                                0,
                                (final prev, final el) => prev + el.value,
                              ),
                        ),
                      ]),
                      valueFormatter: (final domain, final value) =>
                          '$domain - ${context.localize().formatPercentage(value / totalData)} ($value)',
                      colourGetter: (_, final index) =>
                          chartColors.elementAt(index),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTotalFinishedMediasGroupByReleaseDateYearChart() {
    return BlocBuilder<ReviewYearSelectBloc, ActionState<int?>>(
      builder: (final context, final yearState) {
        final currentYear = (yearState is ActionSuccess<int?, int?>)
            ? yearState.data ?? DateTime.now().year
            : DateTime.now().year;
        final recentYear = currentYear - maxRecentYears;

        return BlocBuilder<ReviewTotalFinishedMediasGetBloc, ActionState<int>>(
          builder: (final context, final totalState) {
            return BlocBuilder<
              ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc,
              ActionState<List<AggregateGroupResultDTO<int, int>>>
            >(
              builder: (final context, final state) => buildFromState(
                context,
                state: totalState,
                onRetryTap: () => context
                    .read<ReviewTotalFinishedMediasGetBloc>()
                    .add(const ActionRestarted()),
                builder: (final context, final totalData) => buildFromState(
                  context,
                  state: state,
                  onRetryTap: () => context
                      .read<
                        ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
                      >()
                      .add(const ActionRestarted()),
                  builder: (final context, final data) => buildChartCard(
                    title: context.localize().finishedByReleaseYearTitle,
                    chart: StatisticsPieChart<int>(
                      id: 'total-finished-medias-by-release-year',
                      values: List.unmodifiable(<SeriesEntry<int>>[
                        SeriesEntry(
                          key: context.localize().newReleasesLabel,
                          value: data
                              .where((final el) => el.key == currentYear)
                              .fold(
                                0,
                                (final prev, final el) => prev + el.value,
                              ),
                        ),
                        SeriesEntry(
                          key: context.localize().recentLabel,
                          value: data
                              .where(
                                (final el) =>
                                    el.key < currentYear &&
                                    el.key >= recentYear,
                              )
                              .fold(
                                0,
                                (final prev, final el) => prev + el.value,
                              ),
                        ),
                        SeriesEntry(
                          key: context.localize().classicLabel,
                          value: data
                              .where((final el) => el.key < recentYear)
                              .fold(
                                0,
                                (final prev, final el) => prev + el.value,
                              ),
                        ),
                      ]),
                      valueFormatter: (final domain, final value) =>
                          '$domain - ${context.localize().formatPercentage(value / totalData)} ($value)',
                      colourGetter: (_, final index) =>
                          chartColors.elementAt(index),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTotalMediasGroupByGenreChart() {
    return BlocBuilder<ReviewTotalMediasGetBloc, ActionState<int>>(
      builder: (final context, final totalState) {
        return BlocBuilder<
          ReviewTotalMediasGroupByGenreGetBloc,
          ActionState<List<AggregateGroupResultDTO<String, int>>>
        >(
          builder: (final context, final state) => buildFromState(
            context,
            state: totalState,
            onRetryTap: () => context.read<ReviewTotalMediasGetBloc>().add(
              const ActionRestarted(),
            ),
            builder: (final context, final totalData) => buildFromState(
              context,
              state: state,
              onRetryTap: () => context
                  .read<ReviewTotalMediasGroupByGenreGetBloc>()
                  .add(const ActionRestarted()),
              builder: (final context, final data) => buildChartCard(
                title: context.localize().playedByGenreTitle,
                chart: StatisticsBarChart<int>(
                  id: 'total-medias-by-genre',
                  values: data
                      .map(
                        (final el) => SeriesEntry(key: el.key, value: el.value),
                      )
                      .toList(growable: false),
                  vertical: false,
                  valueFormatter: (final value) =>
                      '${context.localize().formatPercentage(value / totalData)} ($value)',
                  colourGetter: (_, final index) =>
                      chartColors.elementAt(index),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildStatContainer(
    final BuildContext context,
    final String text,
    final String value,
  ) {
    return ListTile(
      title: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      subtitle: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  Widget buildEmptyCard(final BuildContext context) {
    return CardWithTap(
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ListTile(title: Text(context.localize().noDataLabel))],
      ),
    );
  }

  Widget buildStatCard({
    required final Widget primary,
    required final Widget secondary,
  }) {
    return CardWithTap(
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [primary, secondary],
      ),
    );
  }

  Widget buildChartCard({
    required final String title,
    required final Widget chart,
  }) {
    return CardWithTap(
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(title: Text(title)),
          Expanded(child: chart),
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

              _reloadOnlyNotInitial<ReviewTotalDevicesGetBloc>(context);
              _reloadOnlyNotInitial<ReviewMostUsedDeviceGetBloc>(context);

              _reloadOnlyNotInitial<ReviewLongestSessionGetBloc>(context);

              _reloadOnlyNotInitial<ReviewLongestStreakGetBloc>(context);

              _reloadOnlyNotInitial<
                ReviewTotalMediasGroupByReleaseDateYearGetBloc
              >(context);

              _reloadOnlyNotInitial<
                ReviewTotalFinishedMediasGroupByReleaseDateYearGetBloc
              >(context);

              _reloadOnlyNotInitial<ReviewTotalMediasGroupByGenreGetBloc>(
                context,
              );

              _reloadOnlyNotInitial<
                ReviewTotalTimeGroupByMonthThenMediaGetBloc
              >(context);

              _reloadOnlyNotInitial<ReviewTotalMediasGroupByRatingGetBloc>(
                context,
              );

              _reloadOnlyNotInitial<
                ReviewTotalFinishedMediasGroupByMonthGetBloc
              >(context);

              _reloadOnlyNotInitial<ReviewTotalTimeGroupByWeekdayGetBloc>(
                context,
              );

              _reloadOnlyNotInitial<ReviewTotalTimeGroupByHourGetBloc>(context);

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

class LazyRender {
  LazyRender({required this.child, required this.onRender});

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
