import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        ListInitial,
        ListLoadBloc,
        ListSearchChanged,
        TagDeleteBloc,
        TagGetBloc,
        UserGameWithTagListBloc;
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show LayoutTier, SearchDTO, TabDestination, Tag, UserGame;
import 'package:game_oclock/shared/forms/game_form.dart';
import 'package:game_oclock/shared/forms/game_tag_form.dart';
import 'package:game_oclock/shared/forms/tag_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:go_router/go_router.dart';

class TagDetailPage extends StatelessWidget {
  const TagDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              TagGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
        BlocProvider(
          create: (_) => TagDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => UserGameWithTagListBloc(
            service: RepositoryProvider.of(context),
            tagId: id,
          ),
        ),
      ],
      child: DetailBuilder<Tag, TagGetBloc>(
        onBackPressed: () => GoRouter.of(context).go(CommonPaths.tagsPath),
        builder: (final context, final data, final onBackPressed) => TagDetail(
          data: data,
          fromPage: true,
          extended: layoutTier != LayoutTier.compact,
          onBackPressed: onBackPressed,
          onEditSucceeded: (final context) =>
              context.read<TagGetBloc>().add(const ActionRestarted()),
          onDeleteSucceeded: (final context) =>
              GoRouter.of(context).go(CommonPaths.tagsPath),
        ),
      ),
    );
  }
}

class TagDetail extends StatelessWidget {
  const TagDetail({
    super.key,
    required this.data,
    this.fromPage = false,
    required this.extended,
    required this.onBackPressed,
    required this.onEditSucceeded,
    required this.onDeleteSucceeded,
  });

  final Tag data;
  final VoidCallback onBackPressed;
  final bool fromPage;
  final bool extended;
  final ValueChanged<BuildContext> onEditSucceeded;
  final ValueChanged<BuildContext> onDeleteSucceeded;

  @override
  Widget build(final BuildContext context) {
    final mainTab = TabDestination(
      icon: CommonIcons.detail,
      labelBuilder: (final context) => context.localize().detailLabel,
      onTap: (_) {},
      child: _info(context),
    );

    final List<TabDestination> tabs = List.unmodifiable(<TabDestination>[
      TabDestination(
        icon: CommonIcons.games,
        labelBuilder: (final context) => context.localize().gamesTitle,
        onTap: (final context) =>
            _loadOnlyInitial<UserGameWithTagListBloc>(context),
        child: RelationListBuilder<UserGame, UserGameWithTagListBloc>(
          createFormBuilder: ([final quicksearch]) =>
              GameTagCreateForm(gameId: quicksearch, tagId: data.id),
          searchCreateFormBuilder: (final quicksearch) =>
              UserGameCreateForm(initialTitle: quicksearch),
          itemBuilder: (final context, final data) => UserGameTileListItem(
            data: data,
            onTap: () =>
                GoRouter.of(context).go(CommonPaths.buildGamePath(data.id)),
          ),
        ),
      ),
    ]);

    return BlocListener<TagDeleteBloc, ActionState<void>>(
      listener: (final context, final state) {
        if (state is ActionSuccess<void, Tag>) {
          showSnackBar(
            context,
            message: context.localize().deletedSuccessfullyLabel,
          );
          onDeleteSucceeded(context);
        }
        if (state is ActionFailure<void, Tag>) {
          showErrorSnackBar(
            context,
            name: context.localize().unableToDeleteLabel,
            error: state.error,
          );
        }
      },
      child: DetailWithTabs(
        title: Text(data.name),
        onBackPressed: onBackPressed,
        actions: [
          if (!fromPage)
            IconButton(
              icon: CommonIcons.view,
              tooltip: context.localize().viewLabel,
              onPressed: () =>
                  GoRouter.of(context).go(CommonPaths.buildTagPath(data.id)),
            ),
          IconButton(
            icon: CommonIcons.edit,
            tooltip: context.localize().editLabel,
            onPressed: () async => showFormDialog<Tag>(
              context,
              builder: (final context) => TagEditForm(id: data.id),
              onSuccess: (final context, _) => onEditSucceeded(context),
            ),
          ),
          IconButton(
            icon: CommonIcons.delete,
            tooltip: context.localize().deleteLabel,
            onPressed: () async => showConfirmationDialog(
              context,
              builder: (final context) => ConfirmationDialog(
                title: context.localize().deleteDialogTitle,
                subtitle: context.localize().deleteDialogSubtitle,
                message: context.localize().deleteDialogDataTitle(data.name),
                acceptLabel: MaterialLocalizations.of(
                  context,
                ).deleteButtonTooltip,
              ),
              onSuccess: (final context) {
                context.read<TagDeleteBloc>().add(ActionStarted(data: data));
              },
            ),
          ),
        ],
        extended: extended,
        mainTab: mainTab,
        tabs: tabs,
      ),
    );
  }

  Widget _info(final BuildContext context) {
    return SingleChildScrollView(
      child: LabelsContainer(
        children: [
          TextLabel(label: context.localize().idLabel, value: data.id),
          TextLabel(label: context.localize().nameLabel, value: data.name),
        ],
      ),
    );
  }

  void _loadOnlyInitial<LB extends ListLoadBloc>(final BuildContext context) {
    final lb = context.read<LB>();
    if (lb.state is ListInitial) {
      lb.add(ListSearchChanged(search: SearchDTO()));
    }
  }
}
