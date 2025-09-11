import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionStarted,
        ExternalGameListBloc,
        ListLoaded,
        ListQuicksearchChanged,
        ListReloaded,
        ListStyleBloc,
        UserGameAvailableListBloc,
        UserGameDeleteBloc,
        UserGameListBloc,
        UserGameSelectBloc,
        UserGameTagListBloc;
import 'package:game_oclock/components/list/list_item.dart'
    show GridListItem, TileListItem;
import 'package:game_oclock/components/list/tile_list.dart';
import 'package:game_oclock/components/list_detail.dart' show ListDetailBuilder;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ExternalGame, ListSearch, ListStyle, SearchDTO, UserGame;
import 'package:game_oclock/utils/localisation_extension.dart';

import 'game_detail.dart';

class UserGameListPage extends StatelessWidget {
  const UserGameListPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserGameSelectBloc()),
        BlocProvider(
          create: (_) => UserGameListBloc()
            ..add(
              ListLoaded(
                search: ListSearch(name: 'default', search: SearchDTO()),
              ),
            ),
        ),
        BlocProvider(create: (_) => UserGameDeleteBloc()),
        BlocProvider(
          create: (_) => ListStyleBloc()
            ..add(
              const ActionStarted(
                data: ListStyle.grid,
              ), // TODO get from localstorage
            ),
        ),
      ],
      child: ListDetailBuilder<UserGame, UserGameSelectBloc, UserGameListBloc>(
        title: context.localize().gamesTitle,
        searchSpace: 'game',
        floatingActionButton: FloatingActionButton(
          tooltip: context.localize().addLabel,
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (final context) {
                final read =
                    ExternalGameListBloc(
                      igdbService: RepositoryProvider.of(context),
                    )..add(
                      ListLoaded(
                        search: ListSearch(
                          name: 'default',
                          search: SearchDTO(),
                        ),
                      ),
                    );
                return BlocProvider(
                  create: (_) => read,
                  child: Dialog(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560.0),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DefaultTextStyle(
                              style:
                                  DialogTheme.of(context).titleTextStyle ??
                                  Theme.of(context).textTheme.headlineSmall!,
                              textAlign: TextAlign.start,
                              child: Text('Search external'),
                            ),
                            const SizedBox(height: 16.0),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Autocomplete<String>(
                                  optionsBuilder:
                                      (final textEditingValue) async {
                                        read.add(
                                          ListQuicksearchChanged(
                                            quicksearch: textEditingValue.text,
                                          ),
                                        );
                                        return [''];
                                      },
                                  optionsViewBuilder:
                                      (
                                        final context,
                                        final onSelected,
                                        final options,
                                      ) => Align(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Material(
                                          elevation: 4.0,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 200.0,
                                            ),
                                            child:
                                                TileListBuilder<
                                                  ExternalGame,
                                                  ExternalGameListBloc
                                                >(
                                                  space: '',
                                                  itemBuilder:
                                                      (
                                                        final context,
                                                        final item,
                                                        final index,
                                                      ) => TileListItem(
                                                        title: item.title,
                                                        subtitle: item
                                                            .releaseDate
                                                            ?.toIso8601String(),
                                                        imageURL: item.coverUrl,
                                                        trailing: const Icon(
                                                          Icons.cloud,
                                                        ), // TODO icon of external source
                                                        onTap: () => onSelected(
                                                          item.title,
                                                        ),
                                                      ),
                                                ),
                                          ),
                                        ),
                                      ),
                                  onSelected: (final String selection) {
                                    print('You just selected $selection');
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: OverflowBar(
                                    alignment: MainAxisAlignment.end,
                                    spacing: 16 / 2,
                                    overflowAlignment: OverflowBarAlignment.end,
                                    overflowDirection: VerticalDirection.down,
                                    overflowSpacing: 0,
                                    children: [
                                      TextButton(
                                        onPressed: () async =>
                                            await Navigator.maybePop(context),
                                        child: Text(
                                          context.localize().cancelLabel,
                                        ),
                                      ),
                                      TextButton.icon(
                                        label: Text(
                                          context.localize().saveLabel,
                                        ),
                                        onPressed: () {}, // TODO
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).then((final bool? success) {
              if (success != null && success && context.mounted) {
                // TODO
              }
            });
          },
          child: const Icon(CommonIcons.add),
        ),
        detailBuilder: (final context, final data, final onClosed) {
          return MultiBlocProvider(
            // Recreate on selection change
            key: Key(data.id),
            providers: [
              BlocProvider(
                create: (_) => UserGameAvailableListBloc(gameId: data.id),
              ),
              BlocProvider(create: (_) => UserGameTagListBloc(gameId: data.id)),
            ],
            child: UserGameDetail(
              data: data,
              extended: false,
              onBackPressed: onClosed,
              onEditSucceeded: (final context) {
                context.read<UserGameListBloc>().add(const ListReloaded());
              },
              onDeleteSucceeded: (final context) {
                context.read<UserGameListBloc>().add(const ListReloaded());
                context.read<UserGameSelectBloc>().add(
                  const ActionStarted(data: null),
                );
              },
            ),
          );
        },
        listItemBuilder:
            (final context, final style, final data, final onPressed) =>
                style == ListStyle.grid
                ? GridListItem(
                    title: data.edition.isEmpty
                        ? data.title
                        : context.localize().gameEditionDataTitle(
                            data.title,
                            data.edition,
                          ),
                    imageURL: data.coverUrl,
                    onTap: onPressed,
                  )
                : TileListItem(
                    title: data.edition.isEmpty
                        ? data.title
                        : context.localize().gameEditionDataTitle(
                            data.title,
                            data.edition,
                          ),
                    imageURL: data.coverUrl,
                    onTap: onPressed,
                  ),
      ),
    );
  }
}
