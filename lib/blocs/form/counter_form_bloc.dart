import 'package:game_oclock/blocs/blocs.dart';

class CounterFormBloc extends FormBloc<CounterFormData, Counter> {
  CounterFormBloc({required super.formGroup});

  @override
  Counter fromDynamicMap(final CounterFormData values) {
    return Counter(
      name: values.name.value.text,
      data: int.tryParse(values.data.value.text) ?? 0,
    );
  }
}
