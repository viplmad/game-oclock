import 'package:game_collection/model/model.dart';

import 'entity.dart';


class GameTagEntityData {
  GameTagEntityData._();

  static const String table = 'Tag';
  
  static const String relationField = table + '_ID';

  static const String _nameField = 'Name';

  static const String searchField = _nameField;

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    _nameField : String,
  };
  
  static Map<String, dynamic> getIdMap(int id) {

    return <String, dynamic>{
      idField : id,
    };

  }
}

class GameTagEntity extends CollectionItemEntity {
  const GameTagEntity({
    required int id,
    required this.name,
  }) : super(id: id);

  final String name;

  static GameTagEntity fromDynamicMap(Map<String, dynamic> map) {

    return GameTagEntity(
      id: map[idField] as int,
      name: map[GameTagEntityData._nameField] as String,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      idField : id,
      GameTagEntityData._nameField : name,
    };

  }
  
  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameTagEntityData._nameField : name,
    };

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(GameTagEntity updatedEntity, GameTagUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, GameTagEntityData._nameField, name, updatedEntity.name);

    return updateMap;
    
  }

  static List<GameTagEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameTagEntity> tagsList = <GameTagEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameTagEntity tag = GameTagEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameTagEntityData.table) );

      tagsList.add(tag);
    });

    return tagsList;

  }

  @override
  List<Object> get props => <Object>[
    id,
    name,
  ];

  @override
  String toString() {

    return '{$GameTagEntityData.table}Entity { '
        '$idField: $id, '
        '{$GameTagEntityData._nameField}: $name'
        ' }';

  }
}