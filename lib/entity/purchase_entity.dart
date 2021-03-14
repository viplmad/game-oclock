import 'entity.dart';


const purchaseTable = 'Purchase';

const List<String> purchaseFields = [
  IdField,
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
      id: map[IdField],
      description: map[purc_descriptionField],
      price: map[purc_priceField],
      externalCredit: map[purc_externalCreditField],
      date: map[purc_dateField],
      originalPrice: map[purc_originalPriceField],

      store: map[purc_storeField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IdField : id,
      purc_descriptionField : description,
      purc_priceField : price,
      purc_externalCreditField : externalCredit,
      purc_dateField : date,
      purc_originalPriceField : originalPrice,

      purc_storeField : store,
    };

  }

  static List<PurchaseEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<PurchaseEntity> purchasesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      PurchaseEntity purchase = PurchaseEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, purchaseTable) );

      purchasesList.add(purchase);
    });

    return purchasesList;

  }

  @override
  List<Object> get props => [
    id,
    description,
  ];

  @override
  String toString() {

    return '{$purchaseTable}Entity { '
        '$IdField: $id, '
        '$purc_descriptionField: $description, '
        '$purc_priceField: $price, '
        '$purc_externalCreditField: $externalCredit, '
        '$purc_dateField: $date, '
        '$purc_originalPriceField: $originalPrice'
        ' }';

  }
}