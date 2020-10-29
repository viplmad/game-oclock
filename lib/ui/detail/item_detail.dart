import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:numberpicker/numberpicker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../common/item_view.dart';
import '../common/year_picker_dialog.dart';


class DetailArguments<T> {
  const DetailArguments({
    @required this.item,
    this.onUpdate,
  });

  final T item;
  final void Function(T item) onUpdate;
}

abstract class ItemDetail<T extends CollectionItem, K extends ItemDetailBloc<T>, S extends ItemDetailManagerBloc<T>> extends StatelessWidget {
  const ItemDetail({
    Key key,
    @required this.item,
    this.onUpdate,
  }) : super(key: key);

  final T item;
  final void Function(T item) onUpdate;

  @override
  Widget build(BuildContext context) {

    S _managerBloc = managerBlocBuilder();

    return MultiBlocProvider(
      providers: [
        BlocProvider<K>(
          create: (BuildContext context) {
            return detailBlocBuilder(_managerBloc)..add(LoadItem());
          },
        ),

        BlocProvider<S>(
          create: (BuildContext context) {
            return _managerBloc;
          },
        ),
      ]..addAll(relationBlocsBuilder()),
      child: Scaffold(
        body: detailBodyBuilder()
      ),
    );

  }

  K detailBlocBuilder(S managerBloc);
  S managerBlocBuilder();
  List<BlocProvider> relationBlocsBuilder();

  ItemDetailBody<T, K, S> detailBodyBuilder();
}

// ignore: must_be_immutable
abstract class ItemDetailBody<T extends CollectionItem, K extends ItemDetailBloc<T>, S extends ItemDetailManagerBloc<T>> extends StatelessWidget {
  ItemDetailBody({
    Key key,
    this.onUpdate,
  }) : super(key: key);

  final void Function(T item) onUpdate;

