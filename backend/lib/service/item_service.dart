import 'package:game_collection_client/api.dart' show SearchResultDTO;

abstract class ItemWithImageService<T extends Object, N extends Object> implements ItemService<T, N>, ImageService {}

abstract class ItemService<T extends Object, N extends Object>
    implements SearchService<T> {
  const ItemService();

  bool sameId(T one, T other);

  Future<T> create(N newItem);
  Future<T> get(int id);
  Future<T> update(int id, N updatedItem);
  Future<void> delete(int id);
}

abstract class SearchService<T extends Object> {
  Future<SearchResultDTO<T>> getAll<A>(
    int viewIndex, {
    int? page,
    int? size,
    A? viewArgs,
  });

  Future<SearchResultDTO<T>> searchAll({
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
    String imageName,
    String newImageName,
  );
  Future<void> deleteImage(int id, String imageName);
}
