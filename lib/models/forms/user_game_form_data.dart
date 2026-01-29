import 'package:game_oclock/models/models.dart' show FormData, UserGame;
import 'package:reactive_forms/reactive_forms.dart';

class UserGameExternalFormData extends FormData<UserGame> {
  final FormControl<String> status;
  final FormControl<int> rating;
  final FormControl<String> notes;

  UserGameExternalFormData({
    required this.status,
    required this.rating,
    required this.notes,
  }) : super(
         formGroup: FormGroup({
           'status': status,
           'rating': rating,
           'notes': notes,
         }),
       );
}

class UserGameFormData extends FormData<UserGame> {
  final FormControl<String> title;
  final FormControl<String> edition;
  final FormControl<DateTime> releaseDate;
  final FormControl<String> status;
  final FormControl<int> rating;
  final FormControl<String> notes;
  final FormArray<String> genres;
  final FormArray<String> series;

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
           'status': status,
           'rating': rating,
           'notes': notes,
           'genres': genres,
           'series': series,
         }),
       );
}
