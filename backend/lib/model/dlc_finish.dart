import 'model.dart' show ItemFinish;

class DLCFinish extends ItemFinish {
  const DLCFinish({
    required DateTime dateTime,
  }) : super(
          dateTime: dateTime,
          uniqueId: 'DF$dateTime',
        );

  @override
  DLCFinish copyWith({
    DateTime? dateTime,
  }) {
    return DLCFinish(
      dateTime: dateTime ?? this.dateTime,
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
