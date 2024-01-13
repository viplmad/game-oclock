import 'package:game_oclock_client/api.dart' show PrimaryModel;

class ItemFinish extends PrimaryModel {
  ItemFinish(this.date) : super(id: date.toIso8601String());

  final DateTime date;
}
