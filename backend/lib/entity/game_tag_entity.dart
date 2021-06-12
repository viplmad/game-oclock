import 'package:backend/model/model.dart';
import 'package:backend/query/query.dart';
import 'package:backend/query/fields.dart';

import 'entity.dart';


class GameTagEntityData {
  GameTagEntityData._();

  static const String table = 'Tag';

  static const Map<TagView, String> viewToTable = <TagView, String>{
    TagView.Main : 'Tag-Main',
    TagView.LastCreated : 'Tag-Last Created',
  };

  static const String relationField = table + '_ID';

  static const String idField = 'ID';
  static const String nameField = 'Name';

  static Fields fields() {

    final Fields fields = Fields();
    fields.add(idField, int);
    fields.add(nameField, String);

    return fields;

  }

  static Query idQuery(int id) {

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

  static GameTagEntity _fromDynamicMap(Map<String, dynamic> map) {

    return GameTagEntity(
      id: map[GameTagEntityData.idField] as int,
      name: map[GameTagEntityData.nameField] as String,
    );

  }

  static List<GameTagEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    final List<GameTagEntity> tagsList = <GameTagEntity>[];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      final GameTagEntity tag = GameTagEntity._fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, GameTagEntityData.table) );

      tagsList.add(tag);
    });

    return tagsList;

  }

  Map<String, dynamic> createDynamicMap() {

    final Map<String, dynamic> createMap = <String, dynamic>{
      GameTagEntityData.nameField : name,
    };

    return createMap;

  }

  Map<String, dynamic> updateDynamicMap(GameTagEntity updatedEntity, GameTagUpdateProperties updateProperties) {

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