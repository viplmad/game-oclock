import 'package:game_oclock/models/models.dart' show FormData;
import 'package:game_oclock_client/api.dart';
import 'package:reactive_forms/reactive_forms.dart';

class UserGameExternalFormData extends FormData<NewMediaDTO> {
  final FormControl<String> extenalSource;
  final FormControl<String> externalId;
  final FormControl<String> status;
  final FormControl<int> rating;
  final FormControl<String> notes;

  UserGameExternalFormData({
    required this.extenalSource,
    required this.externalId,
    required this.status,
    required this.rating,
    required this.notes,
  }) : super(
         formGroup: FormGroup({
           'externalSource': extenalSource,
           'externalId': externalId,
           'status': status,
           'rating': rating,
           'notes': notes,
         }),
       );
}

class UserGameFormData extends FormData<NewMediaDTO> {
  final FormControl<String> title;
  final FormControl<String> edition;
  final FormControl<DateTime> releaseDate;
  final FormArray<String> genres;
  final FormArray<String> series;
  final FormControl<String> status;
  final FormControl<int> rating;
  final FormControl<String> notes;

  UserGameFormData({
    required this.title,
    required this.edition,
    required this.releaseDate,
    required this.status,
    required this.rating,
    required this.notes,
    required this.genres,
    required this.series,
  }) : super(
         formGroup: FormGroup({
           'title': title,
           'edition': edition,
           'releaseDate': releaseDate,
           'genres': genres,
           'series': series,
           'status': status,
           'rating': rating,
           'notes': notes,
         }),
       );
}