  T _updatedItem;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {

        if(onUpdate != null) { onUpdate(_updatedItem); }
        return Future<bool>.value(true);

      },
      child: BlocListener<S, ItemDetailManagerState>(
        listener: (BuildContext context, ItemDetailManagerState state) {
          if(state is ItemFieldUpdated<T>) {
            _updatedItem = state.item;

            String message = GameCollectionLocalisations.of(context).fieldUpdatedString;
            showSnackBar(
              scaffoldState: Scaffold.of(context),
              message: message,
            );
          }
          if(state is ItemFieldNotUpdated) {
            String message = GameCollectionLocalisations.of(context).unableToUpdateFieldString;
            showSnackBar(
              scaffoldState: Scaffold.of(context),
              message: message,
              snackBarAction: dialogSnackBarAction(
                context,
                label: GameCollectionLocalisations.of(context).moreString,
                title: message,
                content: state.error,
              ),
            );
          }
          if(state is ItemImageUpdated<T>) {
            _updatedItem = state.item;

            String message = GameCollectionLocalisations.of(context).imageUpdatedString;
            showSnackBar(
              scaffoldState: Scaffold.of(context),
              message: message,
            );
          }
          if(state is ItemImageNotUpdated) {
            String message = GameCollectionLocalisations.of(context).unableToUpdateImageString;
            showSnackBar(
              scaffoldState: Scaffold.of(context),
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
            children: [
              BlocBuilder<K, ItemDetailState> (
                builder: (BuildContext context, ItemDetailState state) {

                  if(state is ItemLoaded<T>) {

                    return Column(
                      children: itemFieldsBuilder(context, state.item),
                    );

                  }
                  if(state is ItemNotLoaded) {

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
        expandedHeight: MediaQuery.of(context).size.height / 3, //Third part of height of screen
        floating: false,
        pinned: true,
        snap: false,
        bottom: PreferredSize(
          preferredSize: Size(double.maxFinite, 1.0,),
          child: BlocBuilder<K, ItemDetailState> (
            builder: (BuildContext context, ItemDetailState state) {

              if(state is ItemLoading) {
                return LinearProgressIndicator();
              }

              return Container();

            },
          ),
        ),
        flexibleSpace: BlocBuilder<K, ItemDetailState> (
          builder: (BuildContext context, ItemDetailState state) {
            String title = '';
            bool hasImage = false;
            ItemImage image;

            if(state is ItemLoaded<T>) {
              title = itemTitle(state.item);
              hasImage = state.item.hasImage;
              image = state.item.image;
            }

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: FlexibleSpaceBar(
                title: Text(title),
                collapseMode: CollapseMode.parallax,
                background: hasImage?
                  CachedImage(
                    imageURL: image.url,
                    fit: BoxFit.cover,
                    applyGradient: true,
                    backgroundColour: Theme.of(context).primaryColor,
                  ) : Container(),
              ),
              onTap: hasImage? () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext innerContext) {

                    return _imageActionListBuilder(
                      innerContext,
                      context,
                      imageFilename: image.filename,
                    );

                  },
                );
              } : null,
            );

          },
        ),
      ),
    ];

  }

  Widget _imageActionListBuilder(BuildContext context, BuildContext outerContext, {String imageFilename}) {

    final ImagePicker _picker = ImagePicker();
    final bool withImage = imageFilename.isNotEmpty;

    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: Text(withImage? imageFilename : ''),
          ),
          Divider(),
          ListTile(
            title: withImage?
              Text(GameCollectionLocalisations.of(context).replaceImageString)
              :
              Text(GameCollectionLocalisations.of(context).uploadImageString),
            leading: Icon(Icons.file_upload),
            onTap: () {
              _picker.getImage(
                  source: ImageSource.gallery,
              ).then( (PickedFile imagePicked) {
                if(imagePicked != null) {

                  BlocProvider.of<S>(outerContext).add(
                    AddItemImage<T>(
                      imagePicked.path,
                      withImage? imageFilename.split('.').first : null,
                    ),
                  );

                }

                Navigator.maybePop(context);
              });
            },
          ),
          ListTile(
            title: Text(GameCollectionLocalisations.of(context).renameImageString),
            leading: Icon(Icons.edit),
            enabled: withImage,
            onTap: () {
              TextEditingController fieldController = TextEditingController();
              String imageName = imageFilename.split('.').first;
              fieldController.text = imageName.split('-').last.split('_').first;

              showDialog<String>(
                context: context,
                builder: (BuildContext context) {

                  return AlertDialog(
                    title: Text(GameCollectionLocalisations.of(context).editString(GameCollectionLocalisations.of(context).nameFieldString)),
                    content: TextField(
                      controller: fieldController,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      maxLines: null,
                      inputFormatters: <TextInputFormatter> [
                        FilteringTextInputFormatter.allow(RegExp(r'^([A-z])*$')),
                      ],
                      decoration: InputDecoration(
                        hintText: GameCollectionLocalisations.of(context).nameFieldString,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                        onPressed: () {
                          Navigator.maybePop<String>(context);
                        },
                      ),
                      FlatButton(
                        child: Text(MaterialLocalizations.of(context).okButtonLabel),
                        onPressed: () {
                          Navigator.maybePop<String>(context, fieldController.text.trim());
                        },
                      ),
                    ],
                  );
                },
              ).then( (String newName) {
                if(newName != null) {

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
            title: Text(GameCollectionLocalisations.of(context).deleteImageString),
            leading: Icon(Icons.delete),
            enabled: withImage,
            onTap: () {
              String imageName = imageFilename.split('.').first;

              BlocProvider.of<S>(outerContext).add(
                DeleteItemImage<T>(
                  imageName,
                ),
              );

              Navigator.maybePop(context);
            },
          )
        ],
      ),
    );

  }

  void Function(O) _updateFieldFunction<O>(BuildContext context, String fieldName) {

    return (O newValue) {
      BlocProvider.of<S>(context).add(
        UpdateItemField<T>(
          fieldName,
          newValue,
        ),
      );
    };

  }

  Widget itemTextField(BuildContext context, {@required String fieldName, @required String field, @required String value}) {

    return _ItemTextField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<String>(context, field),
    );

  }

  Widget itemURLField(BuildContext context, {@required String fieldName, @required String field, @required String value}) {

    return _ItemTextField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<String>(context, field),
      onLongPress: () async {
        if (await canLaunch(value)) {
          await launch(value);
        } else {
          String message = GameCollectionLocalisations.of(context).unableToLaunchString(value);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
      }
    );

  }

