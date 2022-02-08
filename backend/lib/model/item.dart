import 'package:equatable/equatable.dart';


abstract class Item extends Equatable {
  const Item({
    required this.uniqueId,
    required this.hasImage,
    required this.queryableTerms,
  });

  final String uniqueId;
  final bool hasImage;
  final String queryableTerms;

  ItemImage get image;

  Item copyWith();
}

abstract class ItemFinish extends Item {
  const ItemFinish({
    required this.dateTime,
    required String uniqueId,
  }) : super(
    uniqueId: uniqueId,
    hasImage: false,
    queryableTerms: '',
  );

  final DateTime dateTime;

  @override
  final ItemImage image = const ItemImage(null, null);
}

class ItemImage {
  const ItemImage(String? url, String? filename)
      : url = url?? '',
        filename = filename?? '';

  final String url;
  final String filename;
}

abstract class ItemStatistics extends Equatable {
  const ItemStatistics();
}