import 'package:backend/model/model.dart';

import 'entity.dart';


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

class PurchaseEntity extends ItemEntity {
  const PurchaseEntity({
    required int id,
    required this.description,
    required this.price,
    required this.externalCredit,
    required this.date,
    required this.originalPrice,

    required this.store,
  }) : super(id: id);

  final String description;
  final double price;
  final double externalCredit;
  final DateTime? date;
  final double originalPrice;

  final int? store;

  static PurchaseEntity _fromDynamicMap(Map<String, dynamic> map) {

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

  static List<PurchaseEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PurchaseEntity> purchasesList = <PurchaseEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PurchaseEntity purchase = PurchaseEntity._fromDynamicMap( ItemEntity.combineMaps(manyMap, PurchaseEntityData.table) );

      purchasesList.add(purchase);
    });

    return purchasesList;

  }

  static int? idFromDynamicMap(List<Map<String, Map<String, dynamic>>> listMap) {
    int? id;

    if(listMap.isNotEmpty) {
      final Map<String, dynamic> map = ItemEntity.combineMaps(listMap.first, PurchaseEntityData.table);
      id = map[PurchaseEntityData.idField] as int;
    }

    return id;
  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PurchaseEntityData.descriptionField : description,
      PurchaseEntityData.priceField : price,
      PurchaseEntityData.externalCreditField : externalCredit,
      PurchaseEntityData.originalPriceField : originalPrice,
    };

    putCreateMapValueNullable(createMap, PurchaseEntityData.dateField, date);
    putCreateMapValueNullable(createMap, PurchaseEntityData.storeField, store);

    return createMap;
  }

  Map<String, dynamic> updateMap(PurchaseEntity updatedEntity) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

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

    return '{$PurchaseEntityData.table}Entity { '
        '{$PurchaseEntityData.idField}: $id, '
        '{$PurchaseEntityData._descriptionField}: $description, '
        '{$PurchaseEntityData._priceField}: $price, '
        '{$PurchaseEntityData._externalCreditField}: $externalCredit, '
        '{$PurchaseEntityData._dateField}: $date, '
        '{$PurchaseEntityData._originalPriceField}: $originalPrice'
        ' }';

  }
}