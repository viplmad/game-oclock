import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';

import 'entity.dart';


class GameTagEntityData {
  GameTagEntityData._();

  static const String table = 'Tag';

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';

  static const Map<String, Type> fields = <String, Type>{
    idField : int,
    nameField : String,
  };

  static Query getIdQuery(int id) {

    final Query idQuery = Query();
    idQuery.addAnd(idField, id);

    return idQuery;

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
      id: map[GameTagEntityData.idField] as int,
      name: map[GameTagEntityData.nameField] as String,
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      GameTagEntityData.idField : id,
      GameTagEntityData.nameField : name,
    };

  }

  @override
  Map<String, dynamic> getCreateDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameTagEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, dynamic> getUpdateDynamicMap(GameTagEntity updatedEntity, GameTagUpdateProperties updateProperties) {

    final Map<String, dynamic> updateMap = <String, dynamic>{};

    putUpdateMapValue(updateMap, GameTagEntityData.nameField, name, updatedEntity.name);

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
        '{$GameTagEntityData.idField}: $id, '
        '{$GameTagEntityData._nameField}: $name'
        ' }';

  }
}