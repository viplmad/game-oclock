import 'package:game_collection/entity/entity.dart';

import 'model.dart';


class GameFinish extends CollectionItemFinish {
  const GameFinish({
    required DateTime dateTime,
  }) : super(dateTime: dateTime);

  static GameFinish fromEntity(GameFinishEntity entity) {

    return GameFinish(
      dateTime: entity.dateTime,
    );

  }

  GameFinishEntity toEntity() {

    return GameFinishEntity(
      dateTime: this.dateTime,
    );

  }

  GameFinish copyWith({
    DateTime? dateTime,
  }) {

    return GameFinish(
      dateTime: dateTime?? this.dateTime,
    );

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return 'GameFinish { '
        'DateTime: $dateTime'
        ' }';

  }
}