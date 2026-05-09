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
import 'package:game_oclock/models/models.dart' show LayoutTier, TabDestination;
import 'package:game_oclock/shared/forms/device_form.dart';
import 'package:game_oclock/shared/list_item/user_game_list_item.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_confirmation_dialog.dart';
import 'package:game_oclock/utils/show_form_dialog.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:game_oclock_client/api.dart';
import 'package:go_router/go_router.dart';

class DeviceDetailPage extends StatelessWidget {
  const DeviceDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return MultiBlocProvider(
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
        onBackPressed: () => GoRouter.of(context).go(CommonPaths.devicesPath),
        builder: (final context, final data, final onBackPressed) =>
            DeviceDetail(
              data: data,
              fromPage: true,
              extended: layoutTier != LayoutTier.compact,
              onBackPressed: onBackPressed,
              onEditSucceeded: (final context) =>
                  context.read<DeviceGetBloc>().add(const ActionRestarted()),
              onDeleteSucceeded: (final context) =>
                  GoRouter.of(context).go(CommonPaths.devicesPath),
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
            _loadOnlyInitial<UserGamePlayedOnDeviceListBloc>(context),
        child: RelationListBuilder<MediaDTO, UserGamePlayedOnDeviceListBloc>(
          itemBuilder: (final context, final data) => UserGameTileListItem(
            data: data,
            onTap: () => GoRouter.of(
              context,
            ).go(CommonPaths.buildGamePath(data.media.id)),
          ),
        ),
      ),
    ]);

    return BlocListener<DeviceDeleteBloc, ActionState<void>>(
      listener: (final context, final state) {
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
            IconButton(
              icon: CommonIcons.view,
              tooltip: context.localize().viewLabel,
              onPressed: () =>
                  GoRouter.of(context).go(CommonPaths.buildDevicePath(data.id)),
            ),
          IconButton(
            icon: CommonIcons.edit,
            tooltip: context.localize().editLabel,
            onPressed: () async => showReturningDialog(
              context,
              builder: (final context) => DeviceEditForm(id: data.id),
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
      lb.add(ListSearchChanged(search: ListSearchDTO()));
    }
  }
}
