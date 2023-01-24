import 'package:game_collection_client/api.dart'
    show ApiException, PageResultDTO;

import 'package:logic/utils/http_status.dart';

abstract class ItemWithImageService<T extends Object, N extends Object>
    implements ItemService<T, N>, ImageService {}

abstract class ItemService<T extends Object, N extends Object>
    implements SearchService<T> {
  const ItemService();

  Future<T> create(N newItem);
  Future<T> get(int id);
  Future<T> update(int id, N updatedItem);
  Future<void> delete(int id);
}

abstract class SearchService<T extends Object> {
  Future<PageResultDTO<T>> getAll({
    int? page,
    int? size,
  });

  Future<PageResultDTO<T>> getLastAdded({
    int? page,
    int? size,
  });

  Future<PageResultDTO<T>> getLastUpdated({
    int? page,
    int? size,
  });

  Future<PageResultDTO<T>> searchAll({
    String? quicksearch,
    int? page,
    int? size,
  });
}

abstract class SecondaryItemService<ID extends Object, T extends Object> {
  const SecondaryItemService();

  Future<void> create(int primaryId, T newItem);
  Future<List<T>> getAll(int primaryId);
  Future<void> delete(int primaryId, ID id);
}

abstract class ImageService {
  const ImageService();

  Future<void> uploadImage(
    int id,
    String uploadImagePath,
  );
  Future<void> renameImage(
    int id,
    String newImageName,
  );
  Future<void> deleteImage(int id);
}

Future<T?> nullIfNotFound<T>(Future<T> future) async {
  try {
    return await future;
  } on ApiException catch (e) {
    if (e.code == HttpStatus.notFound) {
      return null;
    }

    rethrow;
  }
}

Future<T> defaultIfNotFound<T>(Future<T> future, T defaultValue) async {
  try {
    return await future;
  } on ApiException catch (e) {
    if (e.code == HttpStatus.notFound) {
      return defaultValue;
    }

    rethrow;
  }
}
