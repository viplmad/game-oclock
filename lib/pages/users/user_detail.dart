import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        UserDeleteBloc,
        UserGetBloc;
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/show_confirmation_dialog.dart';
import 'package:game_oclock/components/show_form_dialog.dart';
import 'package:game_oclock/components/show_snackbar.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show LayoutTier, TabDestination, User;
import 'package:game_oclock/shared/forms/user_form.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:go_router/go_router.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              UserGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
        BlocProvider(
          create: (_) =>
              UserDeleteBloc(service: RepositoryProvider.of(context)),
        ),
      ],
      child: DetailBuilder<User, UserGetBloc>(
        onBackPressed: () => GoRouter.of(context).go(CommonPaths.usersPath),
        builder: (final context, final data, final onBackPressed) => UserDetail(
          data: data,
          fromPage: true,
          extended: layoutTier != LayoutTier.compact,
          onBackPressed: onBackPressed,
          onEditSucceeded: (final context) =>
              context.read<UserGetBloc>().add(const ActionRestarted()),
          onDeleteSucceeded: (final context) =>
              GoRouter.of(context).go(CommonPaths.usersPath),
        ),
      ),
    );
  }
}

class UserDetail extends StatelessWidget {
  const UserDetail({
    super.key,
    required this.data,
    this.fromPage = false,
    required this.extended,
    required this.onBackPressed,
    required this.onEditSucceeded,
    required this.onDeleteSucceeded,
  });

  final User data;
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

    final List<TabDestination> tabs = const [];

    return BlocListener<UserDeleteBloc, ActionState<void>>(
      listener: (final context, final state) {
        if (state is ActionSuccess<void, User>) {
          showSnackBar(
            context,
            message: context.localize().deletedSuccessfullyLabel,
          );
          onDeleteSucceeded(context);
        }
        if (state is ActionFailure<void, User>) {
          showSnackBar(
            context,
            message: context.localize().unableToDeleteDataLabel(
              state.error.message,
            ),
          );
        }
      },
      child: DetailWithTabs(
        title: Text(data.username),
        onBackPressed: onBackPressed,
        actions: [
          if (!fromPage)
            IconButton(
              icon: CommonIcons.view,
              tooltip: context.localize().viewLabel,
              onPressed: () =>
                  GoRouter.of(context).go(CommonPaths.buildUserPath(data.id)),
            ),
          IconButton(
            icon: CommonIcons.edit,
            tooltip: context.localize().editLabel,
            onPressed: () async => showFormDialog<User>(
              context,
              builder: (final context) => UserEditForm(id: data.id),
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
                message: context.localize().deleteDialogDataTitle(
                  data.username,
                ),
                acceptLabel: MaterialLocalizations.of(
                  context,
                ).deleteButtonTooltip,
              ),
              onSuccess: (final context) {
                context.read<UserDeleteBloc>().add(ActionStarted(data: data));
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
          TextLabel(label: context.localize().nameLabel, value: data.username),
          BoolLabel(label: context.localize().adminLabel, value: data.isAdmin),
        ],
      ),
    );
  }
}