  Widget itemLongTextField(BuildContext context, {@required String fieldName, @required String field, @required String value}) {

    return _ItemTextField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<String>(context, field),
      isLongText: true,
    );

  }

  Widget itemIntField(BuildContext context, {@required String fieldName, @required String field, @required int value}) {

    return _ItemIntField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<int>(context, field),
    );

  }

  Widget itemMoneyField(BuildContext context, {@required String fieldName, @required String field, @required double value}) {

    return _ItemDoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).euroString(value)
        :
        null,
      update: _updateFieldFunction<double>(context, field),
    );

  }

  Widget itemMoneySumField(BuildContext context, {@required String fieldName, @required double value}) {

    return _ItemDoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).euroString(value)
        :
        null,
      editable: false,
    );

  }

  Widget itemPercentageField(BuildContext context, {@required String fieldName, @required double value}) {

    return _ItemDoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).percentageString(value * 100)
        :
        null,
      editable: false,
    );

  }

  Widget itemYearField(BuildContext context, {@required String fieldName, @required String field, @required int value}) {

    return _ItemYearField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<int>(context, field),
    );

  }

  Widget itemDateTimeField(BuildContext context, {@required String fieldName, @required String field, @required DateTime value}) {

    return _ItemDateTimeField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<DateTime>(context, field),
    );

  }

  Widget itemDurationField(BuildContext context, {@required String fieldName, @required String field, @required Duration value}) {

    return _ItemDurationField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<Duration>(context, field),
    );

  }

  Widget itemRatingField(BuildContext context, {@required String fieldName, @required String field, @required int value}) {

    return _RatingField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<int>(context, field),
    );

  }

  Widget itemBoolField(BuildContext context, {@required String fieldName, @required String field, @required bool value}) {

    return _BoolField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<bool>(context, field),
    );

  }

  Widget itemChipField(BuildContext context, {@required String fieldName, @required String field, @required String value, @required List<String> possibleValues, List<Color> possibleValuesColours}) {

    return _EnumField(
      fieldName: fieldName,
      value: value,
      enumValues: possibleValues,
      enumColours: possibleValuesColours,
      update: _updateFieldFunction<String>(context, field),
    );

  }

  String itemTitle(T item);

  List<Widget> itemFieldsBuilder(BuildContext context, T item);
  List<Widget> itemRelationsBuilder(BuildContext context);
}

class _ItemGenericField<K> extends StatelessWidget {
  const _ItemGenericField({
    Key key,
    @required this.fieldName,
    @required this.value,
    this.shownValue,
    this.editable = true,
    @required this.onTap,
    this.onLongPress,
    @required this.update,
    this.extended = false,
  }) : super(key: key);

  final String fieldName;
  final K value;
  final String shownValue;
  final bool editable;
  final Future<K> Function() onTap;
  final void Function() onLongPress;
  final void Function(K) update;

  final bool extended;

  @override
  Widget build(BuildContext context) {

    void Function() onTapWrapped = editable?
      () {
        onTap().then( (K newValue) {
          if (newValue != null) {
            update(newValue);
          }
        });
      } : null;

    return extended?
      InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Text(fieldName, style: Theme.of(context).textTheme.subtitle1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
              child: Text(shownValue?? ''),
            ),
          ],
        ),
        onTap: onTapWrapped,
        onLongPress: onLongPress,
      )
      :
      ListTileTheme.merge(
        child: ListTile(
          title: Text(fieldName),
          trailing: Text(shownValue?? ''),
          onTap: onTapWrapped,
          onLongPress: onLongPress,
        ),
      );

  }
}

class _ItemTextField extends StatelessWidget {
  const _ItemTextField({
    Key key,
    @required this.fieldName,
    @required this.value,
    this.shownValue,
    this.onLongPress,
    @required this.update,
    this.isLongText = false,
  }) : super(key: key);

  final String fieldName;
  final String value;
  final String shownValue;
  final void Function() onLongPress;
  final void Function(String) update;
  final bool isLongText;

  @override
  Widget build(BuildContext context) {

    return _ItemGenericField<String>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue?? value,
      extended: isLongText,
      update: update,
      onTap: () {
        TextEditingController fieldController = TextEditingController();
        fieldController.text = value;

        return showDialog<String>(
          context: context,
          builder: (BuildContext context) {

            return AlertDialog(
              title: Text(GameCollectionLocalisations.of(context).editString(fieldName)),
              content: TextField(
                controller: fieldController,
                keyboardType: isLongText? TextInputType.multiline : TextInputType.text,
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: fieldName,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                  onPressed: () {
                    Navigator.maybePop<String>(context);
                  },
                ),
                FlatButton(
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  onPressed: () {
                    Navigator.maybePop<String>(context, fieldController.text.trim());
                  },
                ),
              ],
            );
          },
        );
      },
      onLongPress: onLongPress,
    );

  }
}

