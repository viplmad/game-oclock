import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionStarted,
        ActionState,
        ActionSuccess,
        ReviewLongestStreakGetBloc,
        ReviewTotalFirstMediasGetBloc,
        ReviewTotalMediasGetBloc,
        ReviewTotalMediasGroupByReleaseDateYearGetBloc,
        ReviewTotalSessionsGetBloc,
        ReviewTotalTimeGetBloc,
        ReviewYearSelectBloc;
import 'package:game_oclock/components/charts/bar_chart.dart';
import 'package:game_oclock/components/charts/pie_chart.dart';
import 'package:game_oclock/components/full_search_app_bar.dart';
import 'package:game_oclock/components/list/grid_list.dart';
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
          create: (_) => ReviewTotalSessionsGetBloc(
            service: RepositoryProvider.of(context),
          ),
        ),
        BlocProvider(
          create: (_) =>
              ReviewTotalTimeGetBloc(service: RepositoryProvider.of(context)),
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

          context.read<ReviewTotalSessionsGetBloc>().add(
            ActionStarted(data: reviewData),
          );
          context.read<ReviewTotalTimeGetBloc>().add(
            ActionStarted(data: reviewData),
          );
          context.read<ReviewTotalMediasGetBloc>().add(
            ActionStarted(data: reviewData),
          );
          context.read<ReviewTotalFirstMediasGetBloc>().add(
            ActionStarted(data: reviewData),
          );
          context.read<ReviewLongestStreakGetBloc>().add(
            ActionStarted(data: reviewData),
          );
          context.read<ReviewTotalMediasGroupByReleaseDateYearGetBloc>().add(
            ActionStarted(data: reviewData),
          );
        }
      },
      child: NestedScrollView(
        headerSliverBuilder: _appBarBuilder,
        body: SingleChildScrollView(
          child: Column(
            /*
            summaryPlayed             summaryFinished           summaryTime
            summaryDevices            longestSession            longestStreak
            chartPlayedByReleaseYear  chartPlayedByReleaseYear  chartPlayedByGenre
            top1                      top2                      top2
            top4                      top5
            chartPlayedByRating       chartFinishedByMonth      chartPlayTimeByMonth
            chartPlayTimeByDayOfMonth chartPlayTimeByWeek       chartPlayTimeByWeekday
            chartPlayTimeByHour       chartPlayedByDevice       chartPlayTimeByDevice
          */
            children: [
              CenteredGridList(
                items: <Widget>[
                  BlocBuilder<ReviewTotalSessionsGetBloc, ActionState<int>>(
                    builder: (final context, final state) {
                      final res = (state is ActionSuccess<int, ReviewStartEnd>)
                          ? state.data
                          : 0;

                      return buildCard(
                        title: context.localize().totalSessionsLabel,
                        value: Text(res.toString()),
                      );
                    },
                  ),
                  BlocBuilder<ReviewTotalTimeGetBloc, ActionState<Duration>>(
                    builder: (final context, final state) {
                      final res =
                          (state is ActionSuccess<Duration, ReviewStartEnd>)
                          ? state.data
                          : Duration.zero;

                      return buildCard(
                        title: context.localize().totalTimeLabel,
                        value: Text(context.localize().formatDuration(res)),
                      );
                    },
                  ),
                  BlocBuilder<ReviewTotalMediasGetBloc, ActionState<int>>(
                    builder: (final context, final state) {
                      final res = (state is ActionSuccess<int, ReviewStartEnd>)
                          ? state.data
                          : 0;

                      return buildCard(
                        title: context.localize().totalMediasLabel,
                        value: Text(res.toString()),
                      );
                    },
                  ),
                  BlocBuilder<ReviewTotalFirstMediasGetBloc, ActionState<int>>(
                    builder: (final context, final state) {
                      final res = (state is ActionSuccess<int, ReviewStartEnd>)
                          ? state.data
                          : 0;

                      return buildCard(
                        title: context.localize().totalFirstMediasLabel,
                        value: Text(res.toString()),
                      );
                    },
                  ),
                  BlocBuilder<
                    ReviewTotalMediasGroupByReleaseDateYearGetBloc,
                    ActionState<Map<int, int>>
                  >(
                    builder: (final context, final state) {
                      final res =
                          (state
                              is ActionSuccess<Map<int, int>, ReviewStartEnd>)
                          ? state.data
                          : Map<int, int>.unmodifiable({});

                      return StatisticsBarChart<int>(
                        id: 'total-medias-by-release-year',
                        values: SplayTreeMap.from(
                          res.map(
                            (final key, final val) =>
                                MapEntry(key.toString(), val),
                          ),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<
                    ReviewLongestStreakGetBloc,
                    ActionState<SessionStreakDTO>
                  >(
                    builder: (final context, final state) {
                      final res =
                          (state
                              is ActionSuccess<
                                SessionStreakDTO,
                                ReviewStartEnd
                              >)
                          ? state.data
                          : SessionStreakDTO(
                              days: 0,
                              endDate: DateTime.now(),
                              startDate: DateTime.now(),
                            );

                      return buildCard(
                        title: context.localize().longestStreakLabel,
                        value: Text(res.days.toString()),
                      );
                    },
                  ),
                ],
                itemBuilder: (final context, final item, final index) => item,
                itemAspectRatio: 1.5,
                columns: (MediaQuery.sizeOf(context).width / 500).ceil(),
              ),
              const Divider(), // TODO
              CenteredGridList(
                items: [11, 12, 13],
                itemBuilder: (final context, final item, final index) =>
                    Container(
                      color: Colors.red,
                      child: Center(child: Text('$item')),
                    ),
                itemAspectRatio: 2,
                columns: (MediaQuery.sizeOf(context).width / 700).ceil(),
              ),
              const Divider(), // TODO
              CenteredGridList(
                items: [21, 22, 23, 24, 25],
                itemBuilder: (final context, final item, final index) =>
                    Container(
                      color: Colors.red,
                      child: Center(child: Text('$item')),
                    ),
                itemAspectRatio: 2,
                columns: (MediaQuery.sizeOf(context).width / 700).ceil(),
              ),
              const Divider(), // TODO
              CenteredGridList(
                items: [31, 32, 33, 34, 35, 36, 37, 38, 39],
                itemBuilder: (final context, final item, final index) =>
                    Container(
                      color: Colors.red,
                      child: Center(child: Text('$item')),
                    ),
                itemAspectRatio: 2,
                columns: (MediaQuery.sizeOf(context).width / 500).ceil(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildCard({
    required final String title,
    required final Widget value,
  }) {
    return Container(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(title), value],
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
        ],
      ),
    ];
  }
}
