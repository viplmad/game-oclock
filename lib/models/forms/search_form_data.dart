import 'package:game_oclock/models/models.dart' show FormData, ListSearch;
import 'package:reactive_forms/reactive_forms.dart';

class SearchFormData extends FormData<ListSearch> {
  final FormControl<String> name;
  final FormArray<dynamic> filters; // TODO

  SearchFormData({required this.name, required this.filters})
    : super(formGroup: FormGroup({'name': name, 'filters': filters}));
}
