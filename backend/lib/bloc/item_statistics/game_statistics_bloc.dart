import 'package:backend/entity/entity.dart'
    show GameGeneralStatisticsEntity, GameView, GameYearStatisticsEntity;
import 'package:backend/model/model.dart'
    show GameGeneralStatistics, GameYearStatistics;
import 'package:backend/mapper/mapper.dart' show GameStatisticsMapper;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository, GameStatisticsRepository;

import 'item_statistics.dart';

class GameStatisticsBloc extends ItemStatisticsBloc<GameGeneralStatistics,
    GameYearStatistics, GameStatisticsRepository> {
  GameStatisticsBloc({
    required int viewIndex,
    required int? viewYear,
    required GameCollectionRepository collectionRepository,
  }) : super(
          viewIndex: viewIndex,
          viewYear: viewYear,
          repository: collectionRepository.gameStatisticsRepository,
        );

  @override
  Future<GameGeneralStatistics> getGeneralItemData() {
    final GameView view = GameView.values[viewIndex];
    final Future<GameGeneralStatisticsEntity> entityFuture =
        repository.findGameStatistics(view, viewYear);
    return GameStatisticsMapper.futureGeneralEntityToModel(entityFuture);
  }

  @override
  Future<GameYearStatistics> getYearItemData(LoadYearItemStatistics event) {
    final GameView view = GameView.values[viewIndex];
    final Future<GameYearStatisticsEntity> entityFuture =
        repository.findGameStatisticsFinishYear(view, event.year, viewYear);
    return GameStatisticsMapper.futureYearEntityToModel(entityFuture);
  }
}
