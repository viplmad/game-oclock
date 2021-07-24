import 'entity.dart' show ItemEntity;


enum TagView {
  Main,
  LastCreated,
}

class GameTagEntityData {
  GameTagEntityData._();

  static const String table = 'Tag';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
}

class GameTagID {
  GameTagID(this.id);

  final int id;
}

class GameTagEntity extends ItemEntity {
  const GameTagEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static GameTagEntity fromMap(Map<String, dynamic> map) {

    return GameTagEntity(
      id: map[GameTagEntityData.idField] as int,
      name: map[GameTagEntityData.nameField] as String,
    );

  }

  static GameTagID idFromMap(Map<String, dynamic> map) {

    return GameTagID(map[GameTagEntityData.idField] as int);

  }

  GameTagID createId() {

    return GameTagID(id);

  }

  Map<String, dynamic> createMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameTagEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, dynamic> updateMap(GameTagEntity updatedEntity) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, GameTagEntityData.nameField, name, updatedEntity.name);

    return updateMap;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '${GameTagEntityData.table}Entity { '
        '${GameTagEntityData.idField}: $id, '
        '${GameTagEntityData.nameField}: $name'
        ' }';

  }
}