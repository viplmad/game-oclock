import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionRestarted,
        ActionStarted,
        ActionState,
        ActionSuccess,
        DeviceDeleteBloc,
        DeviceGetBloc,
        ListInitial,
        ListLoadBloc,
        ListSearchChanged,
        UserGamePlayedOnDeviceListBloc;
import 'package:game_oclock/components/cached_image.dart';
import 'package:game_oclock/components/detail.dart';
import 'package:game_oclock/components/labels/labels.dart';
import 'package:game_oclock/components/list_detail.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show ActionDestination, LayoutTier, TabDestination;
import 'package:game_oclock/shared/forms/device_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:game_oclock_client/api.dart';

class DeviceDetailPage extends StatelessWidget {
  const DeviceDetailPage({super.key, required this.id});

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
              DeviceGetBloc(service: RepositoryProvider.of(context))
                ..add(ActionStarted(data: id)),
        ),
        BlocProvider(
          create: (_) =>
              DeviceDeleteBloc(service: RepositoryProvider.of(context)),
        ),
        BlocProvider(
          create: (_) => UserGamePlayedOnDeviceListBloc(
            service: RepositoryProvider.of(context),
            deviceId: id,
          ),
        ),
      ],
      child: DetailBuilder<DeviceDTO, DeviceGetBloc>(
        onBackPressed: () =>
            goBack(context, defaultPath: CommonPaths.devicesPath),
        builder: (context, data, onBackPressed) => DeviceDetail(
          data: data,
          fromPage: true,
          extended: layoutTier != LayoutTier.compact,
          onBackPressed: onBackPressed,
          onEditSucceeded: (context) =>
              context.read<DeviceGetBloc>().add(const ActionRestarted()),
          onDeleteSucceeded: (context) =>
              goBack(context, defaultPath: CommonPaths.devicesPath),
        ),
      ),
    );
  }
}

class DeviceDetail extends StatelessWidget {
  const DeviceDetail({
    super.key,
    required this.data,
    this.fromPage = false,
    required this.extended,
    required this.onBackPressed,
    required this.onEditSucceeded,
    required this.onDeleteSucceeded,
  });

  final DeviceDTO data;
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

    final List<TabDestination> tabs = List.unmodifiable(<TabDestination>[
      TabDestination(
        icon: CommonIcons.games,
        labelBuilder: (context) => context.localize().gamesTitle,
        onTap: (context) =>
            _loadOnlyInitial<UserGamePlayedOnDeviceListBloc>(context),
        child: RelationListBuilder<MediaDTO, UserGamePlayedOnDeviceListBloc>(
          itemBuilder: (context, data) => UserGameTileListItem(
            data: data,
            onTap: () =>
                go(context, path: CommonPaths.buildGamePath(data.media.id)),
          ),
        ),
      ),
    ]);

    return BlocListener<DeviceDeleteBloc, ActionState<void>>(
      listener: (context, state) {
        if (state is ActionSuccess<void, DeviceDTO>) {
          showSnackBar(
            context,
            message: context.localize().deletedSuccessfullyLabel,
          );
          onDeleteSucceeded(context);
        }
        if (state is ActionFailure<void, DeviceDTO>) {
          showErrorSnackBar(
            context,
            name: context.localize().unableToDeleteLabel,
            error: state.error,
          );
        }
      },
      child: DetailWithTabs(
        title: Text(data.name),
        image: data.imageUrl == null
            ? null
            : SimpleCachedNetworkImage(
                imageUrl: data.imageUrl!,
                fit: BoxFit.cover,
                applyGradient: true,
              ),
        onBackPressed: onBackPressed,
        actions: [
          if (!fromPage)
            ActionDestination(
              icon: CommonIcons.view,
              labelBuilder: (context) => context.localize().viewLabel,
              onTap: (context) =>
                  go(context, path: CommonPaths.buildDevicePath(data.id)),
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
              builder: (context) => DeviceEditForm(id: data.id),
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
                message: context.localize().deleteDialogDataTitle(data.name),
                acceptLabel: MaterialLocalizations.of(context)
                    .deleteButtonTooltip,
              ),
              onSuccess: (context) {
                context.read<DeviceDeleteBloc>().add(ActionStarted(data: data));
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
            value: data.name,
          ),
        ],
      ),
    );
  }

  void _loadOnlyInitial<LB extends ListLoadBloc>(BuildContext context) {
    final lb = context.read<LB>();
    if (lb.state is ListInitial) {
      lb.add(ListSearchChanged(search: ListSearchDTO()));
    }
  }
}
