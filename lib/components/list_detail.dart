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
        ListQuicksearchChanged,
        ListReloaded,
        ListSearchChanged,
        MinimizedLayoutBloc;
import 'package:game_oclock/components/list/toolbar.dart';
import 'package:game_oclock/components/show_form_dialog.dart';
import 'package:game_oclock/constants/constants.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show
        LayoutTier,
        ListSearch,
        ListStyle,
        OptionField,
        OptionTextField,
        SearchDTO,
        defaultListStyle;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

import 'full_search_app_bar.dart';
import 'list/grid_list.dart';
import 'list/tile_list.dart';

final OptionField<ListStyle> _listStyleTileOption = OptionTextField<ListStyle>(
  value: ListStyle.tile,
  labelBuilder: (final context) => context.localize().listStyleTileLabel,
  icon: CommonIcons.listStyleTile,
);

final OptionField<ListStyle> _listStyleGridOption = OptionTextField<ListStyle>(
  value: ListStyle.grid,
  labelBuilder: (final context) => context.localize().listStyleGridLabel,
  icon: CommonIcons.listStyleGrid,
);

class ListDetailBuilder<
  T,
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
  });

  final String title;
  final String searchSpace;
  final List<ListStyle> availableStyles;
  final FloatingActionButton? floatingActionButton;
  final ValueChanged<String>? onSearchAddPressed;

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
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<SB, ActionState<T?>>(
          listener: (final context, final state) {
            final data = (state is ActionSuccess<T?, T?>) ? state.data : null;

            // Allow minimized if selected
            context.read<MinimizedLayoutBloc>().add(
              ActionStarted(data: data != null),
            );
          },
        ),
        BlocListener<CurrentListSearchGetBloc, ActionState<ListSearch>>(
          listener: (final context, final state) {
            if (state is ActionFinal<ListSearch, void>) {
              final currentSearch = (state is ActionSuccess<ListSearch, void>)
                  ? state.data.search
                  : SearchDTO();

              context.read<LB>().add(ListSearchChanged(search: currentSearch));
            }
          },
        ),
        BlocListener<CurrentListSearchSaveBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, ListSearch?>) {
              context.read<CurrentListSearchGetBloc>().add(const ActionRestarted());
            }
          },
        ),
        BlocListener<CurrentListStyleSaveBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, ListStyle?>) {
              context.read<CurrentListStyleGetBloc>().add(const ActionRestarted());
            }
          },
        ),
      ],
      child: BlocBuilder<CurrentListStyleGetBloc, ActionState<ListStyle>>(
        builder: (final context, final listStyleState) {
          final selectedStyle =
              (listStyleState is ActionSuccess<ListStyle, void>)
              ? listStyleState.data
              : defaultListStyle;

          return BlocBuilder<SB, ActionState<T?>>(
            builder: (final context, final selectState) {
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
    final BuildContext context, {
    required final T? selectedData,
    required final SB selectBloc,
  }) {
    return selectedData == null
        ? _emptyDetail(context)
        : detailBuilder(
            context,
            selectedData,
            () => _select(context, selectBloc: selectBloc, data: null),
          );
  }

  Widget _emptyDetail(final BuildContext context) {
    return Center(child: Text(context.localize().emptyListDetailLabel));
  }

  Widget _list(
    final BuildContext context, {
    required final T? selectedData,
    required final ListStyle selectedStyle,
  }) {
    return NestedScrollView(
      headerSliverBuilder: (final context, final innerBoxIsScrolled) =>
          _appBarBuilder(
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
                    itemBuilder: (final context, final data, final index) =>
                        listItemBuilder(
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
                    itemBuilder: (final context, final data, final index) =>
                        listItemBuilder(
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
    final BuildContext context,
    final bool innerBoxIsScrolled, {
    required final ListStyle selectedStyle,
  }) {
    return <Widget>[
      FullSearchSliverAppBar(
        title: Text(title),
        onAddPressed: onSearchAddPressed,
        onSearchChanged: (final value) =>
            context.read<LB>().add(ListQuicksearchChanged(quicksearch: value)),
        actions: [
          if (availableStyles.length > 1)
            SegmentedButton<ListStyle>(
              segments: availableStyles
                  .map(
                    (final style) => style == ListStyle.grid
                        ? _listStyleGridOption
                        : _listStyleTileOption,
                  )
                  .map(
                    (final choice) => ButtonSegment<ListStyle>(
                      value: choice.value,
                      label: choice.widgetBuilder(context),
                      icon: choice.icon,
                    ),
                  )
                  .toList(growable: false),
              selected: {selectedStyle},
              onSelectionChanged: (final newSelection) {
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
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
    required final T? selectedData,
  }) {
    _select(
      context,
      selectBloc: context.read<SB>(),
      data: data == selectedData
          ? null // Remove selection if pressed on the same one
          : data,
    );
  }

  void _select(
    final BuildContext context, {
    required final SB selectBloc,
    required final T? data,
  }) {
    selectBloc.add(ActionStarted(data: data));
  }
}

class ListCreateDetailBuilder<
  T,
  SB extends IdentityActionBloc<T?>,
  LB extends ListLoadBloc<T>
>
    extends StatelessWidget {
  const ListCreateDetailBuilder({
    super.key,
    required this.title,
    required this.searchSpace,
    this.availableStyles = const [ListStyle.tile, ListStyle.grid],
    required this.createFormBuilder,
    required this.detailBuilder,
    required this.listItemBuilder,
    required this.itemAspectRatio,
  });

  final String title;
  final String searchSpace;
  final List<ListStyle> availableStyles;
  final Widget Function([String? value]) createFormBuilder;

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
  Widget build(final BuildContext context) {
    return ListDetailBuilder<T, SB, LB>(
      title: title,
      searchSpace: searchSpace,
      availableStyles: availableStyles,
      onSearchAddPressed: (final quicksearch) async => showFormDialog<T>(
        context,
        builder: (final context) => createFormBuilder(quicksearch),
        onSuccess: (final context, _) =>
            context.read<LB>().add(const ListReloaded()),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: context.localize().addLabel,
        onPressed: () async => showFormDialog<T>(
          context,
          builder: (final context) => createFormBuilder(),
          onSuccess: (final context, _) =>
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

class RelationListBuilder<T, LB extends ListLoadBloc<T>>
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
  Widget build(final BuildContext context) {
    return ListLayout(
      toolbar: ListFullSearchToolbar(
        onAddPressed:
            createFormBuilder == null || searchCreateFormBuilder == null
            ? null
            : (final quicksearch) async => showFormDialog(
                context,
                builder: (final context) =>
                    searchCreateFormBuilder!(quicksearch),
                onSuccess: (final context, _) async => showFormDialog<T>(
                  context,
                  builder: (final context) => createFormBuilder!(quicksearch),
                  onSuccess: (final context, _) =>
                      context.read<LB>().add(const ListReloaded()),
                ),
              ),
        onSearchChanged: (final value) =>
            context.read<LB>().add(ListQuicksearchChanged(quicksearch: value)),
        actions: [
          if (createFormBuilder != null)
            IconButton(
              icon: CommonIcons.link,
              tooltip: context.localize().linkLabel,
              onPressed: () async => showFormDialog<T>(
                context,
                builder: (final context) => createFormBuilder!(),
                onSuccess: (final context, _) =>
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
        itemBuilder: (final context, final data, final index) =>
            itemBuilder(context, data),
      ),
    );
  }
}
