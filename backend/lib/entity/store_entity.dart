import 'entity.dart' show ItemEntity;


enum StoreView {
  Main,
  LastCreated,
}

class StoreEntityData {
  StoreEntityData._();

  static const String table = 'Store';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
  static const String iconField = 'Icon';
}

class StoreID {
  StoreID(this.id);

  final int id;
}

class StoreEntity extends ItemEntity {
  const StoreEntity({
    required this.id,
    required this.name,
    required this.iconFilename,
  });

  final int id;
  final String name;
  final String? iconFilename;

  static StoreEntity fromMap(Map<String, dynamic> map) {

    return StoreEntity(
      id: map[StoreEntityData.idField] as int,
      name: map[StoreEntityData.nameField] as String,
      iconFilename: map[StoreEntityData.iconField] as String?,
    );

  }

  static StoreID idFromMap(Map<String, dynamic> map) {

    return StoreID(map[StoreEntityData.idField] as int);

  }

  StoreID createId() {

    return StoreID(id);

  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      StoreEntityData.nameField : name,
    };

    putCreateMapValueNullable(createMap, StoreEntityData.iconField, iconFilename);

    return createMap;

  }

  Map<String, dynamic> updateMap(StoreEntity updatedEntity) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, StoreEntityData.nameField, name, updatedEntity.name);
    putUpdateMapValueNullable(updateMap, StoreEntityData.iconField, iconFilename, updatedEntity.iconFilename);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '${StoreEntityData.table}Entity { '
        '${StoreEntityData.idField}: $id, '
        '${StoreEntityData.nameField}: $name, '
        '${StoreEntityData.iconField}: $iconFilename'
        ' }';

  }
}