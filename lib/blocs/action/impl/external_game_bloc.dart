import 'package:game_oclock_client/api.dart';

import '../action.dart' show IdentityActionBloc;

class ExternalGameSelectBloc extends IdentityActionBloc<PotentialMediaDTO?> {
  @override
  Future<PotentialMediaDTO?> doAction(
    PotentialMediaDTO? event,
    PotentialMediaDTO? lastData,
  ) async => event;
}
