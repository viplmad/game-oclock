import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        CurrentListSearchGetBloc,
        CurrentListSearchSaveBloc,
        CurrentListStyleGetBloc,
        CurrentListStyleSaveBloc,
        ListReloaded,
        TagDeleteBloc,
        TagListBloc,
        TagSelectBloc,
        UserGameWithTagListBloc;
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/models/models.dart' show ListStyle, Tag;
import 'package:game_oclock/shared/forms/tag_form.dart';
import 'package:game_oclock/shared/list_item/tag_list_item.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'tag_detail.dart';

const String _space = 'tag';

class TagListPage extends StatelessWidget {
  const TagListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TagSelectBloc()),
        BlocProvider(
          create: (_) => TagListBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => CurrentListSearchGetBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => CurrentListSearchSaveBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          ),
        ),
        BlocProvider(
          create: (_) => TagDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => CurrentListStyleGetBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          )..add(ActionStarted.empty()),
        ),
        BlocProvider(
          create: (_) => CurrentListStyleSaveBloc(
            service: RepositoryProvider.of(context),
            space: _space,
          ),
        ),
      ],
      child: const _TagListDetailBuilder(),
    );
  }
}

class _TagListDetailBuilder extends StatelessWidget {
  const _TagListDetailBuilder();

  @override
  Widget build(final BuildContext context) {
    return ListCreateDetailBuilder<Tag, TagSelectBloc, TagListBloc>(
      title: context.localize().tagsTitle,
      searchSpace: _space,
      availableStyles: [ListStyle.tile],
      createFormBuilder: ([final quicksearch]) =>
          TagCreateForm(initialName: quicksearch),
      detailBuilder: (final context, final data, final onClosed) {
        return MultiBlocProvider(
          // Recreate on selection change
          key: Key(data.id),
          providers: [
            BlocProvider(
              create: (_) => UserGameWithTagListBloc(
                service: RepositoryProvider.of(context),
                tagId: data.id,
              ),
            ),
          ],
          child: TagDetail(
            data: data,
            extended: false,
            onBackPressed: onClosed,
            onEditSucceeded: (final context) {
              context.read<TagListBloc>().add(const ListReloaded());
            },
            onDeleteSucceeded: (final context) {
              context.read<TagListBloc>().add(const ListReloaded());
              context.read<TagSelectBloc>().add(
                const ActionStarted(data: null),
              );
            },
          ),
        );
      },
      listItemBuilder: (final context, final style, final data, final onTap) =>
          TagTileListItem(data: data, onTap: onTap),
      itemAspectRatio: 1, // Square aspect ratio
    );
  }
}
