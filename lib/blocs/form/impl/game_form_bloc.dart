import 'package:game_oclock/models/models.dart'
    show ExternalGame, UserGame, UserGameExternalFormData, UserGameFormData;

import '../form.dart' show FormBloc;

class UserGameExternalFormBloc
    extends FormBloc<UserGameExternalFormData, UserGame> {
  UserGameExternalFormBloc({required super.data, required this.externalData});

  final ExternalGame externalData;

  @override
  UserGame fromFormData(final UserGameExternalFormData data) {
    return UserGame(
      id: '', // TODO
      externalIds: [externalData.externalId],
      title: externalData.title,
      edition: externalData.edition ?? '',
      releaseDate: externalData.releaseDate,
      genres: externalData.genres,
      series: externalData.series,
      imageUrl: externalData.imageUrl ?? '',
      status: data.status.value!,
      rating: data.rating.value ?? 0,
      notes: data.notes.value ?? '',
    );
  }

  @override
  void setFormValue(
    final UserGameExternalFormData data,
    final UserGame? value,
  ) {
    data.status.value = value?.status;
    data.rating.value = value?.rating;
    data.notes.value = value?.notes;
  }
}

class UserGameFormBloc extends FormBloc<UserGameFormData, UserGame> {
  UserGameFormBloc({required super.data});

  @override
  UserGame fromFormData(final UserGameFormData data) {
    return UserGame(
      id: '', // TODO
      externalIds: [],
      title: data.title.value!,
      edition: data.edition.value ?? '',
      releaseDate: data.releaseDate.value,
      genres: data.genres.value?.cast() ?? [],
      series: data.series.value?.cast() ?? [],
      imageUrl: '', // TODO
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