class _ItemIntField extends StatelessWidget {
  const _ItemIntField({
    Key key,
    @required this.fieldName,
    @required this.value,
    @required this.update,
  }) : super(key: key);

  final String fieldName;
  final int value;
  final void Function(int) update;

  @override
  Widget build(BuildContext context) {

    return _ItemGenericField<int>(
      fieldName: fieldName,
      value: value,
      shownValue: value?.toString(),
      update: update,
      onTap: () {
        return showDialog<int>(
          context: context,
          builder: (BuildContext context) {

            return NumberPickerDialog.integer(
              title: Text(GameCollectionLocalisations.of(context).editString(fieldName)),
              initialIntegerValue: value,
              minValue: 1,
              maxValue: 10,
              cancelWidget: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              confirmWidget: Text(MaterialLocalizations.of(context).okButtonLabel),
            );
          }
        );
      },
    );

  }
}

class _ItemDoubleField extends StatelessWidget {
  const _ItemDoubleField({
    Key key,
    @required this.fieldName,
    @required this.value,
    this.shownValue,
    this.editable = true,
    @required this.update,
  }) : super(key: key);

  final String fieldName;
  final double value;
  final String shownValue;
  final bool editable;
  final void Function(double) update;

  @override
  Widget build(BuildContext context) {

    return _ItemGenericField<double>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
      editable: editable,
      update: update,
      onTap: () {
        return showDialog<double>(
          context: context,
          builder: (BuildContext context) {

            return _DecimalPickerDialog(
              fieldName: fieldName,
              number: value,
            );

          },
        );
      },
    );

  }
}

class _ItemYearField extends StatelessWidget {
  const _ItemYearField({
    Key key,
    @required this.fieldName,
    @required this.value,
    @required this.update,
  }) : super(key: key);

  final String fieldName;
  final int value;
  final void Function(int) update;

  @override
  Widget build(BuildContext context) {

    return _ItemGenericField<int>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null? GameCollectionLocalisations.of(context).yearString(value) : null,
      update: update,
      onTap: () {
        return showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return YearPickerDialog(
              year: value,
            );
          },
        );
      },
    );

  }
}

class _ItemDateTimeField extends StatelessWidget {
  const _ItemDateTimeField({
    Key key,
    @required this.fieldName,
    @required this.value,
    @required this.update,
  }) : super(key: key);

  final String fieldName;
  final DateTime value;
  final void Function(DateTime) update;

  @override
  Widget build(BuildContext context) {

    return _ItemGenericField<DateTime>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).dateString(value)
        :
        null,
      update: update,
      onTap: () {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1970),
          lastDate: DateTime.now(),
          initialDate: value?? DateTime.now(),
        );
      },
    );

  }
}

class _ItemDurationField extends StatelessWidget {
  const _ItemDurationField({
    Key key,
    @required this.fieldName,
    @required this.value,
    @required this.update,
  }) : super(key: key);

  final String fieldName;
  final Duration value;
  final void Function(Duration) update;

  @override
  Widget build(BuildContext context) {

    return _ItemGenericField<Duration>(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
        GameCollectionLocalisations.of(context).durationString(value)
        :
        null,
      update: update,
      onTap: () {
        return showDialog<Duration>(
          context: context,
          builder: (BuildContext context) {

            return _DurationPickerDialog(
              fieldName: fieldName,
              duration: value,
            );

          },
        );
      },
    );

  }
}

class _RatingField extends StatelessWidget {
  const _RatingField({
    Key key,
    @required this.fieldName,
    @required this.value,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final int value;
  final Function(int) update;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                child: Text(fieldName, style: Theme.of(context).textTheme.subtitle1),
              ),
            ],
          ),
          SmoothStarRating(
            allowHalfRating: false,
            starCount: 10,
            rating: value.roundToDouble(),
            color: Colors.yellow,
            borderColor: Colors.orangeAccent,
            size: 35.0,
            onRated: (double newRating) {
              if (newRating != null) {

                int updatedRating = newRating.toInt();
                if(updatedRating == value) {
                  updatedRating = 0;
                }

                update(updatedRating);
              }
            },
          ),
        ],
      ),
    );

  }
}

