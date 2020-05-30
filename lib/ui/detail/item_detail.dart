import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:numberpicker/numberpicker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';

import 'package:game_collection/ui/bloc_provider_route.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';
import 'package:game_collection/ui/common/item_view.dart';


abstract class ItemDetailBody extends StatelessWidget {

  ItemDetailBody({Key key, @required this.itemID, @required this.itemDetailBloc}) : super(key: key);

  final int itemID;
  final ItemDetailBloc itemDetailBloc;

  CollectionItem get item => Item(ID: itemID);

  ItemBloc get itemBloc => itemDetailBloc.itemBloc;

  @override
  Widget build(BuildContext context) {

    return BlocListener<ItemBloc, ItemState>(
      bloc: itemBloc,
      listener: (BuildContext context, ItemState state) {
        if(state is ItemFieldUpdated) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Updated",
          );
        }
        if(state is ItemFieldNotUpdated) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to update",
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: "Unable to update",
              content: state.error,
            ),
          );
        }
        if(state is ItemImageUpdated) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Image successfully updated",
          );
        }
        if(state is ItemImageNotUpdated) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to update image",
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: "Unable to update image",
              content: state.error,
            ),
          );
        }
        if(state is ItemRelationAdded) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Linked",
            snackBarAction: SnackBarAction(
              label: 'Undo',
              onPressed: () {

                itemBloc.add(
                  DeleteItemRelation(
                    item,
                    state.item,
                  ),
                );

              },
            ),
          );
        }
        if(state is ItemRelationNotAdded) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to link",
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: "Unable to link",
              content: state.error,
            ),
          );
        }
        if(state is ItemRelationDeleted) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unlinked",
            snackBarAction: SnackBarAction(
              label: 'Undo',
              onPressed: () {

                itemBloc.add(
                  AddItemRelation(
                    item,
                    state.item,
                  ),
                );

              },
            ),
          );
        }
        if(state is ItemRelationNotDeleted) {
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: "Unable to unlink",
            snackBarAction: dialogSnackBarAction(
              context,
              label: "More",
              title: "Unable to unlink",
              content: state.error,
            ),
          );
        }
      },
      child: NestedScrollView(
        headerSliverBuilder: _appBarBuilder,
        body: ListView(
          children: [
            BlocBuilder<ItemDetailBloc, ItemDetailState> (
              bloc: itemDetailBloc,
              builder: (BuildContext context, ItemDetailState state) {

                if(state is ItemLoaded) {

                  return Column(
                    children: itemFieldsBuilder(state.item),
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
              children: itemRelationsBuilder(),
            ),
          ],
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
          child: BlocBuilder<ItemDetailBloc, ItemDetailState> (
            bloc: itemDetailBloc,
            builder: (BuildContext context, ItemDetailState state) {
              if(state is ItemLoading) {
                return loadingBar();
              }
              return Container();
            },
          ),
        ),
        flexibleSpace: BlocBuilder<ItemDetailBloc, ItemDetailState> (
          bloc: itemDetailBloc,
          builder: (BuildContext context, ItemDetailState state) {
            String title = "";
            String imageURL;
            String imageFilename;

            if(state is ItemLoaded) {
              title = state.item.getTitle();
              imageURL = state.item.getImageURL();
              imageFilename = state.item.getImageFilename();
            }

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: FlexibleSpaceBar(
                title: Text(title),
                collapseMode: CollapseMode.parallax,
                background: CachedImage(
                  imageURL: imageURL,
                  fit: BoxFit.cover,
                  applyGradient: true,
                  backgroundColour: Theme.of(context).primaryColor,
                ),
              ),
              onTap: imageURL != null? () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {

                    return _imageActionListBuilder(context, imageFilename: imageFilename);

                  },
                );
              } : null,
            );

          },
        ),
      ),
    ];

  }

  Widget _imageActionListBuilder(BuildContext context, {String imageFilename}) {

    final ImagePicker _picker = ImagePicker();

    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: Text(imageFilename?? 'none'),
          ),
          Divider(),
          ListTile(
            title: imageFilename != null? Text("Replace image") : Text("Upload image"),
            leading: Icon(Icons.file_upload),
            onTap: () {
              _picker.getImage(
                  source: ImageSource.gallery,
              ).then( (PickedFile imagePicked) {
                if(imagePicked != null) {

                  itemBloc.add(
                    AddItemImage(
                      item,
                      imagePicked.path,
                      imageFilename != null? imageFilename.split('.').first : null,
                    ),
                  );

                }

                Navigator.maybePop(context);
              });
            },
          ),
          ListTile(
            title: Text("Rename image"),
            leading: Icon(Icons.edit),
            enabled: imageFilename != null,
            onTap: () {
              TextEditingController fieldController = TextEditingController();
              String imageName = imageFilename.split('.').first;
              fieldController.text = imageName.split('-').last.split('_').first;

              showDialog<String>(
                context: context,
                builder: (BuildContext context) {

                  MaterialLocalizations localizations = MaterialLocalizations.of(context);

                  return AlertDialog(
                    title: Text("Edit Name"),
                    content: TextField(
                      controller: fieldController,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      inputFormatters: <TextInputFormatter> [
                        WhitelistingTextInputFormatter(RegExp(r'^([A-z])*$')),
                      ],
                      decoration: InputDecoration(
                        hintText: "Name",
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(localizations.cancelButtonLabel),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(localizations.okButtonLabel),
                        onPressed: () {
                          Navigator.maybePop(context, fieldController.text.trim());
                        },
                      ),
                    ],
                  );
                },
              ).then( (String newName) {
                if(newName != null) {

                  itemBloc.add(
                    UpdateItemImageName(
                      item,
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
            title: Text("Delete image"),
            leading: Icon(Icons.delete_outline),
            enabled: imageFilename != null,
            onTap: () {
              String imageName = imageFilename.split('.').first;

              itemBloc.add(
                DeleteItemImage(
                  item,
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

  Widget loadingBar()
  {
    return LinearProgressIndicator();
  }

  void Function(T) _updateFieldFunction<T>(String fieldName) {

    return (T newValue) {
      itemBloc.add(
        UpdateItemField(
          item,
          fieldName,
          newValue,
        ),
      );
    };

  }

  void Function(CollectionItem) _addRelationFunction() {

    return (CollectionItem addedItem) {
      itemBloc.add(
        AddItemRelation(
          item,
          addedItem,
        ),
      );
    };

  }

  void Function(CollectionItem) _deleteRelationFunction() {

    return (CollectionItem deletedItem) {
      itemBloc.add(
        DeleteItemRelation(
          item,
          deletedItem,
        ),
      );
    };

  }

  void Function(CollectionItem) _onTapFunction(BuildContext context) {

    return (CollectionItem item) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ItemDetailProvider(item);
          }
        ),
      );
    };

  }

  Future<CollectionItem> Function() _repositorySearchFuture(BuildContext context, Type itemType) {

    return () {
      return Navigator.push<CollectionItem>(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return ItemRepositorySearchProvider(itemType);
          }
        ),
      );
    };

  }

  void Function() _localSearchFuture(BuildContext context, List<CollectionItem> items) {

    return () {
      return Navigator.push<CollectionItem>(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) {
              return ItemLocalSearchProvider(items);
            }
        ),
      );
    };

  }

  Widget itemTextField({@required String fieldName, @required String value}) {

    return ItemTextField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<String>(fieldName),
    );

  }

  Widget itemURLField({@required String fieldName, @required String value}) {

    return ItemTextField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<String>(fieldName),
      onLongPress: () async {
        if (await canLaunch(value)) {
          await launch(value);
        } else {
          //TODO: use Snackbar
          print('Could not launch $value');
          /*showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: 'Could not launch $value',
          );*/
        }
      }
    );

  }

  Widget itemLongTextField({@required String fieldName, @required String value}) {

    return ItemTextField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<String>(fieldName),
      isLongText: true,
    );

  }

  Widget itemIntField({@required String fieldName, @required int value}) {

    return ItemIntField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<int>(fieldName),
    );

  }

  Widget itemMoneyField({@required String fieldName, @required double value}) {

    return ItemDoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.toStringAsFixed(2) + ' €'
          :
          null,
      update: _updateFieldFunction<double>(fieldName),
    );

  }

  Widget itemMoneySumField({@required String fieldName, @required double value}) {

    return ItemDoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.toStringAsFixed(2) + ' €'
          :
          null,
      editable: false,
    );

  }

  Widget itemPercentageField({@required String fieldName, @required double value}) {

    return ItemDoubleField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.toStringAsFixed(2) + ' %'
          :
          null,
      editable: false,
    );

  }

  Widget itemYearField({@required String fieldName, @required int value}) {

    return ItemYearField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<int>(fieldName),
    );

  }

  Widget itemDateTimeField({@required String fieldName, @required DateTime value}) {

    return ItemDateTimeField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<DateTime>(fieldName),
    );

  }

  Widget itemDurationField({@required String fieldName, @required Duration value}) {

    return ItemDurationField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<Duration>(fieldName),
    );

  }

  Widget itemRatingField({@required String fieldName, @required int value}) {

    return RatingField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<int>(fieldName),
    );

  }

  Widget itemBoolField({@required String fieldName, @required bool value}) {

    return BoolField(
      fieldName: fieldName,
      value: value,
      update: _updateFieldFunction<bool>(fieldName),
    );

  }

  Widget itemChipField({@required String fieldName, @required String value, @required List<String> possibleValues, List<Color> possibleValuesColours}) {

    return EnumField(
      fieldName: fieldName,
      value: value,
      enumValues: possibleValues,
      enumColours: possibleValuesColours,
      update: _updateFieldFunction<String>(fieldName),
    );

  }

  Widget itemListSingleRelation({@required Type itemType, String shownName}) {

    return BlocBuilder<ItemRelationBloc, ItemRelationState>(
      bloc: itemRelationBlocFunction(itemType)..add(LoadItemRelation()),
      builder: (BuildContext context, ItemRelationState state) {

        if(state is ItemRelationLoaded) {
          return ResultsListSingle(
            items: state.items,
            itemType: itemType,
            itemTypeName: shownName,
            onTap: _onTapFunction(context),
            onSearch: _repositorySearchFuture(context, itemType),
            updateAdd: _addRelationFunction(),
            updateDelete: _deleteRelationFunction(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            loadingBar(),
          ],
        );

      },
    );

  }

  Widget itemListManyRelation({@required Type itemType, String shownName, List<Widget> Function(List<CollectionItem>) trailingBuilder}) {

    return BlocBuilder<ItemRelationBloc, ItemRelationState>(
      bloc: itemRelationBlocFunction(itemType)..add(LoadItemRelation()),
      builder: (BuildContext context, ItemRelationState state) {

        if(state is ItemRelationLoaded) {
          return ResultsListMany(
            items: state.items,
            itemType: itemType,
            itemTypeName: shownName,
            onTap: _onTapFunction(context),
            onSearch: _repositorySearchFuture(context, itemType),
            updateAdd: _addRelationFunction(),
            updateDelete: _deleteRelationFunction(),
            trailingBuilder: trailingBuilder,
            onListSearch: state.items.isNotEmpty? _localSearchFuture(context, state.items) : null,
          );
        }
        if(state is ItemRelationNotLoaded) {
          return Center(
            child: Text(state.error),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            loadingBar(),
          ],
        );

      },
    );

  }

  Widget itemChipRelation({@required Type itemType, String shownName}) {

    return BlocBuilder<ItemRelationBloc, ItemRelationState>(
      bloc: itemRelationBlocFunction(itemType)..add(LoadItemRelation()),
      builder: (BuildContext context, ItemRelationState state) {

        if(state is ItemRelationLoaded) {
          return ResultsChipMany(
            selectedItems: state.items,
            items: state.items,
            itemType: itemType,
            itemTypeName: shownName,
            updateAdd: _addRelationFunction(),
            updateDelete: _deleteRelationFunction(),
          );
        }

        return Divider();

      },
    );

  }

  external List<Widget> itemFieldsBuilder(CollectionItem item);

  external List<Widget> itemRelationsBuilder();

  external ItemRelationBloc itemRelationBlocFunction(Type itemType);

}

