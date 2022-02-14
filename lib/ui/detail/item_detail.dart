import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:backend/model/model.dart' show Item, ItemImage;
import 'package:backend/repository/repository.dart'
    show GameCollectionRepository;

import 'package:backend/bloc/item_detail/item_detail.dart';
import 'package:backend/bloc/item_detail_manager/item_detail_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/field/field.dart';
import '../common/show_snackbar.dart';
import '../common/item_view.dart';

abstract class ItemDetail<
        T extends Item,
        K extends Bloc<ItemDetailEvent, ItemDetailState>,
        S extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState>>
    extends StatelessWidget {
  const ItemDetail({
    Key? key,
    required this.item,
    this.onUpdate,
  }) : super(key: key);

  final T item;
  final void Function(T? item)? onUpdate;

  @override
  Widget build(BuildContext context) {
    final GameCollectionRepository _collectionRepository =
        RepositoryProvider.of<GameCollectionRepository>(context);

    final S _managerBloc = managerBlocBuilder(_collectionRepository);

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<K>(
          create: (BuildContext context) {
            return detailBlocBuilder(_collectionRepository, _managerBloc)
              ..add(LoadItem());
          },
        ),
        BlocProvider<S>(
          create: (BuildContext context) {
            return _managerBloc;
          },
        ),
        ...relationBlocsBuilder(_collectionRepository)
      ],
      child: Scaffold(body: detailBodyBuilder()),
    );
  }

  K detailBlocBuilder(
    GameCollectionRepository collectionRepository,
    S managerBloc,
  );
  S managerBlocBuilder(GameCollectionRepository collectionRepository);
  List<BlocProvider<BlocBase<Object?>>> relationBlocsBuilder(
    GameCollectionRepository collectionRepository,
  );

  ItemDetailBody<T, K, S> detailBodyBuilder();
}

