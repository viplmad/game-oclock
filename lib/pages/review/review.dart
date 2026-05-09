import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionStarted,
        ActionState,
        ActionSuccess,
        ReviewTotalFirstMediasGetBloc,
        ReviewTotalMediasGetBloc,
        ReviewTotalSessionsGetBloc,
        ReviewTotalTimeGetBloc,
        ReviewYearSelectBloc;
import 'package:game_oclock/components/full_search_app_bar.dart';
import 'package:game_oclock/components/list/grid_list.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
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

          context.read<ReviewTotalSessionsGetBloc>().add(
            ActionStarted(
              data: ListSearchDTO(
                filter: buildStartDateBetweenFilters(context, currentYear),
              ),
            ),
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
                      final res = (state is ActionSuccess<int, ListSearchDTO>)
                          ? state.data
                          : 0;

                      return Container(
                        color: Colors.red,
                        child: Center(child: Text('Total $res')),
                      );
                    },
                  ),
                  Container(
                    color: Colors.red,
                    child: Center(child: Text('1')),
                  ),
                  Container(
                    color: Colors.red,
                    child: Center(child: Text('2')),
                  ),
                  Container(
                    color: Colors.red,
                    child: Center(child: Text('3')),
                  ),
                  Container(
                    color: Colors.red,
                    child: Center(child: Text('4')),
                  ),
                  Container(
                    color: Colors.red,
                    child: Center(child: Text('5')),
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

  List<FilterDTO> buildStartDateBetweenFilters(
    final BuildContext context,
    final int year,
  ) {
    return List.unmodifiable(<FilterDTO>[
      FilterDTO(
        field: 'start_date',
        operator_: OperatorType.gte,
        value: SearchValue(
          value: context.localize().toISOString(DateTime(year)),
        ),
        chainOperator: ChainOperatorType.and,
      ),
      FilterDTO(
        field: 'start_date',
        operator_: OperatorType.lt,
        value: SearchValue(
          value: context.localize().toISOString(DateTime(year + 1)),
        ),
        chainOperator: ChainOperatorType.and,
      ),
    ]);
  }

  List<Widget> _appBarBuilder(
    final BuildContext context,
    final bool innerBoxIsScrolled,
  ) {
    return <Widget>[SimpleSliverAppBar(title: Text(title))];
  }
}
