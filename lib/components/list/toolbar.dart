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
import 'package:game_oclock/constants/spaces.dart';
import 'package:game_oclock/models/models.dart'
    show ListSearch, OptionTextField;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

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
  Widget build(BuildContext context) {
    if (toolbar == null && statusbar == null) {
      return child;
    }

    return Column(
      children: [
        ?toolbar,
        Expanded(child: child),
        ?statusbar,
      ],
    );
  }
}

class ListTotalStatusbarBuilder<T extends Object, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const ListTotalStatusbarBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LB, ListState<T>>(
      builder: (context, state) {
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
  Widget build(BuildContext context) {
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

class ListFilterToolbarBuilder<T extends Object, LB extends ListLoadBloc<T>>
    extends StatelessWidget {
  const ListFilterToolbarBuilder({super.key, required this.space})
    : assert(space.length > 0);

  final String space;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentListSearchGetBloc, ActionState<ListSearch>>(
      builder: (context, state) {
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
          options: getSpaceFieldOptions(space),
          onSearchChanged: (context, selectedSearch) {
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
    required this.options,
    required this.onSearchChanged,
  }) : assert(space.length > 0);

  final String space;
  final ListSearch search;
  final List<OptionTextField<String>> options;
  final void Function(BuildContext context, ListSearch selectedSearch)
  onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final filter = search.filter ?? [];
    final sort = search.sort ?? [];

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
              : Text(search.labelBuilder(context)),
          ..._buildFilterChips(context, filter),
          ..._buildSortChips(context, sort),
        ],
      ),
      trailing: CommonIcons.down,
      onTap: () async =>
          showModalBottomSheet<ListSearch>(
            context: context,
            builder: (context) =>
                SearchListPage(space: space, currentSearch: search),
          ).then((selectedSearch) {
            if (selectedSearch != null && context.mounted) {
              onSearchChanged(context, selectedSearch);
            }
          }),
    );
  }

  List<Widget> _buildFilterChips(
    BuildContext context,
    List<FilterDTO> filters,
  ) {
    final widgets = <Widget>[];
    for (var i = 0; i < filters.length; i++) {
      final filter = filters.elementAt(i);
      widgets.add(
        LabelChip(
          label: context.localize().filterValueLabel(
            filter,
            _buildFilterFieldLabel(options, filter.field)(context),
          ),
        ),
      );

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

  List<Widget> _buildSortChips(BuildContext context, List<SortDTO> sorts) {
    final widgets = <Widget>[];
    for (var i = 0; i < sorts.length; i++) {
      final sort = sorts.elementAt(i);
      widgets.add(
        LabelChip(
          icon: _buildSortIcon(sort),
          label: _buildFilterFieldLabel(options, sort.field)(context),
        ),
      );

      if (i < sorts.length - 1) {
        widgets.add(Text(context.localize().thenLabel));
      }
    }
    return widgets;
  }

  Widget _buildSortIcon(SortDTO sort) {
    switch (sort.order.value) {
      case r'Desc':
        return CommonIcons.descending;
      case r'Asc':
      default:
        return CommonIcons.ascending;
    }
  }

  String Function(BuildContext) _buildFilterFieldLabel(
    List<OptionTextField<String>> options,
    String field,
  ) {
    return options
        .firstWhere(
          (option) => option.value == field,
          orElse: () =>
              OptionTextField(value: field, labelBuilder: (context) => field),
        )
        .labelBuilder;
  }
}

class ListToolbar extends StatelessWidget {
  const ListToolbar({super.key, required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
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
  Widget build(BuildContext context) {
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