// ignore: must_be_immutable
abstract class ItemDetailBody<
        T extends Item,
        K extends Bloc<ItemDetailEvent, ItemDetailState>,
        S extends Bloc<ItemDetailManagerEvent, ItemDetailManagerState>>
    extends StatelessWidget {
  ItemDetailBody({
    Key? key,
    required this.onUpdate,
  }) : super(key: key);

  final void Function(T? item)? onUpdate;

  T? _updatedItem;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onUpdate != null) {
          onUpdate!(_updatedItem);
        }
        return true;
      },
      child: BlocListener<S, ItemDetailManagerState>(
        listener: (BuildContext context, ItemDetailManagerState state) {
          if (state is ItemFieldUpdated<T>) {
            _updatedItem = state.item;

            final String message =
                GameCollectionLocalisations.of(context).fieldUpdatedString;
            showSnackBar(
              context,
              message: message,
            );
          }
          if (state is ItemFieldNotUpdated) {
            final String message = GameCollectionLocalisations.of(context)
                .unableToUpdateFieldString;
            showSnackBar(
              context,
              message: message,
              snackBarAction: dialogSnackBarAction(
                context,
                label: GameCollectionLocalisations.of(context).moreString,
                title: message,
                content: state.error,
              ),
            );
          }
          if (state is ItemImageUpdated<T>) {
            _updatedItem = state.item;

            final String message =
                GameCollectionLocalisations.of(context).imageUpdatedString;
            showSnackBar(
              context,
              message: message,
            );
          }
          if (state is ItemImageNotUpdated) {
            final String message = GameCollectionLocalisations.of(context)
                .unableToUpdateImageString;
            showSnackBar(
              context,
              message: message,
              snackBarAction: dialogSnackBarAction(
                context,
                label: GameCollectionLocalisations.of(context).moreString,
                title: message,
                content: state.error,
              ),
            );
          }
        },
        child: NestedScrollView(
          headerSliverBuilder: _appBarBuilder,
          body: ListView(
            children: <Widget>[
              BlocBuilder<K, ItemDetailState>(
                builder: (BuildContext context, ItemDetailState state) {
                  if (state is ItemLoaded<T>) {
                    return Column(
                      children: itemFieldsBuilder(context, state.item),
                    );
                  }
                  if (state is ItemNotLoaded) {
                    return Center(
                      child: Text(state.error),
                    );
                  }

                  return Container();
                },
              ),
              Column(
                children: itemRelationsBuilder(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _appBarBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: MediaQuery.of(context).size.height /
            3, //Third part of height of screen
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

              return Container();
            },
          ),
        ),
        flexibleSpace: BlocBuilder<K, ItemDetailState>(
          builder: (BuildContext context, ItemDetailState state) {
            String title = '';
            bool hasImage = false;
            ItemImage? image;

            if (state is ItemLoaded<T>) {
              title = itemTitle(state.item);
              hasImage = state.item.hasImage;
              image = state.item.image;
            }

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: FlexibleSpaceBar(
                title: Text(title),
                collapseMode: CollapseMode.parallax,
                background: hasImage
                    ? CachedImage(
                        imageURL: image!.url,
                        fit: BoxFit.cover,
                        applyGradient: true,
                        backgroundColour: Theme.of(context).primaryColor,
                      )
                    : Container(),
              ),
              onTap: hasImage
                  ? () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext innerContext) {
                          return _imageActionListBuilder(
                            innerContext,
                            context,
                            imageFilename: image!.filename,
                          );
                        },
                      );
                    }
                  : null,
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
    final ImagePicker _picker = ImagePicker();
    final bool withImage = imageFilename.isNotEmpty;

    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text(withImage ? imageFilename : ''),
        ),
        const Divider(),
        ListTile(
          title: withImage
              ? Text(GameCollectionLocalisations.of(context).replaceImageString)
              : Text(GameCollectionLocalisations.of(context).uploadImageString),
          leading: const Icon(Icons.file_upload),
          onTap: () {
            _picker
                .pickImage(
              source: ImageSource.gallery,
            )
                .then((XFile? imagePicked) {
              if (imagePicked != null) {
                BlocProvider.of<S>(outerContext).add(
                  AddItemImage<T>(
                    imagePicked.path,
                    withImage ? imageFilename.split('.').first : null,
                  ),
                );
              }

              Navigator.maybePop(context);
            });
          },
        ),
        ListTile(
          title:
              Text(GameCollectionLocalisations.of(context).renameImageString),
          leading: const Icon(Icons.edit),
          enabled: withImage,
          onTap: () {
            final TextEditingController fieldController =
                TextEditingController();
            final String imageName = imageFilename.split('.').first;
            fieldController.text = imageName.split('-').last.split('_').first;

            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    GameCollectionLocalisations.of(context).editString(
                      GameCollectionLocalisations.of(context).filenameString,
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
                      hintText: GameCollectionLocalisations.of(context)
                          .filenameString,
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
                  UpdateItemImageName<T>(
                    imageName,
                    newName,
                  ),
                );
              }

              Navigator.maybePop(context);
            });
          },
        ),
        ListTile(
          title:
              Text(GameCollectionLocalisations.of(context).deleteImageString),
          leading: const Icon(Icons.delete),
          enabled: withImage,
          onTap: () {
            final String imageName = imageFilename.split('.').first;

            BlocProvider.of<S>(outerContext).add(
              DeleteItemImage<T>(
                imageName,
              ),
            );

            Navigator.maybePop(context);
          },
        )
      ],
    );
  }

  void Function(O) _updateFunction<O>(
    BuildContext context, {
    required T item,
    required T Function(O newValue) itemUpdater,
  }) {
    return (O newValue) {
      final T updatedItem = itemUpdater(newValue);

      BlocProvider.of<S>(context).add(
        UpdateItemField<T>(
          item,
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
    required T Function(String newValue) itemUpdater,
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
    );
  }

  Widget itemURLField(
    BuildContext context, {
    required String fieldName,
    required String value,
    required T item,
    required T Function(String newValue) itemUpdater,
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
        if (await canLaunch(value)) {
          await launch(value);
        } else {
          final String message = GameCollectionLocalisations.of(context)
              .unableToLaunchString(value);
          showSnackBar(
            context,
            message: message,
          );
        }
      },
    );
  }

  Widget itemLongTextField(
    BuildContext context, {
    required String fieldName,
    required String value,
    required T item,
    required T Function(String newValue) itemUpdater,
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

  Widget itemMoneyField(
    BuildContext context, {
    required String fieldName,
    required double? value,
    required T item,
    required T Function(double newValue) itemUpdater,
  }) {
    return DoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null
          ? GameCollectionLocalisations.of(context).formatEuro(value)
          : null,
      update: _updateFunction<double>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
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

  Widget itemMoneySumField(
    BuildContext context, {
    required String fieldName,
    required double? value,
  }) {
    return DoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null
          ? GameCollectionLocalisations.of(context).formatEuro(value)
          : null,
      editable: false,
    );
  }

  Widget itemPercentageField(
    BuildContext context, {
    required String fieldName,
    required double? value,
  }) {
    return DoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null
          ? GameCollectionLocalisations.of(context)
              .formatPercentage(value * 100)
          : null,
      editable: false,
    );
  }

  Widget itemYearField(
    BuildContext context, {
    required String fieldName,
    required int? value,
    required T item,
    required T Function(int newValue) itemUpdater,
  }) {
    return YearField(
      fieldName: fieldName,
      value: value,
      update: _updateFunction<int>(
        context,
        item: item,
        itemUpdater: itemUpdater,
      ),
    );
  }

  Widget itemDateField(
    BuildContext context, {
    required String fieldName,
    required DateTime? value,
    required T item,
    required T Function(DateTime newValue) itemUpdater,
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
    required T Function(int newValue) itemUpdater,
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
    required T Function(bool newValue) itemUpdater,
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
    required T Function(int newValue) itemUpdater,
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

  String itemTitle(T item);

  List<Widget> itemFieldsBuilder(BuildContext context, T item);
  List<Widget> itemRelationsBuilder(BuildContext context);
}
