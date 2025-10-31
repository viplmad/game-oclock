import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ListFinal, ListLoadBloc, ListQuicksearchChanged;
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class SingleAutocompleteSelectorBuilder<
  T extends Object,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const SingleAutocompleteSelectorBuilder({
    super.key,
    required this.controller,
    required this.label,
    this.required = false,
    this.readOnly = false,
    this.validator,
    required this.itemBuilder,
    required this.keyGetter,
    this.displayString,
    this.onAddPressed,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
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
    return Autocomplete<T>(
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

        return listState.data; // Using BlocBuilder to refreh data
      },
      fieldViewBuilder:
          (
            final context,
            final textEditingController,
            final focusNode,
            final onFieldSubmitted,
          ) => Form(
            // Scoped to an independent form
            key: GlobalKey<FormState>(),
            child: SimpleTextFormField(
              controller: textEditingController,
              label: label,
              required: required,
              readOnly: readOnly,
              validator: validator,
              suffixIcons: [
                if (onAddPressed != null && controller.text.isNotEmpty)
                  IconButton(
                    tooltip: context.localize().addLabel,
                    icon: CommonIcons.addInline,
                    onPressed: () => onAddPressed!(
                      controller.text,
                      (final option) => controller.setValue(keyGetter(option)),
                    ),
                  ),
              ],
              //
              focusNode: focusNode,
              onFieldSubmitted: (final String value) {
                onFieldSubmitted();
              },
            ),
          ),
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
      onSelected: (final option) {
        controller.setValue(keyGetter(option));
      },
    );
  }
}
