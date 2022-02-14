import 'package:backend/model/model.dart' show Item;

class DetailArguments<T extends Item> {
  const DetailArguments({
    required this.item,
    this.onUpdate,
  });

  final T item;
  final void Function(T? item)? onUpdate;
}
