import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

const String IDField = 'ID';

abstract class Entity extends Equatable {

  final int ID;

  Entity({
    @required this.ID
  });

  external Entity copyWith();

  external String getUniqueID();

  external String getTitle();

  String getSubtitle() => null;

  @override
  List<Object> get props => [
    ID
  ];

  @override
  String toString() {

    return 'Entity { '
        'id: $ID'
        ' }';

  }

}