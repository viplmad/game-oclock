import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionInProgress,
        ActionStarted,
        ActionState,
        ActionSuccess,
        ConsumerActionBloc,
        ListFinal,
        ListLoadBloc,
        ListLoadInProgress,
        ListQuicksearchChanged,
        ListState;
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/components/list/toolbar.dart';
import 'package:game_oclock/components/progress_button_icon.dart';
import 'package:game_oclock/components/show_snackbar.dart';
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
    this.newConfig,
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
  final AutocompleteNewConfig<T, ConsumerActionBloc<T>>? newConfig;

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
                child: ListLayout(
                  toolbar: newConfig?.buildListButton<LB>(
                    onSelected: onSelected,
                  ),
                  child: TileListBuilder<T, LB>(
                    itemBuilder: (final context, final item, final index) =>
                        itemBuilder(
                          context,
                          item,
                          index,
                          () => onSelected(item),
                        ),
                  ),
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

final class AutocompleteNewConfig<
  T extends Object,
  CB extends ConsumerActionBloc<T>
> {
  final T Function(String quicksearch) newBuilder;

  const AutocompleteNewConfig({required this.newBuilder});

  Widget buildListButton<LB extends ListLoadBloc<T>>({
    required final AutocompleteOnSelected<T> onSelected,
  }) {
    return BlocListener<CB, ActionState<void>>(
      listener: (final context, final state) {
        if (state is ActionSuccess<void, T>) {
          showSnackBar(context, message: 'Data created $state'); // TODO i18n
          onSelected(state.event);
        } else if (state is ActionFailure<void, T>) {
          showSnackBar(context, message: 'Error creating $state'); // TODO i18n
        }
      },
      child: BlocBuilder<LB, ListState<T>>(
        builder: (final context, final listState) {
          final quicksearch = (listState is ListFinal<T>)
              ? listState.quicksearch ?? ''
              : (listState is ListLoadInProgress<T>)
              ? listState.quicksearch ?? ''
              : '';

          return BlocBuilder<CB, ActionState<void>>(
            builder: (final context, final createState) {
              final inProgress = createState is ActionInProgress;

              return ListButtonToolbar(
                label: context.localize().createNewDataLabel(quicksearch),
                icon: inProgress ? const ProgressButtonIcon() : CommonIcons.add,
                onTap: inProgress
                    ? null
                    : () {
                        context.read<CB>().add(
                          ActionStarted(data: newBuilder(quicksearch)),
                        );
                      },
              );
            },
          );
        },
      ),
    );
  }
}
