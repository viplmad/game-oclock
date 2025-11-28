import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionStarted, ReviewYearSelectBloc;
import 'package:game_oclock/components/list/grid_list.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

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
    return NestedScrollView(
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
              items: [1, 2, 3, 4, 5, 6],
              itemBuilder: (final context, final item, final index) =>
                  Container(
                    color: Colors.red,
                    child: Center(child: Text('$item')),
                  ),
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
    );
  }

  List<Widget> _appBarBuilder(
    final BuildContext context,
    final bool innerBoxIsScrolled,
  ) {
    return <Widget>[
      SliverAppBar(
        surfaceTintColor: Theme.of(context).primaryColor,
        // Fixed elevation so background colour doesn't change on scroll
        forceElevated: true,
        elevation: 1.0,
        scrolledUnderElevation: 1.0,
        floating: true,
        pinned: false,
        snap: false,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(title),
          ),
          expandedTitleScale: 1.0,
        ),
      ),
    ];
  }
}
