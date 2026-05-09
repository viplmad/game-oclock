import 'package:game_oclock_client/api.dart';

import '../action.dart' show IdentityActionBloc;

class ExternalGameSelectBloc extends IdentityActionBloc<PotentialMediaDTO?> {
  @override
  Future<PotentialMediaDTO?> doAction(
    final PotentialMediaDTO? event,
    final PotentialMediaDTO? lastData,
  ) async => event;
}
