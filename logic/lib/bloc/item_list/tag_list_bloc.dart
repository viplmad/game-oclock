import 'package:game_oclock_client/api.dart'
    show NewTagDTO, TagDTO, TagPageResult;

import 'package:logic/model/model.dart' show TagView;
import 'package:logic/service/service.dart' show TagService, GameOClockService;

import 'item_list.dart';

class TagListBloc extends ItemListBloc<TagDTO, NewTagDTO, TagService> {
  TagListBloc({
    required GameOClockService collectionService,
    required super.managerBloc,
  }) : super(service: collectionService.tagService);

  @override
  Future<List<TagDTO>> getAllWithView(
    int viewIndex,
    Object? viewArgs, [
    int? page,
  ]) async {
    final TagView view = TagView.values[viewIndex];
    switch (view) {
      case TagView.main:
        final TagPageResult result = await service.getAll(page: page);
        return result.data;
      case TagView.lastAdded:
        final TagPageResult result = await service.getLastAdded(page: page);
        return result.data;
      case TagView.lastUpdated:
        final TagPageResult result = await service.getLastUpdated(page: page);
        return result.data;
    }
  }
}
