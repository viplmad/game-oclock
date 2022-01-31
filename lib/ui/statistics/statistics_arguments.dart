import 'package:backend/model/model.dart' show Game;


class GameStatisticsArguments extends StatisticsArguments<Game> {
  const GameStatisticsArguments({
    required List<Game> items,
    required String viewTitle,
    required this.tabTitle,
  }) : super(items: items, viewTitle: viewTitle);

  final String tabTitle;
}

class StatisticsArguments<T> {
  const StatisticsArguments({
    required this.items,
    required this.viewTitle,
  });

  final List<T> items;
  final String viewTitle;
}