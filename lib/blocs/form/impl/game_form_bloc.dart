import 'package:game_oclock/models/models.dart' show UserGame, UserGameFormData;

import '../form.dart' show FormBloc;

class UserGameFormBloc extends FormBloc<UserGameFormData, UserGame> {
  UserGameFormBloc({required super.data});

  @override
  UserGame fromFormData(final UserGameFormData data) {
    return UserGame(
      id: '', // TODO
      externalIds: [], // TODO
      title: data.title.value!,
      edition: data.edition.value ?? '',
      releaseDate: data.releaseDate.value,
      genres: data.genres.value?.cast() ?? [],
      series: data.series.value?.cast() ?? [],
      coverUrl: '', // TODO
      status: data.status.value!,
      rating: data.rating.value ?? 0,
      notes: data.notes.value ?? '',
    );
  }

  @override
  void setFormValue(final UserGameFormData data, final UserGame? value) {
    data.title.value = value?.title;
    data.edition.value = value?.edition;
    data.releaseDate.value = value?.releaseDate;
    data.status.value = value?.status;
    data.rating.value = value?.rating;
    data.notes.value = value?.notes;
    data.genres.value = value?.genres;
    data.series.value = value?.series;
  }
}
