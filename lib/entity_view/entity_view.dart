import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity_search.dart';

import 'package:game_collection/loading_icon.dart';
import 'package:game_collection/show_snackbar.dart';


const _linkedMessage = "Linked";
const _failedLinkMessage = "Unable to link";
const _updatedMessage = "Updated";
const _failedUpdateMessage = "Unable to update";
const _unlinkMessage = "Unlinked";
const _failedUnlinkMessage = "Unable to unlink";


class EntityView extends StatefulWidget {
  EntityView({Key key, @required this.entity}) : super(key: key);

  final Entity entity;

  @override
  State<EntityView> createState() => EntityViewState();
}
class EntityViewState extends State<EntityView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MaterialLocalizations localizations;

  void _showSnackBar(String message, {SnackBarAction snackBarAction}){

    showSnackBar(
      scaffoldState: scaffoldKey.currentState,
      message: message,
      seconds: 2,
      snackBarAction: snackBarAction,
    );

  }
  SnackBarAction _errorInfoSnackBarAction({@required String errorTitle, @required String errorMessage}) {

    return dialogSnackBarAction(
      context,
      label: 'More',
      title: errorTitle,
      content: errorMessage,
    );

  }

  bool _isUpdating = false;

  void startUpdate() {
    setState(() {
      _isUpdating = true;
    });
  }
  void endUpdate() {
    setState(() {
      _isUpdating = false;
    });
  }
  bool isUpdating() { return _isUpdating; }

  Entity getEntity() => widget.entity;

  external Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue);

  external String getImageURL();
  external Future<dynamic> getImageUpdateFuture(String imagePath);

  Function(T) onUpdate<T, K>({@required String fieldName, @required void Function(K) updateLocal, K altUpdateValue, K Function(T) applyTransformation}) {

    return isUpdating()?
        null
        :
        (T newValue) {

          handleUpdate(
            fieldName: fieldName,
            newValue: (applyTransformation == null)? newValue : applyTransformation(newValue),
            updateLocal: updateLocal,
            altUpdateValue: altUpdateValue,
          );

        };

  }

  void handleUpdate<T, K>({@required String fieldName, @required T newValue, @required void Function(K) updateLocal, K altUpdateValue, K Function(T) transform}) {

    startUpdate();

    var updateValue = (transform == null)? newValue : transform(newValue);

    getUpdateFuture(fieldName, updateValue).then( (dynamic data) {

      updateLocal(updateValue);
      _showSnackBar(_updatedMessage);

    }, onError: (e) {

      _showSnackBar(
        _failedUpdateMessage,
        snackBarAction: _errorInfoSnackBarAction(
          errorTitle: _failedUpdateMessage,
          errorMessage: e.toString(),
        ),
      );

    }).whenComplete( () {
      endUpdate();
    });

  }

  Widget modifyBoolAttributeBuilder({@required String fieldName, @required bool value, Function(bool) updateLocal}) {

    return SwitchListTile(
        title: Text(fieldName),
        value: value,
        onChanged: onUpdate<bool, bool>(
          fieldName: fieldName,
          updateLocal: updateLocal,
        )
    );

  }

  Widget _headerRelationText({@required String fieldName}) {

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
      child: Text(fieldName, style: Theme.of(context).textTheme.subhead),
    );

  }

  Widget _genericModifyAttributeBuilder<T, K>({@required String fieldName, @required T value, String shownValue, @required Future<T> Function() onTap, void Function(K) updateLocal, K Function(T) transform}) {

    return ListTileTheme.merge(
      child: ListTile(
        title: Text(fieldName),
        trailing: Text(shownValue?? value?? "Unknown"),
        enabled: !isUpdating(),
        onTap: () {
          onTap().then( (T newValue) {
            if (newValue != null) {
              handleUpdate<T, K>(
                fieldName: fieldName,
                newValue: newValue,
                updateLocal: updateLocal,
                transform: transform,
              );
            }
          });
        },
      ),
    );

  }

  Widget _modifyTextFieldBuilder<K>({@required String fieldName, @required String value, String shownValue, TextInputType keyboardType, List<TextInputFormatter> inputFormatters, @required void Function(K) updateLocal, K Function(String) transform}) {

    return _genericModifyAttributeBuilder<String, K>(
        fieldName: fieldName,
        value: value,
        shownValue: shownValue,
        onTap: () {
          TextEditingController fieldController = TextEditingController();
          fieldController.text = value;

          return showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Edit " + fieldName),
                  content: TextField(
                    controller: fieldController,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
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
                        Navigator.maybePop(context, fieldController.text);
                      },
                    ),
                  ],
                );
              }
          );
        },
        transform: transform,
        updateLocal: updateLocal,
    );

  }

  Widget _modifyIntPickerAttributeBuilder({@required String fieldName, @required int value, String shownValue, @required void Function(int) updateLocal}) {

    return _genericModifyAttributeBuilder<int, int>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
      onTap: () {
        return showDialog<int>(
            context: context,
            builder: (BuildContext context) {
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
      updateLocal: updateLocal,
    );

  }

  Widget _modifyDoublePickerAttributeBuilder({@required String fieldName, @required double value, String shownValue, @required void Function(double) updateLocal}) {

    return _genericModifyAttributeBuilder<double, double>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
      onTap: () {
        return showDialog<double>(
            context: context,
            builder: (BuildContext context) {
              return NumberPickerDialog.decimal(
                title: Text("Edit " + fieldName),
                initialDoubleValue: value,
                decimalPlaces: 2,
                minValue: 0,
                maxValue: 100,
                cancelWidget: Text(localizations.cancelButtonLabel),
                confirmWidget: Text(localizations.okButtonLabel),
              );
            }
        );
      },
      updateLocal: updateLocal,
    );

  }

  Widget _modifyYearPickerAttributeBuilder({@required String fieldName, @required int value, String shownValue, @required Function(int) updateLocal}) {

    return _genericModifyAttributeBuilder<int, int>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
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
      updateLocal: updateLocal,
    );

  }

  Widget _modifyDateTimeAttributeBuilder({@required String fieldName, @required DateTime value, String shownValue, @required Function(DateTime) updateLocal}) {

    return _genericModifyAttributeBuilder<DateTime, DateTime>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
      onTap: () {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1970),
          lastDate: DateTime(2030),
          initialDate: value?? DateTime.now(),
        );
      },
      updateLocal: updateLocal,
    );

  }

  Widget _modifyDurationPickerAttributeBuilder({@required String fieldName, @required Duration value, String shownValue, @required void Function(Duration) updateLocal}) {

    return _genericModifyAttributeBuilder<Duration, Duration>(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue,
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
      updateLocal: updateLocal,
    );

  }

  Widget _modifyChoiceChipAttributeBuilder({@required String fieldName, @required String value, @required List<String> listOptions, @required void Function(String) updateLocal}) {

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceEvenly,
      children: List<Widget>.generate(
        listOptions.length,
        (int index) {
          String option = listOptions[index];

          return ChoiceChip(
            label: Text(option),
            selected: value == option,
            onSelected: (bool newChoice) {
              handleUpdate<bool, String>(
                  fieldName: fieldName,
                  newValue: newChoice,
                  updateLocal: updateLocal,
                  transform: (bool newBool) => option,
              );
            },
          );
        },
      ).toList(),
    );

  }

  Widget modifyTextAttributeBuilder({@required String fieldName, @required String value, @required void Function(String) updateLocal}) {

    return _modifyTextFieldBuilder<String>(
      fieldName: fieldName,
      value: value,
      keyboardType: TextInputType.text,
      updateLocal: updateLocal,
    );

  }

  Widget modifyIntAttributeBuilder({@required String fieldName, @required int value, @required void Function(int) updateLocal}) {

    return _modifyIntPickerAttributeBuilder(
      fieldName: fieldName,
      value: value,
      shownValue: value?.toString(),
      updateLocal: updateLocal,
    );

  }

  Widget modifyMoneyAttributeBuilder({@required String fieldName, @required double value, @required void Function(double) updateLocal}) {

    return _modifyDoublePickerAttributeBuilder(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.toString() + ' €'
          :
          null,
      updateLocal: updateLocal,
    );

  }

  Widget modifyYearAttributeBuilder({@required String fieldName, @required int value, @required void Function(int) updateLocal}) {

    return _modifyYearPickerAttributeBuilder(
      fieldName: fieldName,
      value: value,
      shownValue: value?.toString(),
      updateLocal: updateLocal,
    );

  }

  Widget modifyDateAttributeBuilder({@required String fieldName, @required DateTime value, @required void Function(DateTime) updateLocal}) {

    return _modifyDateTimeAttributeBuilder(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.day.toString() + "/" + value.month.toString() + "/" + value.year.toString()
          :
          null,
      updateLocal: updateLocal,
    );

  }

  Widget modifyDurationAttributeBuilder({@required String fieldName, @required Duration value, @required void Function(Duration) updateLocal}) {

    return _modifyDurationPickerAttributeBuilder(
        fieldName: fieldName,
        value: value,
        shownValue: value != null?
            value.inHours.toString() + ":" + (value.inMinutes - (value.inHours * 60)).toString()
            :
            null,
        updateLocal: updateLocal,
    );

  }

  Widget modifyEnumAttributeBuilder({@required String fieldName, @required String value, @required List<String> listOptions, @required void Function(String) updateLocal}) {

    return _modifyChoiceChipAttributeBuilder(
        fieldName: fieldName,
        value: value,
        listOptions: listOptions,
        updateLocal: updateLocal,
    );

  }

  Widget modifyRatingAttributeBuilder({@required String fieldName, @required int value, Function(int) updateLocal}) {

    return GestureDetector(
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _headerRelationText(
                fieldName: fieldName,
              ),
            ],
          ),
          SmoothStarRating(
            allowHalfRating: false,
            onRatingChanged: onUpdate<double, int>(
              fieldName: fieldName,
              updateLocal: updateLocal,
              applyTransformation: (double newRating) {
                if(newRating == value.roundToDouble()) {
                  return 0;
                }
                return newRating.toInt();
              },
            ),
            starCount: 10,
            rating: value.roundToDouble(),
            color: isUpdating()? Colors.grey : Colors.yellow,
            borderColor: Colors.yellow,
            size: 40.0,
          ),
        ],
      ),
    );

  }

  Widget _getResults({@required List<Entity> results, @required int itemCount, @required String tableName, @required String addText, bool isSingle, Future<dynamic> Function(int) newRelationFuture, Future<dynamic> Function(int) deleteRelationFuture}) {

    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {

        if(isSingle && results[0] == null
            || index == results.length) {

          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: RaisedButton.icon(
              label: Text(addText),
              icon: Icon(Icons.link),
              elevation: 1.0,
              highlightElevation: 2.0,
              onPressed: () {
                showSearch<Entity>(
                  context: context,
                  delegate: EntitySearch(
                    searchTable: tableName,
                  ),
                ).then( (Entity result) {
                  if (result != null) {
                    newRelationFuture(result.ID).then( (dynamic data) {

                      _showSnackBar(_linkedMessage);

                    }, onError: (e) {

                      _showSnackBar(
                        _failedLinkMessage,
                        snackBarAction: _errorInfoSnackBarAction(
                          errorTitle: _failedLinkMessage,
                          errorMessage: e.toString(),
                        ),
                      );

                    });
                  }
                });
              },
            ),
          );

        } else {
          Entity result = results[index];

          return result.getDismissibleCard(
            context: context,
            deleteIcon: Icons.link_off,
            handleDelete: () {
              deleteRelationFuture(result.ID).then( (dynamic data) {

                _showSnackBar(_unlinkMessage + " " + result.getFormattedTitle());

              }, onError: (e) {

                _showSnackBar(
                  _failedUnlinkMessage + " " + result.getFormattedTitle(),
                  snackBarAction: _errorInfoSnackBarAction(
                    errorTitle: _failedUnlinkMessage,
                    errorMessage: e.toString(),
                  ),
                );

              });
            },
          );

        }
      },
    );

  }

  Widget showResults({@required List results, @required String tableName, @required String addText, Future<dynamic> Function(int) newRelationFuture, Future<dynamic> Function(int) deleteRelationFuture}) {

    return _getResults(
      results: results,
      itemCount: results.length + 1,
      tableName: tableName,
      addText: addText,
      isSingle: false,
      newRelationFuture: newRelationFuture,
      deleteRelationFuture: deleteRelationFuture,
    );

  }

  Widget showResultsNonExpandable({@required Entity result, @required String tableName, @required String addText, Future<dynamic> Function(int) newRelationFuture, Future<dynamic> Function(int) deleteRelationFuture}) {

    return _getResults(
        results: [result],
        itemCount: 1,
        tableName: tableName,
        addText: addText,
        isSingle: true,
      newRelationFuture: newRelationFuture,
      deleteRelationFuture: deleteRelationFuture,
    );

  }

  Widget streamBuilderEntitiesAsChips({@required Stream<List<Entity>> entityStream, @required Stream<List<Entity>> allOptionsStream, @required String tableName, String fieldName, Future<dynamic> Function(int) newRelationFuture, Future<dynamic> Function(int) deleteRelationFuture}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        this._headerRelationText(
          fieldName: fieldName?? tableName + 's',
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: entityStream,
            builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
              if(!snapshot.hasData) { return LoadingIcon(); }

              List<Entity> listOptions = snapshot.data;

              return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceEvenly,
                  children: List<Widget>.generate(
                    listOptions.length + 1,
                    (int index) {
                      if(index == listOptions.length) {

                        return FilterChip(
                          label: Text("Link new " + tableName),
                          selected: true,
                          onSelected: (bool selected) {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  child: StreamBuilder(
                                      stream: allOptionsStream,
                                      builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
                                        if(!snapshot.hasData) { return LoadingIcon(); }

                                        List<Entity> listAllOptions = snapshot.data;

                                        return Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          alignment: WrapAlignment.spaceEvenly,
                                          children: List<Widget>.generate(
                                            listAllOptions.length,
                                            (int index) {
                                              Entity allOption = listAllOptions[index];

                                              String optionName = allOption.getFormattedTitle();

                                              return FilterChip(
                                                label: Text(optionName),
                                                selected: listOptions.any( (Entity myOption) => myOption.getFormattedTitle() == allOption.getFormattedTitle() ),
                                                onSelected: (bool selected) {
                                                  newRelationFuture(allOption.ID).then( (dynamic data) {

                                                    //updateLocal(selected);
                                                    _showSnackBar(_updatedMessage);


                                                  }, onError: (e) {

                                                    _showSnackBar(_failedUpdateMessage);

                                                  });
                                                },
                                              );
                                            },
                                          ).toList(),
                                        );
                                      }
                                  ),

                                );
                              },
                            );
                          },
                        );

                      }
                      Entity option = listOptions[index];

                      String optionName = option.getFormattedTitle();

                      return FilterChip(
                        label: Text(optionName),
                        selected: true,
                        onSelected: (bool selected) {
                          deleteRelationFuture(option.ID).then( (dynamic data) {

                            //updateLocal(selected);
                            _showSnackBar(_linkedMessage + " " + optionName);


                          }, onError: (e) {

                            _showSnackBar(_failedLinkMessage + " " + optionName);

                          });
                        },
                      );
                    },
                  ).toList(),
                );

            },
          ),
        ),
      ],
    );

  }

  Widget streamBuilderEntities({@required Stream<List<Entity>> entityStream, @required String tableName, String fieldName, String addText, Future<dynamic> Function(int) newRelationFuture, Future<dynamic> Function(int) deleteRelationFuture}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        this._headerRelationText(
          fieldName: fieldName?? tableName + 's',
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: entityStream,
            builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
              if(!snapshot.hasData) { return LoadingIcon(); }

              return this.showResults(
                results: snapshot.data,
                tableName: tableName,
                addText: addText?? "Link " + tableName,
                newRelationFuture: newRelationFuture,
                deleteRelationFuture: deleteRelationFuture,
              );

            },
          ),
        ),
      ],
    );

  }

  Widget streamBuilderEntity({@required Stream<Entity> entityStream, @required String tableName, String fieldName, String addText, Future<dynamic> Function(int) newRelationFuture, Future<dynamic> Function(int) deleteRelationFuture}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        this._headerRelationText(
          fieldName: fieldName?? tableName + 's',
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: entityStream,
            builder: (BuildContext context, AsyncSnapshot<Entity> snapshot) {
              if(!snapshot.hasData) { return LoadingIcon(); }

              return this.showResultsNonExpandable(
                result: snapshot.data.ID < 0? null : snapshot.data,
                tableName: tableName,
                addText: addText?? "Link " + tableName,
                newRelationFuture: newRelationFuture,
                deleteRelationFuture: deleteRelationFuture,
              );

            },
          ),
        ),
      ],
    );

  }

  external List<Widget> getListFields();

  @override
  Widget build(BuildContext context) {

    localizations = MaterialLocalizations.of(context);

    return Scaffold(
      key: scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: GestureDetector(
                child: FlexibleSpaceBar(
                  title: Hero(
                    tag: getEntity().getUniqueID() + 'text',
                    child: Text(getEntity().getFormattedTitle()),
                    flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation, HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) {
                      return DefaultTextStyle(
                        style: DefaultTextStyle.of(toHeroContext).style,
                        child: toHeroContext.widget,
                      );
                    },
                  ),
                  collapseMode: CollapseMode.parallax,
                  background: getImageURL() != null?
                      //TODO: does not change when new image
                      CachedNetworkImage(
                        imageUrl: getImageURL(),
                        fit: BoxFit.cover,
                        useOldImageOnUrlChange: false,
                        placeholder: (BuildContext context, String url) => LoadingIcon(),
                        errorWidget: (BuildContext context, String url, Object error) => null,
                      )
                      :
                      null,
                ),
                onTap: () {
                  //TODO: refactor
                  showModalBottomSheet<File>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        child: FlatButton(
                          child: Text("Upload image"),
                          onPressed: () async {
                            File file = await ImagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            Navigator.maybePop(context, file);
                          },
                        ),
                      );
                    },
                  ).then( (File imagePicked) {
                    if(imagePicked != null) {
                      startUpdate();
                      getImageUpdateFuture(
                          imagePicked.path
                      ).then( (dynamic) {
                        _showSnackBar("Image successfully added");
                      }, onError: (e) {
                        _showSnackBar(
                          "Unable to update image",
                          snackBarAction: _errorInfoSnackBarAction(
                            errorTitle: "Unable to update image",
                            errorMessage: e.toString(),
                          ),
                        );
                      }).whenComplete(() {
                        endUpdate();
                      });
                    }
                  });
                },
              ),
            ),
          ];
        },
        body: ListView(
          children: this.getListFields(),
        ),
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
                    child: Text(localizations.formatYear(_selectedDate), style: Theme.of(context).primaryTextTheme.subhead.copyWith( color: Colors.white),),
                  )
                ],
              ),
            ),
            Flexible(
              child: YearPicker(
                firstDate: DateTime(1970),
                lastDate: DateTime(2030),
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
          Text(':', style: Theme.of(context).textTheme.title,),
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