class ItemGenericField<T> extends StatelessWidget {

  ItemGenericField({@required this.fieldName, @required this.value, this.shownValue, this.editable = true, @required this.onTap, this.onLongPress, @required this.update, this.extended = false});

  final String fieldName;
  final T value;
  final String shownValue;
  final bool editable;
  final Future<T> Function() onTap;
  final void Function() onLongPress;
  final void Function(T) update;

  final bool extended;

  @override
  Widget build(BuildContext context) {

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
            child: Text(shownValue?? "Unknown",),
          ),
        ],
      ),
      onTap: editable?
        () {
          onTap().then( (T newValue) {
            if (newValue != null) {
              update(newValue);
            }
          });
        } : null,
      onLongPress: onLongPress,
    )
    :
    ListTileTheme.merge(
      child: ListTile(
        title: Text(fieldName),
        trailing: Text(shownValue?? "Unknown"),
        onTap: editable?
          () {
            onTap().then( (T newValue) {
              if (newValue != null) {
                update(newValue);
              }
            });
          } : null,
        onLongPress: onLongPress,
      ),
    );

  }

}
class ItemTextField extends StatelessWidget {

  ItemTextField({@required this.fieldName, @required this.value, this.shownValue, this.onLongPress, @required this.update, this.isLongText = false});

