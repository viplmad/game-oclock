import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ExternalGameListBloc, ListQuicksearchChanged;
import 'package:game_oclock/components/list/list_item.dart' show TileListItem;
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/models/models.dart' show ExternalGame;

class ExternalGameSelectBuilder extends StatelessWidget {
  const ExternalGameSelectBuilder({
    super.key,
    required this.controller,
    this.validator,
    this.decoration,
  });

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;

  @override
  Widget build(final BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (final textEditingValue) async {
        context.read<ExternalGameListBloc>().add(
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
                child: TileListBuilder<ExternalGame, ExternalGameListBloc>(
                  space: '',
                  itemBuilder: (final context, final item, final index) =>
                      TileListItem(
                        title: item.title,
                        subtitle: item.releaseDate?.toIso8601String(),
                        imageURL: item.coverUrl,
                        trailing: const Icon(
                          Icons.cloud,
                        ), // TODO icon of external source
                        onTap: () => onSelected(item.title),
                      ),
                ),
              ),
            ),
          ),
      onSelected: (final option) {
        controller.value = controller.value.copyWith(text: option);
      },
    );
  }
}
