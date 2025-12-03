import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionInProgress,
        ActionStarted,
        ActionState,
        ActionSuccess,
        CurrentListSearchGetBloc,
        CurrentListSearchSaveBloc,
        ListFinal,
        ListLoadBloc,
        ListLoadInProgress,
        ListState;
import 'package:game_oclock/components/label_chip.dart';
import 'package:game_oclock/components/search/search_list.dart';
import 'package:game_oclock/components/search_text_field.dart';
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/constants/constants.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ChainOperatorType, FilterDTO, ListSearch, SearchValue, SortDTO;
import 'package:game_oclock/utils/localisation_extension.dart';

class ListLayout extends StatelessWidget {
  const ListLayout({
    super.key,
    this.toolbar,
    required this.child,
    this.statusbar,
  });

  final Widget? toolbar;
  final Widget? statusbar;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    if (toolbar == null && statusbar == null) {
      return child;
    }

    return Column(
      children: [
        if (toolbar != null) toolbar!,
        Expanded(child: child),
        if (statusbar != null) statusbar!,
      ],
    );
  }
}

class ListTotalStatusbarBuilder<T, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const ListTotalStatusbarBuilder({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<LB, ListState<T>>(
      builder: (final context, final state) {
        int total;
        if (state is ListLoadInProgress<T>) {
          return const ListTotalStatusbarSkeleton();
        } else if (state is ListFinal<T>) {
          total = state.total;
        } else {
          return const SizedBox();
        }

        return ListTotalStatusbar(total: total);
      },
    );
  }
}

class ListTotalStatusbar extends StatelessWidget {
  const ListTotalStatusbar({super.key, required this.total});

  final int total;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: kStatusbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(context.localize().totalDataLabel(total)),
          ),
        ],
      ),
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
    return BlocBuilder<CurrentListSearchGetBloc, ActionState<ListSearch>>(
      builder: (final context, final state) {
        ListSearch currentSearch;
        if (state is ActionInProgress<ListSearch>) {
          return const ListFilterToolbarSkeleton();
        } else if (state is ActionFinal<ListSearch, void>) {
          currentSearch = (state is ActionSuccess<ListSearch, void>)
              ? state.data
              : ListSearch.def();
        } else {
          return const SizedBox();
        }

        return ListFilterToolbar(
          space: space,
          search: currentSearch,
          onSearchChanged: (final context, final selectedSearch) {
            context.read<CurrentListSearchSaveBloc>().add(
              ActionStarted(data: selectedSearch),
            );
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
  final ListSearch search;
  final void Function(BuildContext context, ListSearch selectedSearch)
  onSearchChanged;

  @override
  Widget build(final BuildContext context) {
    final filter = search.search.filter ?? [];
    final sort = search.search.sort ?? [];

    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 4.0,
        children: [
          filter.isEmpty && sort.isEmpty
              ? Text(
                  context.localize().allLabel,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )
              : Text(search.name),
          ..._buildFilterChips(context, filter),
          ..._buildSortChips(context, sort),
        ],
      ),
      trailing: CommonIcons.down,
      onTap: () async =>
          showModalBottomSheet<ListSearch>(
            context: context,
            builder: (final context) => SearchListPage(space: space, currentSearch: search),
          ).then((final selectedSearch) {
            if (selectedSearch != null && context.mounted) {
              onSearchChanged(context, selectedSearch);
            }
          }),
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

class ListToolbar extends StatelessWidget {
  const ListToolbar({super.key, required this.actions});

  final List<Widget> actions;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: kMinInteractiveDimension,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: actions,
        ),
      ),
    );
  }
}

class ListFullSearchToolbar extends StatefulWidget {
  const ListFullSearchToolbar({
    super.key,
    this.actions,
    required this.onSearchChanged,
    this.onAddPressed,
  });

  final List<Widget>? actions;
  final ValueChanged<String?> onSearchChanged;
  final ValueChanged<String>? onAddPressed;

  @override
  State<ListFullSearchToolbar> createState() => _ListFullSearchToolbarState();
}

class _ListFullSearchToolbarState extends State<ListFullSearchToolbar> {
  final controller = TextEditingController();
  bool inSearch = false;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: kMinInteractiveDimension,
      child: inSearch
          ? Padding(
              padding: const EdgeInsetsDirectional.all(4.0),
              child: SearchTextField(
                controller: controller,
                onDismissed: () => {
                  setState(() {
                    inSearch = false;
                  }),
                },
                onCleared: () => {
                  setState(() {
                    inSearch = false;
                  }),
                },
                onSearchChanged: widget.onSearchChanged,
                onAddPressed: widget.onAddPressed,
              ),
            )
          : Padding(
              padding: const EdgeInsetsDirectional.only(end: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: CommonIcons.search,
                    tooltip: context.localize().searchLabel,
                    onPressed: () {
                      setState(() {
                        inSearch = true;
                      });
                    },
                  ),
                  ...?widget.actions,
                ],
              ),
            ),
    );
  }
}