  final String fieldName;
  final String value;
  final String shownValue;
  final void Function() onLongPress;
  final void Function(String) update;
  final bool isLongText;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
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

            MaterialLocalizations localizations = MaterialLocalizations.of(context);

            return AlertDialog(
              title: Text("Edit " + fieldName),
              content: TextField(
                controller: fieldController,
                keyboardType: isLongText? TextInputType.multiline : TextInputType.text,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: fieldName,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(localizations.cancelButtonLabel),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
                FlatButton(
                  child: Text(localizations.okButtonLabel),
                  onPressed: () {
                    Navigator.maybePop(context, fieldController.text.trim());
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
class ItemIntField extends StatelessWidget {

  ItemIntField({@required this.fieldName, @required this.value, @required this.update});

  final String fieldName;
  final int value;
  final void Function(int) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
      fieldName: fieldName,
      value: value,
      shownValue: value?.toString(),
      update: update,
      onTap: () {
        return showDialog<int>(
          context: context,
          builder: (BuildContext context) {

            MaterialLocalizations localizations = MaterialLocalizations.of(context);

            return NumberPickerDialog.integer(
              title: Text("Edit " + fieldName),
              initialIntegerValue: value,
              minValue: 1,
              maxValue: 10,
              cancelWidget: Text(localizations.cancelButtonLabel),
              confirmWidget: Text(localizations.okButtonLabel),
            );
          }
        );
      },
    );

  }

}
class ItemDoubleField extends StatelessWidget {

  ItemDoubleField({@required this.fieldName, @required this.value, this.shownValue, this.editable = true, @required this.update});

  final String fieldName;
  final double value;
  final String shownValue;
  final bool editable;
  final void Function(double) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
      editable: editable,
      update: update,
      onTap: () {
        return showDialog<double>(
            context: context,
            builder: (BuildContext context) {

              return DecimalPickerDialog(
                fieldName: fieldName,
                number: value,
              );
              
            }
        );
      },
    );

  }

}
class ItemYearField extends StatelessWidget {

