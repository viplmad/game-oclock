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
import 'package:game_oclock/models/models.dart'
    show TabDestination, UnreachableError;
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
  });

  final Widget title;
  final Widget? image;
  final VoidCallback onBackPressed;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(final BuildContext context) {
    return NestedScrollView(headerSliverBuilder: _appBarBuilder, body: child);
  }

  List<Widget> _appBarBuilder(
    final BuildContext context,
    final bool innerBoxIsScrolled,
  ) {
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
        actions: actions,
      ),
    ];
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
  final List<Widget>? actions;
  final bool extended;
  final TabDestination mainTab;
  final List<TabDestination> tabs;

  @override
  Widget build(final BuildContext context) {
    mainTab.onTap(context);
    if (extended && tabs.isNotEmpty) {
      tabs.first.onTap(context);
    }

    return Detail(
      title: title,
      image: image,
      onBackPressed: onBackPressed,
      actions: actions,
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
    final BuildContext context, {
    required final List<TabDestination> destinations,
  }) {
    return DefaultTabController(
      length: destinations.length,
      child: Column(
        children: [
          TabBar(
            onTap: (final index) =>
                destinations.elementAt(index).onTap(context),
            tabs: destinations
                .map(
                  (final dest) =>
                      Tab(icon: dest.icon, text: dest.labelBuilder(context)),
                )
                .toList(growable: false),
          ),
          Expanded(
            child: TabBarView(
              children: destinations
                  .map((final dest) => dest.child)
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
  Widget build(final BuildContext context) {
    return GetBuilder<T, GB>(
      skeletonBuilder: (_) => DetailSkeleton(onBackPressed: onBackPressed),
      errorBuilder: (final context, final onRetryTap) => Center(
        child: DetailError(
          title: context.localize().errorDetailLoadTitle,
          onRetryTap: onRetryTap,
        ),
      ),
      builder: (final context, final data) =>
          builder(context, data, onBackPressed),
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
  Widget build(final BuildContext context) {
    return BlocConsumer<GB, ActionState<T>>(
      listener: (final context, final state) {
        if (state is ActionFailure<T, String>) {
          showErrorSnackBar(
            context,
            name: context.localize().unableToLoadDetailLabel,
            error: state.error,
          );
        }
      },
      builder: (final context, final state) {
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
