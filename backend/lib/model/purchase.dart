import 'model.dart' show Item, ItemImage;

class Purchase extends Item {
  const Purchase({
    required this.id,
    required this.description,
    required this.price,
    required this.externalCredit,
    required this.date,
    required this.originalPrice,
    required this.store,
  })  : discount = originalPrice > 0
            ? (1 - (price + externalCredit) / originalPrice)
            : 0,
        super(
          uniqueId: 'Pu$id',
          queryableTerms: description,
        );

  static const bool hasImage = false;

  final int id;
  final String description;
  final double price;
  final double externalCredit;
  final DateTime? date;
  final double originalPrice;
  final double discount;

  final int? store;

  @override
  final ItemImage image = const ItemImage(null, null);

  @override
  Purchase copyWith({
    String? description,
    double? price,
    double? externalCredit,
    DateTime? date,
    double? originalPrice,
    int? store,
  }) {
    return Purchase(
      id: id,
      description: description ?? this.description,
      price: price ?? this.price,
      externalCredit: externalCredit ?? this.externalCredit,
      date: date ?? this.date,
      originalPrice: originalPrice ?? this.originalPrice,
      store: store ?? this.store,
    );
  }

  @override
  List<Object> get props => <Object>[
        id,
        description,
        price,
        externalCredit,
        date ?? DateTime(1970),
        originalPrice,
      ];

  @override
  String toString() {
    return 'Purchase { '
        'Id: $id, '
        'Description: $description, '
        'Price: $price, '
        'External Credit: $externalCredit, '
        'Date: $date, '
        'Original Price: $originalPrice'
        ' }';
  }
}