  ItemYearField({@required this.fieldName, @required this.value, @required this.update});

  final String fieldName;
  final int value;
  final void Function(int) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
      fieldName: fieldName,
      value: value,
      shownValue: value?.toString(),
      update: update,
      onTap: () {
        return showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return YearPickerDialog(
                fieldName: fieldName,
                year: value,
              );
            }
        );
      },
    );

  }

}
class ItemDateTimeField extends StatelessWidget {

  ItemDateTimeField({@required this.fieldName, @required this.value, @required this.update});

  final String fieldName;
  final DateTime value;
  final void Function(DateTime) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
        fieldName: fieldName,
        value: value,
        shownValue: value != null?
            value.day.toString() + "/" + value.month.toString() + "/" + value.year.toString()
            :
            null,
        update: update,
        onTap: () {
          return showDatePicker(
            context: context,
            firstDate: DateTime(1970),
            lastDate: DateTime(2030),
            initialDate: value?? DateTime.now(),
          );
        },
    );

  }

}
class ItemDurationField extends StatelessWidget {

  ItemDurationField({@required this.fieldName, @required this.value, @required this.update});

  final String fieldName;
  final Duration value;
  final void Function(Duration) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.inHours.toString() + ":" + (value.inMinutes - (value.inHours * 60)).toString().padLeft(2, '0')
          :
          null,
      update: update,
      onTap: () {
        return showDialog<Duration>(
            context: context,
            builder: (BuildContext context) {

              return DurationPickerDialog(
                fieldName: fieldName,
                duration: value,
              );

            }
        );
      },
    );

  }

}


class RatingField extends StatelessWidget {

  RatingField({@required this.fieldName, @required this.value, this.update});

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
class BoolField extends StatelessWidget {

