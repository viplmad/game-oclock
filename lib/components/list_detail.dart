import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/action/action_state.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionRestarted,
        ActionStarted,
        ActionState,
        CurrentListSearchGetBloc,
        CurrentListSearchSaveBloc,
        CurrentListStyleGetBloc,
        CurrentListStyleSaveBloc,
        IdentityActionBloc,
        ListLoadBloc,
        ListLoadSuccess,
        ListQuicksearchChanged,
        ListReloaded,
        ListSearchChanged,
        ListState,
        MinimizedLayoutBloc;
import 'package:game_oclock/components/list/toolbar.dart';
import 'package:game_oclock/constants/constants.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show
        LayoutTier,
        ListSearch,
        ListStyle,
        OptionField,
        OptionTextField,
        defaultListStyle;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock_client/api.dart';

import 'full_search_app_bar.dart';
import 'list/grid_list.dart';
import 'list/tile_list.dart';

final OptionField<ListStyle> _listStyleTileOption = OptionTextField<ListStyle>(
  value: ListStyle.tile,
  labelBuilder: (context) => context.localize().listStyleTileLabel,
  icon: CommonIcons.listStyleTile,
);

final OptionField<ListStyle> _listStyleGridOption = OptionTextField<ListStyle>(
  value: ListStyle.grid,
  labelBuilder: (context) => context.localize().listStyleGridLabel,
  icon: CommonIcons.listStyleGrid,
);

