import 'package:game_oclock/models/models.dart' show UserGame, UserGameFormData;

import '../form.dart' show FormBloc;

class UserGameFormBloc extends FormBloc<UserGameFormData, UserGame> {
  UserGameFormBloc({required super.formGroup});

  @override
  UserGame fromData(final UserGameFormData values) {
    return UserGame(
      id: 'kalmdkamsd', // TODO
      externalId: 'epic', // TODO
      title: values.title.text,
      edition: values.edition.text,
      releaseDate: DateTime.now(),
      genres: [],
      series: [],
      coverUrl: '',
      status: values.status.text,
      rating: int.tryParse(values.rating.text) ?? 0,
      notes: values.notes.text,
    );
  }
}
