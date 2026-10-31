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
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show ActionDestination, LayoutTier, TabDestination;
import 'package:game_oclock/shared/forms/user_form.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:game_oclock_client/api.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocProvider(
      // Recreate on selection change
      key: Key(id),
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
      child: DetailBuilder<UserDTO, UserGetBloc>(
        onBackPressed: () =>
            goBack(context, defaultPath: CommonPaths.usersPath),
        builder: (context, data, onBackPressed) => UserDetail(
          data: data,
          fromPage: true,
          extended: layoutTier != LayoutTier.compact,
          onBackPressed: onBackPressed,
          onEditSucceeded: (context) =>
              context.read<UserGetBloc>().add(const ActionRestarted()),
          onDeleteSucceeded: (context) =>
              goBack(context, defaultPath: CommonPaths.usersPath),
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

  final UserDTO data;
  final VoidCallback onBackPressed;
  final bool fromPage;
  final bool extended;
  final ValueChanged<BuildContext> onEditSucceeded;
  final ValueChanged<BuildContext> onDeleteSucceeded;

  @override
  Widget build(BuildContext context) {
    final mainTab = TabDestination(
      icon: CommonIcons.detail,
      labelBuilder: (context) => context.localize().detailLabel,
      onTap: (_) {},
      child: _info(context),
    );

    final List<TabDestination> tabs = const [];

    return BlocListener<UserDeleteBloc, ActionState<void>>(
      listener: (context, state) {
        if (state is ActionSuccess<void, UserDTO>) {
          showSnackBar(
            context,
            message: context.localize().deletedSuccessfullyLabel,
          );
          onDeleteSucceeded(context);
        }
        if (state is ActionFailure<void, UserDTO>) {
          showErrorSnackBar(
            context,
            name: context.localize().unableToDeleteLabel,
            error: state.error,
          );
        }
      },
      child: DetailWithTabs(
        title: Text(data.username),
        onBackPressed: onBackPressed,
        actions: [
          if (!fromPage)
            ActionDestination(
              icon: CommonIcons.view,
              labelBuilder: (context) => context.localize().viewLabel,
              onTap: (context) =>
                  go(context, path: CommonPaths.buildUserPath(data.id)),
            ),
          ActionDestination(
            icon: CommonIcons.reload,
            labelBuilder: (context) => context.localize().reloadLabel,
            onTap: (context) => onEditSucceeded(context),
          ),
          ActionDestination(
            icon: CommonIcons.edit,
            labelBuilder: (context) => context.localize().editLabel,
            onTap: (context) async => showReturningDialog(
              context,
              builder: (context) => UserEditForm(id: data.id),
              onSuccess: (context, _) => onEditSucceeded(context),
            ),
          ),
          ActionDestination(
            icon: CommonIcons.delete,
            labelBuilder: (context) => context.localize().deleteLabel,
            onTap: (context) async => showConfirmationDialog(
              context,
              builder: (context) => ConfirmationDialog(
                title: context.localize().deleteDialogTitle,
                subtitle: context.localize().deleteDialogSubtitle,
                message: context.localize().deleteDialogDataTitle(
                  data.username,
                ),
                acceptLabel: MaterialLocalizations.of(context)
                    .deleteButtonTooltip,
              ),
              onSuccess: (context) {
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

  Widget _info(BuildContext context) {
    return SingleChildScrollView(
      child: LabelsContainer(
        children: [
          TextLabel(
            icon: CommonIcons.id,
            label: context.localize().idLabel,
            value: data.id,
          ),
          TextLabel(
            icon: CommonIcons.title,
            label: context.localize().nameLabel,
            value: data.username,
          ),
          TextLabel(
            icon: CommonIcons.role,
            label: context.localize().roleLabel,
            value: data.role,
          ),
        ],
      ),
    );
  }
}
