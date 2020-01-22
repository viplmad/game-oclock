import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity_search.dart';

import 'package:game_collection/loading_icon.dart';


const _addedMessage = "Linked";
const _failedAddMessage = "Unable to link";
const _updatedMessage = "Updated";
const _failedUpdateMessage = "Unable to update";
const _deletedMessage = "Unlinked";
const _failedDeleteMessage = "Unable to unlink";


class EntityView extends StatefulWidget {
  EntityView({Key key, @required this.entity}) : super(key: key);

  final Entity entity;

  @override
  State<EntityView> createState() => EntityViewState();
}
class EntityViewState extends State<EntityView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) {}

  void showSnackBar(String message){

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);

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
            child: RaisedButton(
              child: Text(addText),
              onPressed: () {
                showSearch<Entity>(
                  context: context,
                  delegate: EntitySearch(
                    searchTable: tableName,
                  ),
                ).then( (Entity result) {
                  if (result != null) {
                    newRelationFuture(result.ID).then( (dynamic data) {

                      showSnackBar(_addedMessage);

                    }, onError: (e) {

                      showSnackBar(_failedAddMessage);

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
            handleDelete: () {
              deleteRelationFuture(result.ID).then( (dynamic data) {

                showSnackBar(_deletedMessage + " " + result.getFormattedTitle());

              }, onError: (e) {

                showSnackBar(_failedDeleteMessage + " " + result.getFormattedTitle());

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

  Widget headerRelationText({@required String fieldName}) {

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
      child: Text(fieldName, style: Theme.of(context).textTheme.subhead),
    );

  }

  Widget attributeBuilder({@required String fieldName, @required String value}) {

    return ListTile(
      title: Text(fieldName),
      subtitle: Text(value),
    );

  }

  Widget _modifyAttributeBuilder({@required String fieldName, @required String value, String shownValue, TextInputType keyboardType, List<TextInputFormatter> inputFormatters, Function handleUpdate}) {

    return GestureDetector(
      child: this.attributeBuilder(
        fieldName: fieldName,
        value: shownValue?? value,
      ),
      onTap: () {
        TextEditingController fieldController = TextEditingController();
        fieldController.text = value;

        showDialog<String>(
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
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Accept"),
                    onPressed: () {
                      Navigator.maybePop(context, fieldController.text as dynamic);
                    },
                  ),
                ],
              );
            }
        ).then( (String newValue) {
          if (newValue != null) {
            handleUpdate(newValue);
          }
        });
      },
    );

  }

  Widget modifyTextAttributeBuilder({@required String fieldName, @required String value, Function(String) updateLocal}) {

    return _modifyAttributeBuilder(
        fieldName: fieldName,
        value: value,
        keyboardType: TextInputType.text,
        handleUpdate: (String newText) {
          getUpdateFuture(fieldName, newText).then( (dynamic data) {

            updateLocal(newText);
            showSnackBar(_updatedMessage);

          }, onError: (e) {

            showSnackBar(_failedUpdateMessage);

          });
        },
    );

  }

  Widget modifyIntAttributeBuilder({@required String fieldName, @required int value, Function(int) updateLocal}) {

    return _modifyAttributeBuilder(
        fieldName: fieldName,
        value: value.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        handleUpdate: (String newString) {

          int newInt = int.parse(newString);
          getUpdateFuture(fieldName, newInt).then( (dynamic data) {

            updateLocal(newInt);
            showSnackBar(_updatedMessage);

          }, onError: (e) {

            showSnackBar(_failedUpdateMessage);

          });
        },
    );

  }

  Widget modifyMoneyAttributeBuilder({@required String fieldName, @required double value, Function(double) updateLocal}) {

    return _modifyAttributeBuilder(
      fieldName: fieldName,
      value: value.toString(),
      shownValue: value.toString() + ' €',
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp(r'^\d{1,3}(\.\d{0,2}){0,1}$')),
      ],
      handleUpdate: (String newString) {

        double newMoney = double.parse(newString) * 100;
        getUpdateFuture(fieldName, newMoney).then( (dynamic data) {

          updateLocal(newMoney);
          showSnackBar(_updatedMessage);

        }, onError: (e) {

          showSnackBar(_failedUpdateMessage);

        });
      },
    );

  }

  Widget modifyYearAttributeBuilder({@required String fieldName, @required int value, Function(int) updateLocal}) {

    return GestureDetector(
      child: this.attributeBuilder(
        fieldName: fieldName,
        value: value?.toString() ?? "Unknown",
      ),
      onTap: () {
        showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return YearPickerDialog(
                fieldName: fieldName,
                year: value,
              );
            }
        ).then( (int newYear) {
          if (newYear != null) {
            getUpdateFuture(fieldName, newYear).then( (dynamic data) {

              updateLocal(newYear);
              showSnackBar(_updatedMessage);

            }, onError: (e) {

              showSnackBar(_failedUpdateMessage);

            });
          }
        });
      },
    );

  }

  Widget modifyDateAttributeBuilder({@required String fieldName, @required DateTime value, DatePickerMode pickerMode = DatePickerMode.day, Function(DateTime) updateLocal}) {

    return GestureDetector(
      child: this.attributeBuilder(
        fieldName: fieldName,
        value: value != null?
            value.day.toString() + "/" + value.month.toString() + "/" + value.year.toString()
            :
            "Unknown",
      ),
      onTap: () {
        showDatePicker(
          context: context,
          firstDate: DateTime(1970),
          lastDate: DateTime(2030),
          initialDate: value?? DateTime.now(),
          initialDatePickerMode: pickerMode,
        ).then( (DateTime newDate) {
          if (newDate != null) {
            getUpdateFuture(fieldName, newDate).then( (dynamic data) {

              updateLocal(newDate);
              showSnackBar(_updatedMessage);

            }, onError: (e) {

              showSnackBar(_failedUpdateMessage);

            });
          }
        });
      },
    );

  }

  Widget modifyRatingAttributeBuilder({@required String fieldName, @required int value, Function(int) updateLocal}) {

    return GestureDetector(
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              headerRelationText(
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

  Widget modifyEnumAttributeBuilder({@required String fieldName, @required String value, @required List<String> listOptions, @required void Function(String) updateLocal}) {

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
            onSelected: onUpdate<bool, String>(
              fieldName: fieldName,
              updateLocal: updateLocal,
              altUpdateValue: option,
            ),
          );
        },
      ).toList(),
    );

  }

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

  void handleUpdate<T, K>({@required String fieldName, @required T newValue, @required void Function(K) updateLocal, K altUpdateValue}) {

    startUpdate();

    getUpdateFuture(fieldName, altUpdateValue?? newValue).then( (dynamic data) {

      updateLocal(altUpdateValue?? newValue);
      showSnackBar(_updatedMessage);

    }, onError: (e) {

      showSnackBar(_failedUpdateMessage);
      print(e);

    }).whenComplete( () {
      endUpdate();
    });

  }

  Widget modifyDurationAttributeBuilder({@required String fieldName, @required Duration value, Function(Duration) updateLocal}) {

    return GestureDetector(
      child: this.attributeBuilder(
        fieldName: fieldName,
        value: value != null?
            value.inHours.toString() + ":" + (value.inMinutes - (value.inHours * 60)).toString()
            :
            "Unknown",
      ),
      onTap: () {
        showDialog<Duration>(
            context: context,
            builder: (BuildContext context) {
              return DurationPickerDialog(
                fieldName: fieldName,
                duration: value,
              );
            }
        ).then( (Duration newDuration) {
          if (newDuration != null) {
            //convert to seconds
            getUpdateFuture(fieldName, newDuration.inSeconds).then( (dynamic data) {

              updateLocal(newDuration);
              showSnackBar(_updatedMessage);

            }, onError: (e) {

              showSnackBar(_failedUpdateMessage);

            });
          }
        });
      },
    );

  }

  Widget modifyBoolAttributeBuilder({@required String fieldName, @required bool value, Function(bool) updateLocal}) {

    return SwitchListTile(
      title: Text(fieldName),
      value: value,
      onChanged: onUpdate(
        fieldName: fieldName,
        updateLocal: updateLocal,
      )
    );

  }

  Widget streamBuilderEntitiesAsChips({@required Stream<List<Entity>> entityStream, @required Stream<List<Entity>> allOptionsStream, @required String tableName, String fieldName, Future<dynamic> Function(int) newRelationFuture, Future<dynamic> Function(int) deleteRelationFuture}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        this.headerRelationText(
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
                                                    showSnackBar(_updatedMessage);


                                                  }, onError: (e) {

                                                    showSnackBar(_failedUpdateMessage);

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
                            showSnackBar(_addedMessage + " " + optionName);


                          }, onError: (e) {

                            showSnackBar(_failedAddMessage + " " + optionName);

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
        this.headerRelationText(
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
        this.headerRelationText(
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

  List<Widget> getListFields() {}

  @override
  Widget build(BuildContext context) {

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
              flexibleSpace: FlexibleSpaceBar(
                title: Text(getEntity().getFormattedTitle()),
                collapseMode: CollapseMode.parallax,
                background: Padding(
                  padding: const EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
                  child: FlutterLogo(),
                ),
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