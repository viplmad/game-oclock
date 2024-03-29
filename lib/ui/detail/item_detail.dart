import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:game_oclock_client/api.dart' show PrimaryModel;

import 'package:logic/model/model.dart' show ItemImage;
import 'package:logic/service/service.dart' show GameOClockService;
import 'package:logic/bloc/item_detail/item_detail.dart';
import 'package:logic/bloc/item_detail_manager/item_detail_manager.dart';

import 'package:game_oclock/ui/common/field/field.dart';
import 'package:game_oclock/ui/common/show_snackbar.dart';
import 'package:game_oclock/ui/common/item_view.dart';
import 'package:game_oclock/ui/common/list_view.dart';
import 'package:game_oclock/ui/common/header_text.dart';

import '../theme/theme.dart' show AppTheme;

abstract class ItemDetail<
        T extends PrimaryModel,
        N extends Object,
        K extends Bloc<ItemDetailEvent, ItemDetailState>,
        S extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState>>
    extends StatelessWidget {
  const ItemDetail({
    super.key,
    required this.item,
    this.onChange,
  });

  final PrimaryModel item;
  final void Function()? onChange;

  @override
  Widget build(BuildContext context) {
    final GameOClockService collectionService =
        RepositoryProvider.of<GameOClockService>(context);

    final S managerBloc = managerBlocBuilder(collectionService);

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<K>(
          create: (BuildContext context) {
            return detailBlocBuilder(collectionService, managerBloc)
              ..add(LoadItem());
          },
        ),
        BlocProvider<S>(
          create: (BuildContext context) {
            return managerBloc;
          },
        ),
        ...relationBlocsBuilder(collectionService),
      ],
      child: Scaffold(body: detailBodyBuilder()),
    );
  }

  K detailBlocBuilder(
    GameOClockService collectionService,
    S managerBloc,
  );
  S managerBlocBuilder(GameOClockService collectionService);
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameOClockService collectionService,
  );

  ItemDetailBody<T, N, K, S> detailBodyBuilder();
}

