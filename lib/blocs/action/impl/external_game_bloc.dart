import 'package:game_oclock/models/models.dart' show ExternalGame;

import '../action.dart' show IdentityActionBloc;

class ExternalGameSelectBloc extends IdentityActionBloc<ExternalGame?> {
  @override
  Future<ExternalGame?> doAction(
    final ExternalGame? event,
    final ExternalGame? lastData,
  ) async => event;
}
