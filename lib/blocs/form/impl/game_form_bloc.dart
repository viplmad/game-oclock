import 'package:game_oclock/models/models.dart'
    show UserGameExternalFormData, UserGameFormData;
import 'package:game_oclock_client/api.dart';

import '../form.dart' show FormBloc;

class UserGameExternalFormBloc
    extends FormBloc<UserGameExternalFormData, NewMediaDTO, MediaDTO> {
  UserGameExternalFormBloc({required super.data});

  @override
  NewMediaDTO fromFormData(final UserGameExternalFormData data) {
    return NewMediaDTO(
      media: NewMediaValue(
        source_: data.extenalSource.value!,
        id: data.externalId.value!,
      ),
      state: NewMediaStateDTO(
        status: MediaStatus.fromJson(data.status.value!),
        rating: data.rating.value ?? 0,
        notes: data.notes.value ?? '',
      ),
    );
  }

  @override
  void setFormValue(
    final UserGameExternalFormData data,
    final MediaDTO? value,
  ) {
    data.status.value = value?.state.status.toJson();
    data.rating.value = value?.state.rating;
    data.notes.value = value?.state.notes;
  }
}

class UserGameFormBloc
    extends FormBloc<UserGameFormData, NewMediaDTO, MediaDTO> {
  UserGameFormBloc({required super.data});

  @override
  NewMediaDTO fromFormData(final UserGameFormData data) {
    return NewMediaDTO(
      media: NewMediaValue(
        title: data.title.value!,
        edition: data.edition.value ?? '',
        releaseDate: data.releaseDate.value,
        genres: data.genres.value?.cast() ?? [],
        series: data.series.value?.cast() ?? [],
        imageUrl: '', // TODO
      ),
      state: NewMediaStateDTO(
        status: MediaStatus.fromJson(data.status.value!),
        rating: data.rating.value ?? 0,
        notes: data.notes.value ?? '',
      ),
    );
  }

  @override
  void setFormValue(final UserGameFormData data, final MediaDTO? value) {
    data.title.value = value?.media.title;
    data.edition.value = value?.media.edition;
    data.releaseDate.value = value?.media.releaseDate;
    data.genres.value = value?.media.genres;
    data.series.value = value?.media.series;
    data.status.value = value?.state.status.toJson();
    data.rating.value = value?.state.rating;
    data.notes.value = value?.state.notes;
  }
}