class ListDetailBuilder<
  T extends Object,
  SB extends IdentityActionBloc<T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const ListDetailBuilder({
    super.key,
    required this.title,
    required this.searchSpace,
    this.availableStyles = const [ListStyle.tile, ListStyle.grid],
    required this.detailBuilder,
    required this.listItemBuilder,
    required this.itemAspectRatio,
    this.floatingActionButton,
    this.onSearchAddPressed,
    required this.idGetter,
  });

  final String title;
  final String searchSpace;
  final List<ListStyle> availableStyles;
  final FloatingActionButton? floatingActionButton;
  final ValueChanged<String>? onSearchAddPressed;
  final String Function(T data) idGetter;

  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(
    BuildContext context,
    ListStyle style,
    T data,
    VoidCallback onTap,
  )
  listItemBuilder;
  final double itemAspectRatio;

  @override
  Widget build(BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<SB, ActionState<T?>>(
          listener: (context, state) {
            final data = (state is ActionSuccess<T?, T?>) ? state.data : null;

            // Allow minimized if selected
            context.read<MinimizedLayoutBloc>().add(
              ActionStarted(data: data != null),
            );
          },
        ),
        BlocListener<CurrentListSearchGetBloc, ActionState<ListSearch>>(
          listener: (context, state) {
            if (state is ActionFinal<ListSearch, void>) {
              final currentSearch = (state is ActionSuccess<ListSearch, void>)
                  ? ListSearchDTO(
                      filter: state.data.filter,
                      sort: state.data.sort,
                    )
                  : ListSearchDTO();

              context.read<LB>().add(ListSearchChanged(search: currentSearch));
            }
          },
        ),
        BlocListener<CurrentListSearchSaveBloc, ActionState<void>>(
          listener: (context, state) {
            if (state is ActionSuccess<void, ListSearch?>) {
              context.read<CurrentListSearchGetBloc>().add(
                const ActionRestarted(),
              );
            }
          },
        ),
        BlocListener<CurrentListStyleSaveBloc, ActionState<void>>(
          listener: (context, state) {
            if (state is ActionSuccess<void, ListStyle?>) {
              context.read<CurrentListStyleGetBloc>().add(
                const ActionRestarted(),
              );
            }
          },
        ),
        BlocListener<LB, ListState<T>>(
          listener: (context, state) {
            if (state is ListLoadSuccess<T>) {
              final listData = state.data;

              final selectState = context.read<SB>().state;
              if (selectState is ActionSuccess<T?, T?>) {
                final selectData = selectState.data;

                if (selectData != null) {
                  try {
                    final selectedId = idGetter(selectData);
                    final reloadedData = listData.firstWhere(
                      (el) => idGetter(el) == selectedId,
                    );
                    context.read<SB>().add(ActionStarted(data: reloadedData));
                  } on StateError {
                    return;
                  }
                }
              }
            }
          },
        ),
      ],
      child: BlocBuilder<CurrentListStyleGetBloc, ActionState<ListStyle>>(
        builder: (context, listStyleState) {
          final selectedStyle =
              (listStyleState is ActionSuccess<ListStyle, void>)
              ? listStyleState.data
              : defaultListStyle;

          return BlocBuilder<SB, ActionState<T?>>(
            builder: (context, selectState) {
              final selectedData = (selectState is ActionSuccess<T?, T?>)
                  ? selectState.data
                  : null;

              if (layoutTier == LayoutTier.compact) {
                if (selectedData == null) {
                  return _list(
                    context,
                    selectedData: selectedData,
                    selectedStyle: selectedStyle,
                  );
                } else {
                  return _detail(
                    context,
                    selectedData: selectedData,
                    selectBloc: context.read<SB>(),
                  );
                }
              } else {
                return Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: _list(
                        context,
                        selectedData: selectedData,
                        selectedStyle: selectedStyle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _detail(
                        context,
                        selectedData: selectedData,
                        selectBloc: context.read<SB>(),
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _detail(
    BuildContext context, {
    required T? selectedData,
    required SB selectBloc,
  }) {
    return selectedData == null
        ? _emptyDetail(context)
        : detailBuilder(
            context,
            selectedData,
            () => _select(selectBloc: selectBloc, data: null),
          );
  }

  Widget _emptyDetail(BuildContext context) {
    return Center(child: Text(context.localize().emptyListDetailLabel));
  }

  Widget _list(
    BuildContext context, {
    required T? selectedData,
    required ListStyle selectedStyle,
  }) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => _appBarBuilder(
        context,
        innerBoxIsScrolled,
        selectedStyle: selectedStyle,
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListLayout(
            toolbar: ListFilterToolbarBuilder<T, LB>(space: searchSpace),
            statusbar: ListTotalStatusbarBuilder<T, LB>(),
            child: selectedStyle == ListStyle.grid
                ? GridListBuilder<T, LB>(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(kCardBorderRadius),
                    ),
                    itemAspectRatio: itemAspectRatio,
                    columns: (MediaQuery.sizeOf(context).width / 400).ceil(),
                    itemBuilder: (context, data, index) => listItemBuilder(
                      context,
                      ListStyle.grid,
                      data,
                      () => _selectOrUnselectIfSame(
                        context,
                        selectBloc: context.read<SB>(),
                        data: data,
                        selectedData: selectedData,
                      ),
                    ),
                  )
                : TileListBuilder<T, LB>(
                    borderRadius: BorderRadius.zero,
                    itemBuilder: (context, data, index) => listItemBuilder(
                      context,
                      ListStyle.tile,
                      data,
                      () => _selectOrUnselectIfSame(
                        context,
                        selectBloc: context.read<SB>(),
                        data: data,
                        selectedData: selectedData,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: floatingActionButton,
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarBuilder(
    BuildContext context,
    bool innerBoxIsScrolled, {
    required ListStyle selectedStyle,
  }) {
    return <Widget>[
      FullSearchSliverAppBar(
        title: Text(title),
        onAddPressed: onSearchAddPressed,
        onSearchChanged: (value) =>
            context.read<LB>().add(ListQuicksearchChanged(quicksearch: value)),
        actions: [
          if (availableStyles.length > 1)
            SegmentedButton<ListStyle>(
              segments: availableStyles
                  .map(
                    (style) => style == ListStyle.grid
                        ? _listStyleGridOption
                        : _listStyleTileOption,
                  )
                  .map(
                    (choice) => ButtonSegment<ListStyle>(
                      value: choice.value,
                      label: choice.widgetBuilder(context),
                      icon: choice.icon,
                    ),
                  )
                  .toList(growable: false),
              selected: {selectedStyle},
              onSelectionChanged: (newSelection) {
                context.read<CurrentListStyleSaveBloc>().add(
                  ActionStarted(data: newSelection.first),
                );
              },
            ),
          IconButton(
            icon: CommonIcons.reload,
            tooltip: context.localize().reloadLabel,
            onPressed: () => context.read<LB>().add(const ListReloaded()),
          ),
        ],
      ),
    ];
  }

  void _selectOrUnselectIfSame(
    BuildContext context, {
    required SB selectBloc,
    required T? data,
    required T? selectedData,
  }) {
    _select(
      selectBloc: context.read<SB>(),
      data: data == selectedData
          ? null // Remove selection if pressed on the same one
          : data,
    );
  }

  void _select({required SB selectBloc, required T? data}) {
    selectBloc.add(ActionStarted(data: data));
  }
}

class ListCreateDetailBuilder<
  T extends Object,
  SB extends IdentityActionBloc<T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const ListCreateDetailBuilder({
    super.key,
    required this.title,
    required this.searchSpace,
    this.availableStyles = const [ListStyle.tile, ListStyle.grid],
    required this.idGetter,
    required this.createFormBuilder,
    required this.detailBuilder,
    required this.listItemBuilder,
    required this.itemAspectRatio,
  });

  final String title;
  final String searchSpace;
  final List<ListStyle> availableStyles;
  final Widget Function([String? value]) createFormBuilder;
  final String Function(T data) idGetter;

  final Widget Function(BuildContext context, T data, VoidCallback onClosed)
  detailBuilder;
  final Widget Function(
    BuildContext context,
    ListStyle style,
    T data,
    VoidCallback onTap,
  )
  listItemBuilder;
  final double itemAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ListDetailBuilder<T, SB, LB>(
      title: title,
      searchSpace: searchSpace,
      availableStyles: availableStyles,
      onSearchAddPressed: (quicksearch) async => showReturningDialog(
        context,
        builder: (context) => createFormBuilder(quicksearch),
        onSuccess: (context, _) => context.read<LB>().add(const ListReloaded()),
      ),
      idGetter: idGetter,
      floatingActionButton: FloatingActionButton(
        tooltip: context.localize().createLabel,
        onPressed: () async => showReturningDialog(
          context,
          builder: (context) => createFormBuilder(),
          onSuccess: (context, _) =>
              context.read<LB>().add(const ListReloaded()),
        ),
        child: CommonIcons.add,
      ),
      detailBuilder: detailBuilder,
      listItemBuilder: listItemBuilder,
      itemAspectRatio: itemAspectRatio,
    );
  }
}

class RelationListBuilder<T extends Object, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const RelationListBuilder({
    super.key,
    this.createFormBuilder,
    this.searchCreateFormBuilder,
    required this.itemBuilder,
  });

  final Widget Function([String? value])? createFormBuilder;
  final Widget Function(String value)? searchCreateFormBuilder;
  final Widget Function(BuildContext context, T data) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListLayout(
      toolbar: ListFullSearchToolbar(
        onAddPressed:
            createFormBuilder == null || searchCreateFormBuilder == null
            ? null
            : (quicksearch) async => showReturningDialog(
                context,
                builder: (context) => searchCreateFormBuilder!(quicksearch),
                onSuccess: (context, _) async => showReturningDialog(
                  context,
                  builder: (context) => createFormBuilder!(quicksearch),
                  onSuccess: (context, _) =>
                      context.read<LB>().add(const ListReloaded()),
                ),
              ),
        onSearchChanged: (value) =>
            context.read<LB>().add(ListQuicksearchChanged(quicksearch: value)),
        actions: [
          if (createFormBuilder != null)
            IconButton(
              icon: CommonIcons.link,
              tooltip: context.localize().linkLabel,
              onPressed: () async => showReturningDialog(
                context,
                builder: (context) => createFormBuilder!(),
                onSuccess: (context, _) =>
                    context.read<LB>().add(const ListReloaded()),
              ),
            ),
          IconButton(
            icon: CommonIcons.reload,
            tooltip: context.localize().reloadLabel,
            onPressed: () => context.read<LB>().add(const ListReloaded()),
          ),
        ],
      ),
      statusbar: ListTotalStatusbarBuilder<T, LB>(),
      child: TileListBuilder<T, LB>(
        borderRadius: BorderRadius.zero,
        itemBuilder: (context, data, index) => itemBuilder(context, data),
      ),
    );
  }
}
