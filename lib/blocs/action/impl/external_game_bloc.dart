import 'package:game_oclock/models/models.dart' show ExternalGame;

import '../action.dart' show FunctionActionBloc;

class ExternalGameGetBloc extends FunctionActionBloc<String, ExternalGame> {
  ExternalGameGetBloc();

  @override
  Future<ExternalGame> doAction(
    final String event,
    final ExternalGame? lastData,
  ) async => ExternalGame(
    source: '',
    id: event,
    title: event,
    edition: null,
    imageUrl: null,
    releaseDate: null,
  );
}
