import 'entity.dart' show ItemEntity;


enum GameTagView {
  main,
  lastCreated,
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

  @override
  String toString() => '$id';
}

class GameTagEntity extends ItemEntity {
  const GameTagEntity({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static GameTagEntity fromMap(Map<String, Object?> map) {

    return GameTagEntity(
      id: map[GameTagEntityData.idField] as int,
      name: map[GameTagEntityData.nameField] as String,
    );

  }

  static GameTagID idFromMap(Map<String, Object?> map) {

    return GameTagID(map[GameTagEntityData.idField] as int);

  }

  GameTagID createId() {

    return GameTagID(id);

  }

  Map<String, Object?> createMap() {

    final Map<String, Object?> createMap = <String, Object?>{
      GameTagEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, Object?> updateMap(GameTagEntity updatedEntity) {

    final Map<String, Object?> updateMap = <String, Object?>{};

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