  BoolField({@required this.fieldName, @required this.value, this.update});

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
class EnumField extends StatelessWidget {

  const EnumField({Key key, @required this.fieldName, @required this.value, @required this.enumValues, this.enumColours, @required this.update}) : super(key: key);

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
          ).toList(),
        ),
      ],
    );

  }

}

class _HeaderText extends StatelessWidget {

  const _HeaderText({Key key, this.text, this.trailingWidget}) : super(key: key);

  final String text;
  final Widget trailingWidget;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(text, style: Theme.of(context).textTheme.subtitle1),
        trailingWidget?? Container(),
      ],
    );

  }

}

class _ResultsList extends StatelessWidget {

  const _ResultsList({Key key, @required this.headerText, @required this.resultList, this.linkWidget, this.trailingWidget, this.onListSearch}) : super(key: key);

  final String headerText;
  final Widget resultList;
  final Widget linkWidget;
  final Widget trailingWidget;
  final void Function() onListSearch;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: _HeaderText(
                  text: headerText,
                  trailingWidget: onListSearch != null?
                  IconButton(
                    icon: Icon(Icons.search),
                    tooltip: "Seach in List",
                    onPressed: onListSearch,
                  ) : null,
                ),
              ),
              resultList,
              SizedBox(
                width: double.maxFinite,
                child: linkWidget,
              ),
              trailingWidget?? Container(),
            ],
          ),
        ),
      ],
    );

  }

}
class _LinkButton extends StatelessWidget {

  const _LinkButton({Key key, @required this.itemType, this.itemTypeName, @required this.onSearch, @required this.updateAdd}) : super(key: key);

  final Type itemType;
  final String itemTypeName;
  final Future<CollectionItem> Function() onSearch;
  final void Function(CollectionItem) updateAdd;

  String get shownName => itemTypeName?? itemType.toString();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: RaisedButton.icon(
        label: Text("Link " + shownName),
        icon: Icon(Icons.link),
        elevation: 1.0,
        highlightElevation: 2.0,
        onPressed: () {

          onSearch().then( (CollectionItem result) {
            if (result != null) {
              updateAdd(result);
            }
          });

        },
      ),
    );

  }

}
class ResultsListSingle extends StatelessWidget {

  ResultsListSingle({@required this.items, @required this.itemType, this.itemTypeName, @required this.onTap, @required this.onSearch, @required this.updateAdd, @required this.updateDelete});

  final List<CollectionItem> items;
  final Type itemType;
  final String itemTypeName;
  final void Function(CollectionItem) onTap;
  final Future<CollectionItem> Function() onSearch;
  final void Function(CollectionItem) updateAdd;
  final void Function(CollectionItem) updateDelete;

  String get shownName => itemTypeName?? itemType.toString();

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: shownName,
      resultList: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          CollectionItem result = items[index];

          return DismissibleItem(
            item: result,
            dismissIcon: Icons.link_off,
            onDismissed: (DismissDirection direction) {
              updateDelete(result);
            },
            onTap: () {
              onTap(result);
            }
          );

        },
      ),
      linkWidget: items.isEmpty? _LinkButton(
          itemType: itemType,
          itemTypeName: itemTypeName,
          onSearch: onSearch,
          updateAdd: updateAdd,
        ) : null,
    );

  }

}
class ResultsListMany extends StatelessWidget {

  ResultsListMany({@required this.items, @required this.itemType, this.itemTypeName, @required this.onTap, @required this.onSearch, @required this.updateAdd, @required this.updateDelete, this.trailingBuilder, this.onListSearch});

  final List<CollectionItem> items;
  final Type itemType;
  final String itemTypeName;
  final void Function(CollectionItem) onTap;
  final Future<CollectionItem> Function() onSearch;
  final void Function(CollectionItem) updateAdd;
  final void Function(CollectionItem) updateDelete;
  final List<Widget> Function(List<CollectionItem>) trailingBuilder;
  final void Function() onListSearch;

  String get shownName => itemTypeName?? itemType.toString() + 's';

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: shownName + " (" + items.length.toString() + ")",
      resultList: Container(
        constraints: BoxConstraints.loose(
          Size.fromHeight( (MediaQuery.of(context).size.height / 3), ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            CollectionItem result = items[index];

            return DismissibleItem(
              item: result,
              dismissIcon: Icons.link_off,
              onDismissed: (DismissDirection direction) {
                updateDelete(result);
              },
              onTap: () {
                onTap(result);
              },
            );

          },
        ),
      ),
      linkWidget: _LinkButton(
        itemType: itemType,
        itemTypeName: itemTypeName,
        onSearch: onSearch,
        updateAdd: updateAdd,
      ),
      trailingWidget: trailingBuilder != null?
        Column(
          children: trailingBuilder(items),
        ) : null,
      onListSearch: onListSearch,
    );

  }

}
class ResultsChipMany extends StatelessWidget {

