import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ListFinal,
        ListLoadBloc,
        ListLoadFailure,
        ListLoadInProgress,
        ListLoadSuccess,
        ListPageIncremented,
        ListPageReloaded,
        ListReloaded,
        ListSearchChanged,
        ListState;
import 'package:game_oclock/components/label_chip.dart';
import 'package:game_oclock/components/search/search_list.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ChainOperatorType, FilterDTO, ListSearch, SearchValue, SortDTO;
import 'package:game_oclock/utils/localisation_extension.dart';

abstract class PaginatedListBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const PaginatedListBuilder({
    super.key,
    required this.itemBuilder,
    this.controller,
  });

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final ScrollController? controller;

  @override
  Widget build(final BuildContext context) {
    final ScrollController controller = this.controller ?? ScrollController();
    controller.addListener(paginateListener(context, controller));

    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) => Scrollbar(
        controller: controller,
        child: list(context, state: state, controller: controller),
      ),
    );
  }

  Widget list(
    final BuildContext context, {
    required final ListState<T> state,
    required final ScrollController controller,
  }) {
    List<T> items = [];
    Widget? trailing;
    if (state is ListFinal<T>) {
      if (state is ListLoadSuccess<T> && state.data.isEmpty) {
        return Center(child: Text(context.localize().emptyListLabel));
      }
      if (state is ListLoadFailure<T>) {
        if (state.data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.localize().errorPageLoadTitle),
                OutlinedButton.icon(
                  icon: CommonIcons.reload,
                  label: Text(context.localize().retryLabel),
                  onPressed: () => context.read<LB>().add(const ListReloaded()),
                ),
              ],
            ),
          );
        }
        trailing = errorItemBuilder(
          context,
          () => context.read<LB>().add(const ListPageReloaded()),
        );
      }
      items = state.data;
    } else if (state is ListLoadInProgress<T>) {
      if (state.data == null || state.data!.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      items = state.data!;
      trailing = const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async => context.read<LB>().add(const ListReloaded()),
      child: listView(
        items: items,
        itemBuilder: itemBuilder,
        trailing: trailing,
        controller: controller,
      ),
    );
  }

  VoidCallback paginateListener(
    final BuildContext context,
    final ScrollController scrollController,
  ) {
    return () {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<LB>().add(const ListPageIncremented());
      }
    };
  }

  Widget listView({
    required final List<T> items,
    required final Widget Function(BuildContext context, T item, int index)
    itemBuilder,
    final Widget? trailing,
    required final ScrollController controller,
  });

  Widget errorItemBuilder(final BuildContext context, final VoidCallback onTap);
}

class ListToolbar extends StatelessWidget {
  const ListToolbar({super.key, required this.toolbars, required this.child});

  final List<Widget> toolbars;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    if (toolbars.isEmpty) {
      return child;
    }

    return Column(
      children: [
        ...toolbars,
        Expanded(child: child),
      ],
    );
  }
}

class ListFilterToolbarBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const ListFilterToolbarBuilder({super.key, required this.space})
    : assert(space.length > 0);

  final String space;

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        ListSearch? currentSearch;
        if (state is ListFinal<T>) {
          currentSearch = state.search;
        }

        return ListFilterToolbar(
          space: space,
          search: currentSearch,
          onSearchChanged: (final context, final selectedSearch) {
            context.read<LB>().add(ListSearchChanged(search: selectedSearch));
          },
        );
      },
    );
  }
}

class ListFilterToolbar extends StatelessWidget {
  const ListFilterToolbar({
    super.key,
    required this.space,
    required this.search,
    required this.onSearchChanged,
  }) : assert(space.length > 0);