// ignore: must_be_immutable
abstract class ItemDetailBody<
        T extends PrimaryModel,
        N extends Object,
        K extends Bloc<ItemDetailEvent, ItemDetailState>,
        S extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState>>
    extends StatelessWidget {
  ItemDetailBody({
    super.key,
    required this.onChange,
    required this.hasImage,
  });

  final void Function()? onChange;
  final bool hasImage;

  bool _changesMade = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        if (_changesMade && onChange != null) {
          onChange!();
        }
      },
      child: BlocListener<S, ItemDetailManagerState>(
        listener: (BuildContext context, ItemDetailManagerState state) {
          if (state is ItemFieldUpdated) {
            _changesMade = true;

            final String message =
                AppLocalizations.of(context)!.fieldUpdatedString;
            showSnackBar(
              context,
              message: message,
            );
          }
          if (state is ItemFieldNotUpdated) {
            final String message =
                AppLocalizations.of(context)!.unableToUpdateFieldString;
            showApiErrorSnackbar(
              context,
              name: message,
              error: state.error,
              errorDescription: state.errorDescription,
            );
          }
          if (state is ItemImageUpdated) {
            _changesMade = true;

            final String message =
                AppLocalizations.of(context)!.imageUpdatedString;
            showSnackBar(
              context,
              message: message,
            );
          }
          if (state is ItemImageNotUpdated) {
            final String message =
                AppLocalizations.of(context)!.unableToUpdateImageString;
            showApiErrorSnackbar(
              context,
              name: message,
              error: state.error,
              errorDescription: state.errorDescription,
            );
          }
          if (state is ItemDetailNotLoaded) {
            final String message =
                AppLocalizations.of(context)!.unableToLoadDetailString;
            showApiErrorSnackbar(
              context,
              name: message,
              error: state.error,
              errorDescription: state.errorDescription,
            );
          }
        },
        child: NestedScrollView(
          headerSliverBuilder: _appBarBuilder,
          body: RefreshIndicator(
            onRefresh: () async => reloadItem(context),
            child: ListView(
              padding: const EdgeInsets.only(top: 16.0),
              children: <Widget>[
                BlocBuilder<K, ItemDetailState>(
                  builder: (BuildContext context, ItemDetailState state) {
                    if (state is ItemLoaded<T>) {
                      return Column(
                        children: itemFieldsBuilder(context, state.item),
                      );
                    }
                    if (state is ItemDetailError) {
                      return ItemError(
                        title: AppLocalizations.of(context)!
                            .somethingWentWrongString,
                        onRetryTap: () => reloadItem(context),
                      );
                    }

                    return Column(
                      children: itemSkeletonFieldsBuilder(context),
                    );
                  },
                ),
                Column(
                  children: itemRelationsBuilder(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void reloadItem(BuildContext context) {
    BlocProvider.of<K>(context).add(const ReloadItem());
    reloadExtraFields(context);
  }

  List<Widget> _appBarBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: MediaQuery.of(context).size.height /
            3, //Third part of height of screen
        surfaceTintColor: Theme.of(context).primaryColor,
        // Fixed elevation so background colour doesn't change on scroll
        forceElevated: true,
        elevation: 1.0,
        scrolledUnderElevation: 1.0,
        floating: false,
        pinned: true,
        snap: false,
        bottom: PreferredSize(
          preferredSize: const Size(
            double.maxFinite,
            1.0,
          ),
          child: BlocBuilder<K, ItemDetailState>(
            builder: (BuildContext context, ItemDetailState state) {
              if (state is ItemLoading) {
                return const LinearProgressIndicator();
              }

              return const SizedBox();
            },
          ),
        ),
        flexibleSpace: BlocBuilder<K, ItemDetailState>(
          builder: (BuildContext context, ItemDetailState state) {
            String title = '';
            bool useImage = false;
            ItemImage? image;

            if (state is ItemLoaded<T>) {
              title = itemTitle(state.item);
              useImage = hasImage;
              image = buildItemImage(state.item);
            }

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: useImage
                  ? () async {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        useSafeArea: true,
                        builder: (BuildContext innerContext) {
                          return _imageActionListBuilder(
                            innerContext,
                            context,
                            imageFilename: image?.filename ?? '',
                          );
                        },
                      );
                    }
                  : null,
              child: FlexibleSpaceBar(
                title: Text(title),
                collapseMode: CollapseMode.parallax,
                background: useImage
                    ? CachedImage(
                        imageURL: image?.url ?? '',
                        fit: BoxFit.cover,
                        applyGradient: true,
                        backgroundColour: Theme.of(context).primaryColor,
                      )
                    : const SizedBox(),
              ),
            );
          },
        ),
      ),
    ];
  }

  Widget _imageActionListBuilder(
    BuildContext context,
    BuildContext outerContext, {
    required String imageFilename,
  }) {
    final ImagePicker picker = ImagePicker();
    final bool withImage = imageFilename.isNotEmpty;

    return Wrap(
      children: <Widget>[
        ...(withImage
            ? <Widget>[
                ListTile(
                  title: Text(withImage ? imageFilename : ''),
                ),
                const ListDivider(),
              ]
            : <Widget>[]),
        ListTile(
          title: Text(
            withImage
                ? AppLocalizations.of(context)!.replaceImageString
                : AppLocalizations.of(context)!.uploadImageString,
          ),
          leading: Icon(
            withImage ? AppTheme.replaceUploadIcon : AppTheme.uploadIcon,
          ),
          onTap: () async {
            picker
                .pickImage(
              source: ImageSource.gallery,
            )
                .then((XFile? imagePicked) {
              if (imagePicked != null) {
                BlocProvider.of<S>(outerContext).add(
                  SetItemImage(
                    imagePicked.path,
                  ),
                );
              }

              Navigator.maybePop(context);
            });
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.renameImageString),
          leading: const Icon(AppTheme.editIcon),
          enabled: withImage,
          onTap: () async {
            final TextEditingController fieldController =
                TextEditingController();

            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: HeaderText(
                    AppLocalizations.of(context)!.editString(
                      AppLocalizations.of(context)!.filenameString,
                    ),
                  ),
                  content: TextField(
                    controller: fieldController,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    maxLines: null,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^([A-z])*$')),
                    ],
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.filenameString,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel,
                      ),
                      onPressed: () {
                        Navigator.maybePop<String>(context);
                      },
                    ),
                    TextButton(
                      child:
                          Text(MaterialLocalizations.of(context).okButtonLabel),
                      onPressed: () {
                        Navigator.maybePop<String>(
                          context,
                          fieldController.text.trim(),
                        );
                      },
                    ),
                  ],
                );
              },
            ).then((String? newName) {
              if (newName != null) {
                BlocProvider.of<S>(outerContext).add(
                  UpdateItemImageName(
                    newName,
                  ),
                );
              }

              Navigator.maybePop(context);
            });
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.deleteImageString),
          leading: const Icon(AppTheme.deleteIcon),
          enabled: withImage,
          onTap: () async {
            BlocProvider.of<S>(outerContext).add(
              DeleteItemImage(),
            );

            Navigator.maybePop(context);
          },
        ),
      ],
    );
  }

  void Function(O) _updateFunction<O>(
    BuildContext context, {
    required T item,
    required N Function(O newValue) itemUpdater,
  }) {
    return (O newValue) {
      final N updatedItem = itemUpdater(newValue);

      BlocProvider.of<S>(context).add(
        UpdateItemField<N>(
          updatedItem,
        ),
      );
    };
  }

  Widget itemTextField(
    BuildContext context, {
    required String fieldName,
    required String value,
    required T item,
    required N Function(String newValue) itemUpdater,
  }) {
    return CustomTextField(
      fieldName: fieldName,
      value: value,
      shownValue: null,
      update: _updateFunction<String>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
      isLongText: true,
    );
  }

  Widget itemURLField(
    BuildContext context, {
    required String fieldName,
    required String value,
    required T item,
    required N Function(String newValue) itemUpdater,
  }) {
    return CustomTextField(
      fieldName: fieldName,
      value: value,
      shownValue: null,
      update: _updateFunction<String>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
      onLongPress: () async {
        if (await canLaunchUrlString(value)) {
          await launchUrlString(value);
        } else if (context.mounted) {
          // Check context is mounted after asynchronous gap
          final String message =
              AppLocalizations.of(context)!.unableToLaunchString(value);
          showSnackBar(
            context,
            message: message,
          );
        }
      },
      isLongText: true,
    );
  }

  Widget itemLongTextField(
    BuildContext context, {
    required String fieldName,
    required String value,
    required T item,
    required N Function(String newValue) itemUpdater,
  }) {
    return CustomTextField(
      fieldName: fieldName,
      value: value,
      shownValue: null,
      update: _updateFunction<String>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
      isLongText: true,
      isMultiline: true,
    );
  }

  Widget itemDurationField(
    BuildContext context, {
    required String fieldName,
    required Duration? value,
  }) {
    return DurationField(
      fieldName: fieldName,
      value: value,
      editable: false,
    );
  }

  Widget itemYearField(
    BuildContext context, {
    required String fieldName,
    required int? value,
    required T item,
    required N Function(int? newValue) itemUpdater,
  }) {
    return YearField(
      fieldName: fieldName,
      value: value,
      update: _updateFunction<int>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
      onLongPress: () =>
          _updateFunction<int?>(context, item: item, itemUpdater: itemUpdater)(
        null,
      ),
    );
  }

  Widget itemDateField(
    BuildContext context, {
    required String fieldName,
    required DateTime? value,
    required T item,
    required N Function(DateTime newValue) itemUpdater,
  }) {
    return DateField(
      fieldName: fieldName,
      value: value,
      update: _updateFunction<DateTime>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
    );
  }

  Widget itemRatingField(
    BuildContext context, {
    required String fieldName,
    required int? value,
    required T item,
    required N Function(int newValue) itemUpdater,
  }) {
    return RatingField(
      fieldName: fieldName,
      value: value ?? 0,
      update: _updateFunction<int>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
    );
  }

  Widget itemBoolField(
    BuildContext context, {
    required String fieldName,
    required bool value,
    required T item,
    // ignore: avoid_positional_boolean_parameters
    required N Function(bool newValue) itemUpdater,
  }) {
    return BoolField(
      fieldName: fieldName,
      value: value,
      update: _updateFunction<bool>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
    );
  }

  Widget itemChipField(
    BuildContext context, {
    required String fieldName,
    required int? value,
    required List<String> possibleValues,
    required List<Color> possibleValuesColours,
    required T item,
    required N Function(int newValue) itemUpdater,
  }) {
    return EnumField(
      fieldName: fieldName,
      value: value,
      enumValues: possibleValues,
      enumColours: possibleValuesColours,
      update: _updateFunction<int>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
    );
  }

  Widget itemSkeletonField({
    required String fieldName,
    required int order,
  }) {
    return SkeletonGenericField(
      fieldName: fieldName,
      order: order,
    );
  }

  Widget itemSkeletonLongTextField({
    required String fieldName,
    required int order,
  }) {
    return SkeletonGenericField(
      fieldName: fieldName,
      order: order,
      extended: true,
    );
  }

  Widget itemSkeletonChipField({
    required String fieldName,
    required int order,
  }) {
    return SkeletonEnumField(
      fieldName: fieldName,
      order: order,
    );
  }

  Widget itemSkeletonRatingField({
    required String fieldName,
    required int order,
  }) {
    return SkeletonRatingField(
      fieldName: fieldName,
      order: order,
    );
  }

  void reloadExtraFields(BuildContext context) {}

  String itemTitle(T item);

  List<Widget> itemFieldsBuilder(BuildContext context, T item);
  List<Widget> itemSkeletonFieldsBuilder(BuildContext context);
  List<Widget> itemRelationsBuilder(BuildContext context);
  ItemImage buildItemImage(T item);
}