class _BoolField extends StatelessWidget {
  const _BoolField({
    Key key,
    @required this.fieldName,
    @required this.value,
    this.update,
  }) : super(key: key);

  final String fieldName;
  final bool value;
  final Function(bool) update;

  @override
  Widget build(BuildContext context) {

    return SwitchListTile(
      title: Text(fieldName),
      value: value,
      onChanged: update,
    );

  }
}

class _EnumField extends StatelessWidget {
  const _EnumField({
    Key key,
    @required this.fieldName,
    @required this.value,
    @required this.enumValues,
    this.enumColours,
    @required this.update,
  }) : super(key: key);

  final String fieldName;
  final String value;
  final List<String> enumValues;
  final List<Color> enumColours;
  final Function(String) update;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Text(fieldName, style: Theme.of(context).textTheme.subtitle1),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          children: List<Widget>.generate(
            enumValues.length,
                (int index) {
              String option = enumValues[index];
              Color optionColour = enumColours?.elementAt(index);

              return ChoiceChip(
                label: Text(option),
                labelStyle: TextStyle(color: Colors.black87),
                selected: value == option,
                selectedColor: optionColour.withOpacity(0.5),
                pressElevation: 2.0,
                onSelected: (bool newChoice) {
                  if(newChoice) {
                    update(option);
                  }
                },
              );

            },
          ).toList(growable: false),
        ),
      ],
    );

  }
}

class _DurationPickerDialog extends StatefulWidget {
  const _DurationPickerDialog({
    Key key,
    @required this.fieldName,
    @required this.duration,
  }) : super(key: key);

  final String fieldName;
  final Duration duration;

  @override
  State<_DurationPickerDialog> createState() => _DurationPickerDialogState();
}
class _DurationPickerDialogState extends State<_DurationPickerDialog> {
  int _hours;
  int _minutes;

  @override
  void initState() {
    super.initState();

    _hours = widget.duration.inHours;
    _minutes = widget.duration.inMinutes - (_hours * 60);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(GameCollectionLocalisations.of(context).editString(widget.fieldName)),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NumberPicker.integer(
              initialValue: _hours,
              minValue: 0,
              maxValue: 1000,
              highlightSelectedValue: true,
              onChanged: (num newHours) {
                setState(() {
                  _hours = newHours;
                });
              }
          ),
          Text(':', style: Theme.of(context).textTheme.headline6,),
          NumberPicker.integer(
              initialValue: _minutes,
              minValue: 0,
              maxValue: 59,
              highlightSelectedValue: true,
              onChanged: (num newMin) {
                setState(() {
                  _minutes = newMin;
                });
              }
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<Duration>(context);
          },
        ),
        FlatButton(
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            Navigator.maybePop<Duration>(context, Duration(hours: _hours, minutes: _minutes));
          },
        ),
      ],
    );
  }
}

class _DecimalPickerDialog extends StatefulWidget {
  const _DecimalPickerDialog({
    Key key,
    @required this.fieldName,
    @required this.number,
  }) : super(key: key);

  final String fieldName;
  final double number;

  @override
  State<_DecimalPickerDialog> createState() => _DecimalPickerDialogState();
}
class _DecimalPickerDialogState extends State<_DecimalPickerDialog> {
  int _integerPart;
  int _decimalPart;

  @override
  void initState() {
    super.initState();

    _integerPart = widget.number.truncate();
    _decimalPart = ((widget.number - _integerPart) * 100).round();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(GameCollectionLocalisations.of(context).editString(widget.fieldName)),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NumberPicker.integer(
              initialValue: _integerPart,
              minValue: 0,
              maxValue: 1000,
              highlightSelectedValue: true,
              onChanged: (num newInteger) {
                setState(() {
                  _integerPart = newInteger;
                });
              }
          ),
          Text('.', style: Theme.of(context).textTheme.headline6,),
          NumberPicker.integer(
              initialValue: _decimalPart,
              minValue: 0,
              maxValue: 99,
              infiniteLoop: true,
              highlightSelectedValue: true,
              onChanged: (num newDecimal) {
                setState(() {
                  _decimalPart = newDecimal;
                });
              }
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<double>(context);
          },
        ),
        FlatButton(
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            Navigator.maybePop<double>(context, double.tryParse(_integerPart.toString() + '.' + _decimalPart.toString().padLeft(2, '0')));
          },
        ),
      ],
    );
  }
}