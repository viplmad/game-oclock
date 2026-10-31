import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionFinal,
        ActionInProgress,
        ActionRestarted,
        ActionState,
        ActionSuccess,
        FunctionActionBloc;
import 'package:game_oclock/components/error_detail.dart' show DetailError;
import 'package:game_oclock/components/skeletons/skeletons.dart'
    show DetailSkeleton;
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart'
    show ActionDestination, TabDestination, UnreachableError;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_snackbar.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.title,
    this.image,
    required this.onBackPressed,
    required this.child,
    this.actions,
    this.moreActions,
  });

  final Widget title;
  final Widget? image;
  final VoidCallback onBackPressed;
  final Widget child;
  final List<ActionDestination>? actions;
  final List<ActionDestination>? moreActions;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(headerSliverBuilder: _appBarBuilder, body: child);
  }

  List<Widget> _appBarBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight:
            MediaQuery.of(context).size.height /
            3, //Third part of height of screen
        surfaceTintColor: Theme.of(context).primaryColor,
        // Fixed elevation so background colour doesn't change on scroll
        forceElevated: true,
        elevation: 1.0,
        scrolledUnderElevation: 1.0,
        floating: false,
        pinned: true,
        snap: false,
        automaticallyImplyLeading: false,
        leading: BackButton(onPressed: onBackPressed),
        bottom: const PreferredSize(
          preferredSize: Size(double.maxFinite, 1.0),
          child: SizedBox(),
        ),
        flexibleSpace: FlexibleSpaceBar(
          title: title,
          collapseMode: CollapseMode.parallax,
          background: image ?? const SizedBox(),
        ),
        actionsPadding: const EdgeInsetsDirectional.only(end: 8.0),
        actions: actions == null && moreActions == null
            ? null
            : <Widget>[
                if (actions != null && actions!.isNotEmpty)
                  ...actions!.map(
                    (e) => IconButton(
                      icon: e.icon,
                      tooltip: e.labelBuilder(context),
                      onPressed: () => e.onTap(context),
                    ),
                  ),
                if (moreActions != null && moreActions!.isNotEmpty)
                  MorePopupMenu(actions: moreActions!),
              ],
      ),
    ];
  }
}

class MorePopupMenu extends StatefulWidget {
  const MorePopupMenu({super.key, required this.actions});

  final List<ActionDestination> actions;

  @override
  State<MorePopupMenu> createState() => _MorePopupMenuState();
}

class _MorePopupMenuState extends State<MorePopupMenu> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: widget.actions
          .map(
            (e) => MenuItemButton(
              leadingIcon: e.icon,
              onPressed: () => e.onTap(context),
              child: Text(e.labelBuilder(context)),
            ),
          )
          .toList(growable: false),
      builder: (_, controller, _) {
        return IconButton(
          icon: CommonIcons.menu,
          tooltip: context.localize().moreLabel,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
}

class DetailWithTabs extends StatelessWidget {
  const DetailWithTabs({
    super.key,
    required this.title,
    this.image,
    required this.onBackPressed,
    this.actions,
    required this.extended,
    required this.mainTab,
    required this.tabs,
  });

  final Widget title;
  final Widget? image;
  final VoidCallback onBackPressed;
  final List<ActionDestination>? actions;
  final bool extended;
  final TabDestination mainTab;
  final List<TabDestination> tabs;

  @override
  Widget build(BuildContext context) {
    mainTab.onTap(context);
    if (extended && tabs.isNotEmpty) {
      tabs.first.onTap(context);
    }

    return Detail(
      title: title,
      image: image,
      onBackPressed: onBackPressed,
      actions: extended
          ? actions
          : (actions != null && actions!.isNotEmpty
                ? actions!.sublist(0, 1)
                : null),
      moreActions: extended
          ? null
          : (actions != null && actions!.length > 1
                ? actions!.sublist(1)
                : null),
      child: extended
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: mainTab.child),
                const VerticalDivider(width: 1.0),
                Expanded(flex: 4, child: _tabs(context, destinations: tabs)),
              ],
            )
          : _tabs(context, destinations: [mainTab, ...tabs]),
    );
  }

  Widget _tabs(
    BuildContext context, {
    required List<TabDestination> destinations,
  }) {
    return DefaultTabController(
      length: destinations.length,
      child: Column(
        children: [
          TabBar(
            onTap: (index) => destinations.elementAt(index).onTap(context),
            tabs: destinations
                .map(
                  (dest) =>
                      Tab(icon: dest.icon, text: dest.labelBuilder(context)),
                )
                .toList(growable: false),
          ),
          Expanded(
            child: TabBarView(
              children: destinations
                  .map((dest) => dest.child)
                  .toList(growable: false),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBuilder<T, GB extends FunctionActionBloc<String, T>>
    extends StatelessWidget {
  const DetailBuilder({
    super.key,
    required this.onBackPressed,
    required this.builder,
  });

  final VoidCallback onBackPressed;
  final Widget Function(
    BuildContext context,
    T data,
    VoidCallback onBackPressed,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T, GB>(
      skeletonBuilder: (_) => DetailSkeleton(onBackPressed: onBackPressed),
      errorBuilder: (context, onRetryTap) => Center(
        child: DetailError(
          title: context.localize().errorDetailLoadTitle,
          onRetryTap: onRetryTap,
        ),
      ),
      builder: (context, data) => builder(context, data, onBackPressed),
    );
  }
}

class GetBuilder<T, GB extends FunctionActionBloc<String, T>>
    extends StatelessWidget {
  const GetBuilder({
    super.key,
    required this.builder,
    required this.errorBuilder,
    required this.skeletonBuilder,
  });

  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context, VoidCallback onRetryTap)
  errorBuilder;
  final Widget Function(BuildContext context) skeletonBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GB, ActionState<T>>(
      listener: (context, state) {
        if (state is ActionFailure<T, String>) {
          showErrorSnackBar(
            context,
            name: context.localize().unableToLoadDetailLabel,
            error: state.error,
          );
        }
      },
      builder: (context, state) {
        T data;
        if (state is ActionInProgress<T>) {
          if (state.data == null) {
            // First time
            return skeletonBuilder(context);
          }
          data = state.data as T;
        } else if (state is ActionFinal<T, String>) {
          if (state is ActionFailure<T, String>) {
            return errorBuilder(
              context,
              () => context.read<GB>().add(const ActionRestarted()),
            );
          } else if (state is ActionSuccess<T, String>) {
            data = state.data;
          } else {
            throw UnreachableError();
          }
        } else {
          return const SizedBox();
        }

        return builder(context, data);
      },
    );
  }
}
