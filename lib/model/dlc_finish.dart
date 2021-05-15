import 'package:game_collection/entity/entity.dart';

import 'model.dart';


class DLCFinish extends CollectionItemFinish {
  const DLCFinish({
    required DateTime dateTime,
  }) : super(dateTime: dateTime);

  static DLCFinish fromEntity(DLCFinishEntity entity) {

    return DLCFinish(
      dateTime: entity.dateTime,
    );

  }

  DLCFinishEntity toEntity() {

    return DLCFinishEntity(
      dateTime: this.dateTime,
    );

  }

  DLCFinish copyWith({
    DateTime? dateTime,
  }) {

    return DLCFinish(
      dateTime: dateTime?? this.dateTime,
    );

  }

  @override
  List<Object> get props => <Object>[
    dateTime,
  ];

  @override
  String toString() {

    return 'DLCFinish { '
        'DateTime: $dateTime'
        ' }';

  }
}