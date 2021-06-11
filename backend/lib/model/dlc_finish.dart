import 'model.dart';


class DLCFinish extends CollectionItemFinish {
  const DLCFinish({
    required DateTime dateTime,
  }) : super(dateTime: dateTime);

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