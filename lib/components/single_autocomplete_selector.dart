import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ListLoadBloc, ListQuicksearchChanged;
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/utils/text_editing_controller_extension.dart';

class SingleAutocompleteSelectorBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const SingleAutocompleteSelectorBuilder({
    super.key,
    required this.controller,
    this.validator,
    this.decoration,
    required this.itemBuilder,
    required this.keyGetter,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final Widget Function(
    BuildContext context,
    T item,
    int index,
    VoidCallback onSelected,
  )
  itemBuilder;
  final String Function(T item) keyGetter;

  @override
  Widget build(final BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (final textEditingValue) async {
        context.read<LB>().add(
          ListQuicksearchChanged(quicksearch: textEditingValue.text),
        );
        return ['']; // Using BlocBuilder to refreh data
      },
      fieldViewBuilder:
          (
            final context,
            final textEditingController,
            final focusNode,
            final onFieldSubmitted,
          ) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              validator: validator,
              decoration: decoration,
              onFieldSubmitted: (final String value) {
                onFieldSubmitted();
              },
            );
          },
      optionsViewBuilder: (final context, final onSelected, final options) =>
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200.0),
                child: TileListBuilder<T, LB>(
                  space: '', // Avoid extra filtering
                  itemBuilder: (final context, final item, final index) =>
                      itemBuilder(
                        context,
                        item,
                        index,
                        () => onSelected(keyGetter(item)),
                      ),
                ),
              ),
            ),
          ),
      onSelected: (final option) {
        controller.setValue(option);
      },
    );
  }
}
