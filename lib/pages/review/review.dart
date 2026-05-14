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
        ReviewTop5MediasByTotalTimeListBloc,
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
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart' show ReviewStartEnd;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

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
          create: (_) => ReviewLongestSessionGetBloc(
            service: RepositoryProvider.of(context),
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
        Test(onRender: () {}, child: buildDevicesSummary()),
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
      ActionState<List<AggregateGroupResultDTO<String, Duration>>>
    >(
      builder: (final context, final state) {
        List<AggregateGroupResultDTO<String, Duration>> items = [];
        if (state
            is ActionInProgress<
              List<AggregateGroupResultDTO<String, Duration>>
            >) {
          if (state.data == null || state.data!.isEmpty) {
            return CenteredGridListSkeleton(
              itemBuilder: (final index) =>
                  CenteredGridListSkeletonItem(order: index),
              itemAspectRatio: 2,
              itemCount: 5,
              columns: (MediaQuery.sizeOf(context).width / 700).ceil(),
            );
          }
          items = state.data!;
        } else if (state
            is ActionFinal<
              List<AggregateGroupResultDTO<String, Duration>>,
              ReviewStartEnd
            >) {
          if (state
              is ActionSuccess<
                List<AggregateGroupResultDTO<String, Duration>>,
                ReviewStartEnd
              >) {
            if (state.data.isEmpty) {
              return Center(child: Text(context.localize().emptyListLabel));
            }
            items = state.data;
          }
          if (state
              is ActionFailure<
                List<AggregateGroupResultDTO<String, Duration>>,
                ReviewStartEnd
              >) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.localize().errorPageLoadTitle),
                  OutlinedButton.icon(
                    icon: CommonIcons.reload,
                    label: Text(context.localize().retryLabel),
                    onPressed: () => context
                        .read<ReviewTop5MediasByTotalTimeListBloc>()
                        .add(const ActionRestarted()),
                  ),
                ],
              ),
            );
          }
        }

        return CenteredGridList(
          items: items,
          itemBuilder: (final context, final item, final index) => buildCard(
            primary: buildStatContainer('Media', item.key),
            secondary: buildStatContainer(
              'Time',
              context.localize().formatDuration(item.value),
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
        final total = (state is ActionSuccess<int, ReviewStartEnd>)
            ? state.data
            : 0;

        return BlocBuilder<ReviewTotalFirstMediasGetBloc, ActionState<int>>(
          builder: (final context, final firstState) {
            final totalFirst =
                (firstState is ActionSuccess<int, ReviewStartEnd>)
                ? firstState.data
                : 0;

            return buildCard(
              primary: buildStatContainer(
                context.localize().totalMediasLabel,
                total.toString(),
              ),
              secondary: buildStatContainer(
                context.localize().totalFirstMediasLabel,
                totalFirst.toString(),
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
        final total = (state is ActionSuccess<int, ReviewStartEnd>)
            ? state.data
            : 0;

        return BlocBuilder<
          ReviewTotalFirstFinishedMediasGetBloc,
          ActionState<int>
        >(
          builder: (final context, final firstState) {
            final totalFirst =
                (firstState is ActionSuccess<int, ReviewStartEnd>)
                ? firstState.data
                : 0;

            return buildCard(
              primary: buildStatContainer(
                context.localize().totalFinishedMediasLabel,
                total.toString(),
              ),
              secondary: buildStatContainer(
                context.localize().totalFirstFinishedMediasLabel,
                totalFirst.toString(),
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
        final totalTime = (state is ActionSuccess<Duration, ReviewStartEnd>)
            ? state.data
            : Duration.zero;

        return BlocBuilder<ReviewTotalSessionsGetBloc, ActionState<int>>(
          builder: (final context, final firstState) {
            final totalSessions =
                (firstState is ActionSuccess<int, ReviewStartEnd>)
                ? firstState.data
                : 0;

            return buildCard(
              primary: buildStatContainer(
                context.localize().totalTimeLabel,
                context.localize().formatDuration(totalTime),
              ),
              secondary: buildStatContainer(
                context.localize().totalSessionsLabel,
                totalSessions.toString(),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildDevicesSummary() {
    return Container();
  }

  Widget buildLongestSessionSummary() {
    return BlocBuilder<ReviewLongestSessionGetBloc, ActionState<SessionDTO>>(
      builder: (final context, final state) {
        final session = (state is ActionSuccess<SessionDTO, ReviewStartEnd>)
            ? state.data
            : SessionDTO(
                mediaId: '',
                groupId: '',
                startDatetime: DateTime.now(),
                endDatetime: DateTime.now(),
                started: false,
                time: Duration.zero,
                addedDatetime: DateTime.now(),
                updatedDatetime: DateTime.now(),
              );

        return buildCard(
          primary: buildStatContainer(
            context.localize().longestSessionLabel,
            session.mediaId.toString(),
          ),
          secondary: buildStatContainer(
            'Start end', // TODO
            '${session.startDatetime.toIso8601String()} - ${session.endDatetime.toIso8601String()}',
          ),
        );
      },
    );
  }

  Widget buildLongestStreakSummary() {
    return BlocBuilder<
      ReviewLongestStreakGetBloc,
      ActionState<SessionStreakDTO>
    >(
      builder: (final context, final state) {
        final streak =
            (state is ActionSuccess<SessionStreakDTO, ReviewStartEnd>)
            ? state.data
            : SessionStreakDTO(
                days: 0,
                endDate: DateTime.now(),
                startDate: DateTime.now(),
              );

        return buildCard(
          primary: buildStatContainer(
            context.localize().longestStreakLabel,
            streak.days.toString(),
          ),
          secondary: buildStatContainer(
            'Start end', // TODO
            '${MaterialLocalizations.of(context).formatCompactDate(streak.startDate)} - ${MaterialLocalizations.of(context).formatCompactDate(streak.endDate)}',
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
        final res =
            (state
                is ActionSuccess<
                  List<AggregateGroupResultDTO<int, int>>,
                  ReviewStartEnd
                >)
            ? state.data
            : const <AggregateGroupResultDTO<int, int>>[];

        return StatisticsBarChart<int>(
          id: 'total-medias-by-release-year',
          values: SplayTreeMap.fromIterable(
            res,
            key: (final element) => element.key.toString(),
            value: (final element) => element.value,
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
        final res =
            (state
                is ActionSuccess<
                  List<AggregateGroupResultDTO<int, int>>,
                  ReviewStartEnd
                >)
            ? state.data
            : const <AggregateGroupResultDTO<int, int>>[];

        return StatisticsBarChart<int>(
          id: 'total-finished-medias-by-release-year',
          values: SplayTreeMap.fromIterable(
            res,
            key: (final element) => element.key.toString(),
            value: (final element) => element.value,
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

  Container buildCard({
    required final Widget primary,
    required final Widget secondary,
  }) {
    return Container(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [primary, secondary],
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
    required this.onTap,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final void Function()? onTap;

  @override
  Widget build(final BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(borderRadius: borderRadius, onTap: onTap, child: child),
    );
  }
}
