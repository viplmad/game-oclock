import 'entity.dart';


const String purchaseTable = 'Purchase';

const List<String> purchaseFields = <String>[
  idField,
  purc_descriptionField,
  purc_priceField,
  purc_externalCreditField,
  purc_dateField,
  purc_originalPriceField,
  purc_storeField,
];

const String purc_descriptionField = 'Description';
const String purc_priceField = 'Price';
const String purc_externalCreditField = 'External Credit';
const String purc_dateField = 'Date';
const String purc_originalPriceField = 'Original Price';
const String purc_discountField = 'Discount';

const String purc_storeField = 'Store';

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
      id: map[idField] as int,
      description: map[purc_descriptionField] as String,
      price: map[purc_priceField] as double,
      externalCredit: map[purc_externalCreditField] as double,
      date: map[purc_dateField] as DateTime?,
      originalPrice: map[purc_originalPriceField] as double,

      store: map[purc_storeField] as int?,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      purc_descriptionField : description,
      purc_priceField : price,
      purc_externalCreditField : externalCredit,
      purc_dateField : date,
      purc_originalPriceField : originalPrice,

      purc_storeField : store,
    };

  }

  static List<PurchaseEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<PurchaseEntity> purchasesList = <PurchaseEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final PurchaseEntity purchase = PurchaseEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, purchaseTable) );

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

    return '{$purchaseTable}Entity { '
        '$idField: $id, '
        '$purc_descriptionField: $description, '
        '$purc_priceField: $price, '
        '$purc_externalCreditField: $externalCredit, '
        '$purc_dateField: $date, '
        '$purc_originalPriceField: $originalPrice'
        ' }';

  }
}