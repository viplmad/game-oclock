import 'package:game_oclock/models/models.dart' show UserGame, UserGameFormData;

import '../form.dart' show FormBloc;

class UserGameFormBloc extends FormBloc<UserGameFormData, UserGame> {
  UserGameFormBloc({required super.formGroup});

  @override
  UserGame fromData(final UserGameFormData values) {
    return UserGame(
      id: 'kalmdkamsd',
      externalId: 'epic',
      title: values.title.value.text,
      edition: values.edition.value.text,
      releaseDate: DateTime.now(),
      genres: [],
      series: [],
      coverUrl: '',
      status: values.status.value.text,
      rating: int.tryParse(values.rating.value.text) ?? 0,
      notes: values.notes.value.text,
    );
  }
}