  const ResultsChipMany({Key key, @required this.items, @required this.selectedItems, @required this.itemType, this.itemTypeName, @required this.updateAdd, @required this.updateDelete}) : super(key: key);

  final List<CollectionItem> items;
  final List<CollectionItem> selectedItems;
  final Type itemType;
  final String itemTypeName;
  final Function(CollectionItem) updateAdd;
  final Function(CollectionItem) updateDelete;

  String get shownName => itemTypeName?? itemType.toString() + 's';

  @override
  Widget build(BuildContext context) {

    return _ResultsList(
      headerText: shownName,
      resultList: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        children: List<Widget>.generate(
          selectedItems.length + 1,
              (int index) {

            if(index == items.length) {

              return FilterChip(
                label: Text("Add more"),
                selected: true,
                onSelected: (bool selected) {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceEvenly,
                          children: List<Widget>.generate(
                            items.length,
                            (int index) {
                              CollectionItem option = items[index];

                              return FilterChip(
                                label: Text(option.getTitle()),
                                selected: selectedItems.contains(option),
                                onSelected: (bool selected) {

                                  if(selected) {
                                    updateAdd(option);
                                  } else {
                                    updateDelete(option);
                                  }

                                },
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  );
                },
              );

            }

            CollectionItem selection = selectedItems[index];

            return ChoiceChip(
              label: Text(selection.getTitle()),
              selected: true,
            );

          },
        ).toList(),
      ),
    );

  }

}

class YearPickerDialog extends StatefulWidget {
  YearPickerDialog({Key key, this.fieldName, this.year}) : super(key: key);

  final String fieldName;
  final int year;

  State<YearPickerDialog> createState() => YearPickerDialogState();
}
class YearPickerDialogState extends State<YearPickerDialog> {

  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.year != null? DateTime(widget.year) : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return Dialog(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(localizations.formatYear(_selectedDate), style: Theme.of(context).primaryTextTheme.subtitle1.copyWith( color: Colors.white),),
                  )
                ],
              ),
            ),
            Flexible(
              child: YearPicker(
                firstDate: DateTime(1970),
                lastDate: DateTime.now(),
                selectedDate: _selectedDate,
                onChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(localizations.cancelButtonLabel),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
                FlatButton(
                  child: Text(localizations.okButtonLabel),
                  onPressed: () {
                    Navigator.maybePop(context, _selectedDate.year);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

}

class DurationPickerDialog extends StatefulWidget {
  DurationPickerDialog({Key key, this.fieldName, this.duration}) : super(key: key);

  final String fieldName;
  final Duration duration;

  State<DurationPickerDialog> createState() => DurationPickerDialogState();
}
class DurationPickerDialogState extends State<DurationPickerDialog> {
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

    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return AlertDialog(
      title: Text("Edit " + widget.fieldName),
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
          child: Text(localizations.cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        FlatButton(
          child: Text(localizations.okButtonLabel),
          onPressed: () {
            Navigator.maybePop(context, Duration(hours: _hours, minutes: _minutes));
          },
        ),
      ],
    );
  }

}

class DecimalPickerDialog extends StatefulWidget {
  DecimalPickerDialog({Key key, this.fieldName, this.number}) : super(key: key);

  final String fieldName;
  final double number;

  State<DecimalPickerDialog> createState() => DecimalPickerDialogState();
}
class DecimalPickerDialogState extends State<DecimalPickerDialog> {
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

    MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return AlertDialog(
      title: Text("Edit " + widget.fieldName),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NumberPicker.integer(
              initialValue: _integerPart,
              minValue: 0,
              maxValue: 100,
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
          child: Text(localizations.cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        FlatButton(
          child: Text(localizations.okButtonLabel),
          onPressed: () {
            Navigator.maybePop(context, double.tryParse(_integerPart.toString() + "." + _decimalPart.toString().padLeft(2, '0')));
          },
        ),
      ],
    );
  }

}