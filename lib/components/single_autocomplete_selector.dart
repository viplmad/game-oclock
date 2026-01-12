import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionInProgress,
        ActionStarted,
        ActionState,
        ActionSuccess,
        FunctionActionBloc,
        ListFinal,
        ListLoadBloc,
        ListQuicksearchChanged;
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/components/progress_button_icon.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';

class SingleAutocompleteSelectorBuilder<
  T extends Object,
  GB extends FunctionActionBloc<String, T>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const SingleAutocompleteSelectorBuilder({
    super.key,
    required this.formControl,
    required this.label,
    this.readOnly = false,
    required this.itemBuilder,
    required this.keyGetter,
    this.displayString,
    this.onAddPressed,
  });

  final FormControl<String> formControl;
  final String label;
  final bool readOnly;
  final Widget Function(
    BuildContext context,
    T item,
    int index,
    VoidCallback onSelected,
  )
  itemBuilder;
  final String Function(T item) keyGetter;
  final String Function(T item)? displayString;
  final void Function(String value, ValueChanged<T> onSelected)? onAddPressed;

  @override
  Widget build(final BuildContext context) {
    final initialValue = formControl.defaultValue;
    if (initialValue != null) {
      context.read<GB>().add(ActionStarted(data: initialValue));
      return BlocConsumer<GB, ActionState<T>>(
        listener: (final context, final state) {
          if (state is ActionFailure<T, String>) {
            showErrorSnackBar(
              context,
              name: 'TODO', // TODO
              error: state.error,
            );
          }
        },
        builder: (final context, final state) {
          T? data;
          if (state is ActionInProgress<T>) {
            return SimpleTextFormField(
              formControl: FormControl<String>(value: initialValue),
              label: label,
              readOnly: true,
              prefixIcon: const ProgressButtonIcon(),
            );
          } else if (state is ActionFinal<T, String>) {
            data = (state is ActionSuccess<T, String>) ? state.data : null;
          } else {
            return const SizedBox();
          }

          return _rawAutocomplete(context, initialValue: data);
        },
      );
    }

    return _rawAutocomplete(context);
  }

  ReactiveRawAutocomplete<String, T> _rawAutocomplete(
    final BuildContext context, {
    final T? initialValue,
  }) {
    return ReactiveRawAutocomplete<String, T>(
      formControl: formControl,
      valueAccessor: _AutocompleteValueAccessor<T>(
        keyGetter: keyGetter,
        getter: (_) => initialValue,
      ),
      fieldViewBuilder:
          (
            final context,
            final textEditingController,
            final focusNode,
            final onFieldSubmitted,
          ) {
            final queryFormControl = FormControl<String>(
              value: textEditingController.text,
            );
            return SimpleTextFormField(
              formControl: queryFormControl,
              label: label,
              readOnly: readOnly,
              suffixIcons: [
                if (onAddPressed != null && formControl.isNotNullOrEmpty)
                  IconButton(
                    tooltip: context.localize().createLabel,
                    icon: CommonIcons.addInline,
                    onPressed: () => onAddPressed!(
                      formControl.value!,
                      (final option) => formControl.value = keyGetter(option),
                    ),
                  ),
              ],
              onChanged: (final value) => textEditingController.value =
                  textEditingController.value.copyWith(text: value),
              //
              focusNode: focusNode,
              onFieldSubmitted: (final String value) {
                onFieldSubmitted();
              },
            );
          },
      optionsBuilder: (final textEditingValue) async {
        final loadBloc = context.read<LB>();
        loadBloc.add(
          ListQuicksearchChanged(quicksearch: textEditingValue.text),
        );

        final listState =
            await loadBloc.stream.firstWhere(
                  (final loadState) => loadState is ListFinal<T>,
                )
                as ListFinal<T>;

        return listState.data; // Using BlocBuilder to refresh data
      },
      displayStringForOption: displayString ?? keyGetter,
      optionsViewBuilder: (final context, final onSelected, final options) =>
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200.0),
                child: TileListBuilder<T, LB>(
                  itemBuilder: (final context, final item, final index) =>
                      itemBuilder(context, item, index, () => onSelected(item)),
                ),
              ),
            ),
          ),
    );
  }
}

class _AutocompleteValueAccessor<T> extends ControlValueAccessor<String, T> {
  _AutocompleteValueAccessor({required this.keyGetter, this.getter});

  final String Function(T item) keyGetter;
  final T? Function(String id)? getter;

  @override
  String viewToModelValue(final T? modelValue) {
    return modelValue == null ? '' : keyGetter(modelValue);
  }

  @override
  T? modelToViewValue(final String? viewValue) {
    return (viewValue == '' || viewValue == null)
        ? null
        : getter?.call(viewValue);
  }
}
