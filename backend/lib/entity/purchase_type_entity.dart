import 'entity.dart' show ItemEntity;


enum PurchaseTypeView {
  Main,
  LastCreated,
}

class PurchaseTypeEntityData {
  PurchaseTypeEntityData._();

  static const String table = 'Type';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
}

class PurchaseTypeID {
  PurchaseTypeID(this.id);

  final int id;
}

class PurchaseTypeEntity extends ItemEntity {
  const PurchaseTypeEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static PurchaseTypeEntity fromMap(Map<String, Object?> map) {

    return PurchaseTypeEntity(
      id: map[PurchaseTypeEntityData.idField] as int,
      name: map[PurchaseTypeEntityData.nameField] as String,
    );

  }

  static PurchaseTypeID idFromMap(Map<String, Object?> map) {

    return PurchaseTypeID(map[PurchaseTypeEntityData.idField] as int);

  }

  PurchaseTypeID createId() {

    return PurchaseTypeID(id);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      PurchaseTypeEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, Object?> updateMap(PurchaseTypeEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

    putUpdateMapValue(updateMap, PurchaseTypeEntityData.nameField, name, updatedEntity.name);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '${PurchaseTypeEntityData.table}Entity { '
        '${PurchaseTypeEntityData.idField}: $id, '
        '${PurchaseTypeEntityData.nameField}: $name'
        ' }';

  }
}