import 'package:game_collection_client/api.dart' show PrimaryModel;

class ItemFinish extends PrimaryModel {
  ItemFinish(this.date) : super(id: date.millisecondsSinceEpoch);

  final DateTime date;
}
