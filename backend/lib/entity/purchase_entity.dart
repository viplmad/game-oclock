import 'entity.dart' show ItemEntity;


enum PurchaseView {
  Main,
  LastCreated,
  Pending,
  LastPurchased,
  Review,
}

class PurchaseEntityData {
  PurchaseEntityData._();

  static const String table = 'Purchase';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String descriptionField = 'Description';
  static const String priceField = 'Price';
  static const String externalCreditField = 'External Credit';
  static const String dateField = 'Date';
  static const String originalPriceField = 'Original Price';

  static const String storeField = 'Store';
}

class PurchaseID {
  PurchaseID(this.id);

  final int id;

  @override
  String toString() => '$id';
}

class PurchaseEntity extends ItemEntity {
  const PurchaseEntity({
    required this.id,
    required this.description,
    required this.price,
    required this.externalCredit,
    required this.date,
    required this.originalPrice,

    required this.store,
  });

  final int id;
  final String description;
  final double price;
  final double externalCredit;
  final DateTime? date;
  final double originalPrice;

  final int? store;

  static PurchaseEntity fromMap(Map<String, Object?> map) {

    return PurchaseEntity(
      id: map[PurchaseEntityData.idField] as int,
      description: map[PurchaseEntityData.descriptionField] as String,
      price: map[PurchaseEntityData.priceField] as double,
      externalCredit: map[PurchaseEntityData.externalCreditField] as double,
      date: map[PurchaseEntityData.dateField] as DateTime?,
      originalPrice: map[PurchaseEntityData.originalPriceField] as double,

      store: map[PurchaseEntityData.storeField] as int?,
    );

  }

  static PurchaseID idFromMap(Map<String, Object?> map) {

    return PurchaseID(map[PurchaseEntityData.idField] as int);

  }

  PurchaseID createId() {

    return PurchaseID(id);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      PurchaseEntityData.descriptionField : description,
      PurchaseEntityData.priceField : price,
      PurchaseEntityData.externalCreditField : externalCredit,
      PurchaseEntityData.originalPriceField : originalPrice,
    };

    putCreateMapValueNullable(createMap, PurchaseEntityData.dateField, date);
    putCreateMapValueNullable(createMap, PurchaseEntityData.storeField, store);

    return createMap;
  }

  Map<String, Object?> updateMap(PurchaseEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(updateMap, PurchaseEntityData.descriptionField, description, updatedEntity.description);
    putUpdateMapValue(updateMap, PurchaseEntityData.priceField, price, updatedEntity.price);
    putUpdateMapValue(updateMap, PurchaseEntityData.externalCreditField, externalCredit, updatedEntity.externalCredit);
    putUpdateMapValueNullable(updateMap, PurchaseEntityData.dateField, date, updatedEntity.date);
    putUpdateMapValue(updateMap, PurchaseEntityData.originalPriceField, originalPrice, updatedEntity.originalPrice);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    description,
  ];

  @override
  String toString() {

    return '${PurchaseEntityData.table}Entity { '
        '${PurchaseEntityData.idField}: $id, '
        '${PurchaseEntityData.descriptionField}: $description, '
        '${PurchaseEntityData.priceField}: $price, '
        '${PurchaseEntityData.externalCreditField}: $externalCredit, '
        '${PurchaseEntityData.dateField}: $date, '
        '${PurchaseEntityData.originalPriceField}: $originalPrice'
        ' }';

  }
}