  final String space;
  final ListSearch? search;
  final void Function(BuildContext context, ListSearch selectedSearch)
  onSearchChanged;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: search == null
          ? const Text('-')
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 4.0,
              children: [
                Text(search!.name), // TODO empty search
                ..._buildFilterChips(context, search!.search.filter ?? []),
                ..._buildSortChips(context, search!.search.sort ?? []),
              ],
            ),
      trailing: CommonIcons.down,
      onTap: () async {
        showModalBottomSheet<ListSearch>(
          context: context,
          builder: (final context) => SearchListPage(space: space),
        ).then((final selectedSearch) {
          if (selectedSearch != null && context.mounted) {
            onSearchChanged(context, selectedSearch);
          }
        });
      },
    );
  }

  List<Widget> _buildFilterChips(
    final BuildContext context,
    final List<FilterDTO> filters,
  ) {
    final widgets = <Widget>[];
    for (var i = 0; i < filters.length; i++) {
      final filter = filters.elementAt(i);
      widgets.add(LabelChip(label: _buildFilterLabel(context, filter)));

      if (i < filters.length - 1) {
        widgets.add(
          Text(
            filter.chainOperator == null ||
                    filter.chainOperator == ChainOperatorType.and
                ? context.localize().andLabel
                : context.localize().orLabel,
          ),
        );
      }
    }
    return widgets;
  }

  List<Widget> _buildSortChips(
    final BuildContext context,
    final List<SortDTO> sorts,
  ) {
    final widgets = <Widget>[];
    for (var i = 0; i < sorts.length; i++) {
      final sort = sorts.elementAt(i);
      widgets.add(
        LabelChip(
          icon: _buildSortIcon(sort),
          label: _buildSortLabel(context, sort),
        ),
      );

      if (i < sorts.length - 1) {
        widgets.add(Text(context.localize().thenLabel));
      }
    }
    return widgets;
  }

  String _buildFilterLabel(final BuildContext context, final FilterDTO filter) {
    final field = filter.field; // TODO l10n?
    switch (filter.operator_.value) {
      case r'Eq':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().equalChipLabel(field, value);
      case r'NotEq':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().notEqualChipLabel(field, value);
      case r'Gt':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().greaterThanChipLabel(field, value);
      case r'Gte':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().greaterThanEqualChipLabel(field, value);
      case r'Lt':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().lessThanChipLabel(field, value);
      case r'Lte':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().lessThanEqualChipLabel(field, value);
      case r'In':
        final values = _buildFilterValuesLabel(context, filter.value);
        return context.localize().inChipLabel(field, values);
      case r'NotIn':
        final values = _buildFilterValuesLabel(context, filter.value);
        return context.localize().notInChipLabel(field, values);
      case r'StartsWith':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().startsWithChipLabel(field, value);
      case r'NotStartsWith':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().notStartsWithChipLabel(field, value);
      case r'EndsWith':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().endsWithChipLabel(field, value);
      case r'NotEndsWith':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().notEndsWithChipLabel(field, value);
      case r'Contains':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().containsChipLabel(field, value);
      case r'NotContains':
        final value = _buildFilterValueLabel(context, filter.value);
        return context.localize().notContainsChipLabel(field, value);
      default:
        return '?';
    }
  }

  String _buildSortLabel(final BuildContext context, final SortDTO sort) {
    return sort.field; // TODO l10n?
  }

  Widget _buildSortIcon(final SortDTO sort) {
    switch (sort.order.value) {
      case r'Desc':
        return CommonIcons.descending;
      case r'Asc':
      default:
        return CommonIcons.ascending;
    }
  }

  String _buildFilterValueLabel(
    final BuildContext context,
    final SearchValue value,
  ) {
    return value.value == null
        ? context.localize().nullLabel
        : context.localize().quote(value.value!);
  }

  String _buildFilterValuesLabel(
    final BuildContext context,
    final SearchValue value,
  ) {
    return (value.values ?? [])
        .map((final val) => context.localize().quote(val))
        .join(', ');
  }
}

class ListButtonToolbar extends StatelessWidget {
  const ListButtonToolbar({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton.icon(
        label: Text(label),
        icon: icon,
        onPressed: onTap,
      ),
    );
  }
}
