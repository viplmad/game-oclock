import 'package:backend/model/model.dart';

import 'entity.dart';


class GameTagEntityData {
  GameTagEntityData._();

  static const String table = 'Tag';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';
}

class GameTagEntity extends ItemEntity {
  const GameTagEntity({
    required int id,
    required this.name,
  }) : super(id: id);

  final String name;

  static GameTagEntity _fromDynamicMap(Map<String, dynamic> map) {

    return GameTagEntity(
      id: map[GameTagEntityData.idField] as int,
      name: map[GameTagEntityData.nameField] as String,
    );

  }

  static List<GameTagEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameTagEntity> tagsList = <GameTagEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameTagEntity tag = GameTagEntity._fromDynamicMap( ItemEntity.combineMaps(manyMap, GameTagEntityData.table) );

      tagsList.add(tag);
    });

    return tagsList;

  }

  static int? idFromDynamicMap(List<Map<String, Map<String, dynamic>>> listMap) {
    int? id;

    if(listMap.isNotEmpty) {
      final Map<String, dynamic> map = ItemEntity.combineMaps(listMap.first, GameTagEntityData.table);
      id = map[GameTagEntityData.idField] as int;
    }

    return id;
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

    return '{$GameTagEntityData.table}Entity { '
        '{$GameTagEntityData.idField}: $id, '
        '{$GameTagEntityData._nameField}: $name'
        ' }';

  }
}