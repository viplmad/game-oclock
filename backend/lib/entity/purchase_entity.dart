import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';

import 'entity.dart';


class PurchaseEntityData {
  PurchaseEntityData._();

  static const String table = 'Purchase';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String descriptionField = 'Description';
  static const String _priceField = 'Price';
  static const String _externalCreditField = 'External Credit';
  static const String _dateField = 'Date';
  static const String _originalPriceField = 'Original Price';

  static const String _storeField = 'Store';

  static const String storeField = _storeField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    descriptionField: String,
    _priceField : double,
    _externalCreditField : double,
    _dateField : DateTime,
    _originalPriceField : double,

    _storeField : int,
  };

  static Query getIdQuery(int id) {

    final Query idQuery = Query();
    idQuery.addAnd(idField, id);

    return idQuery;

  }
}

class PurchaseEntity extends CollectionItemEntity {
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

  static PurchaseEntity fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseEntity(
      id: map[PurchaseEntityData.idField] as int,
      description: map[PurchaseEntityData.descriptionField] as String,
      price: map[PurchaseEntityData._priceField] as double,
      externalCredit: map[PurchaseEntityData._externalCreditField] as double,
      date: map[PurchaseEntityData._dateField] as DateTime?,
      originalPrice: map[PurchaseEntityData._originalPriceField] as double,

      store: map[PurchaseEntityData._storeField] as int?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      PurchaseEntityData.idField : id,
      PurchaseEntityData.descriptionField : description,
      PurchaseEntityData._priceField : price,
      PurchaseEntityData._externalCreditField : externalCredit,
      PurchaseEntityData._dateField : date,
      PurchaseEntityData._originalPriceField : originalPrice,

      PurchaseEntityData._storeField : store,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      PurchaseEntityData.descriptionField : description,
      PurchaseEntityData._priceField : price,
      PurchaseEntityData._externalCreditField : externalCredit,
      PurchaseEntityData._originalPriceField : originalPrice,
    };

    putCreateMapValueNullable(createMap, PurchaseEntityData._dateField, date);
    putCreateMapValueNullable(createMap, PurchaseEntityData._storeField, store);

    return createMap;
  }

  Map<String, dynamic> getUpdateDynamicMap(PurchaseEntity updatedEntity, PurchaseUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, PurchaseEntityData.descriptionField, description, updatedEntity.description);
    putUpdateMapValue(updateMap, PurchaseEntityData._priceField, price, updatedEntity.price);
    putUpdateMapValue(updateMap, PurchaseEntityData._externalCreditField, externalCredit, updatedEntity.externalCredit);
    putUpdateMapValueNullable(updateMap, PurchaseEntityData._dateField, date, updatedEntity.date, updatedValueCanBeNull: updateProperties.dateToNull);
    putUpdateMapValue(updateMap, PurchaseEntityData._originalPriceField, originalPrice, updatedEntity.originalPrice);

    return updateMap;

  }

  static List<PurchaseEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PurchaseEntity> purchasesList = <PurchaseEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PurchaseEntity purchase = PurchaseEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, PurchaseEntityData.table) );

      purchasesList.add(purchase);
    });

    return purchasesList;

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