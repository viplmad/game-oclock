import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity_search.dart';

import 'package:game_collection/loading_icon.dart';

class EntityView extends StatefulWidget {
  EntityView({Key key, @required this.entity}) : super(key: key);

  final Entity entity;

  @override
  State<EntityView> createState() => EntityViewState();
}
class EntityViewState extends State<EntityView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String message){

    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    scaffoldKey.currentState.showSnackBar(snackBar);

  }

  Widget _getResults({@required List<Entity> results, @required int itemCount, @required String tableName, @required String addText, bool isSingle, Function handleNew, Function handleDelete}) {

    return ListView.builder(
      shrinkWrap: true,
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
                    handleNew(result);
                  }
                });
              },
            ),
          );

        } else {
          Entity result = results[index];

          return result.getModifyCard(
            context,
            handleDelete: () => handleDelete(result),
          );

        }
      },
    );

  }

  Widget showResults({@required List results, @required String tableName, @required String addText, Function handleNew, Function handleDelete}) {

    return _getResults(
      results: results,
      itemCount: results.length + 1,
      tableName: tableName,
      addText: addText,
      isSingle: false,
      handleNew: handleNew,
      handleDelete: handleDelete,
    );

  }

  Widget showResultsNonExpandable({@required Entity result, @required String tableName, @required String addText, Function handleNew, Function handleDelete}) {

    return _getResults(
        results: [result],
        itemCount: 1,
        tableName: tableName,
        addText: addText,
        isSingle: true,
        handleNew: handleNew,
        handleDelete: handleDelete,
    );

  }

  Widget attributeBuilder({@required String fieldName, @required String value}) {

    return ListTile(
      title: Text(fieldName),
      subtitle: Text(value),
    );

  }

  Widget _modifyAttributeBuilder({@required String fieldName, @required String value, Function handleUpdate, TextInputType keyboardType, List<TextInputFormatter> inputFormatters}) {

    return GestureDetector(
      child: this.attributeBuilder(
        fieldName: fieldName,
        value: value,
      ),
      onTap: () {
        TextEditingController fieldController = TextEditingController();
        fieldController.text = value;

        showDialog<dynamic>(
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
        ).then( (dynamic newValue) {
          if (newValue != null) {
            handleUpdate(newValue);
          }
        });
      },
    );

  }

  Widget modifyTextAttributeBuilder({@required String fieldName, @required String value, Function handleUpdate}) {

    return _modifyAttributeBuilder(
        fieldName: fieldName,
        value: value,
        handleUpdate: handleUpdate,
        keyboardType: TextInputType.text,
    );

  }

  Widget headerRelationText({@required String fieldName}) {

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
      child: Text(fieldName, style: Theme.of(context).textTheme.subhead),
    );

  }

  Widget modifyDoubleAttributeBuilder({@required String fieldName, @required double value, Function handleUpdate}) {

    return _modifyAttributeBuilder(
      fieldName: fieldName,
      value: value.toString(),
      handleUpdate: (String newValue) {
        handleUpdate(double.parse(newValue));
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp(r'^\d{1,3}(\.\d{0,2}){0,1}$')),
      ],
    );

  }

  Widget modifyYearAttributeBuilder({@required String fieldName, @required int value, Function handleUpdate}) {

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
            handleUpdate(newYear);
          }
        });
      },
    );

  }

  Widget modifyDateAttributeBuilder({@required String fieldName, @required DateTime value, DatePickerMode pickerMode = DatePickerMode.day, Function handleUpdate}) {

    return GestureDetector(
      child: this.attributeBuilder(
        fieldName: fieldName,
        value: value?.toIso8601String() ?? "Unknown",
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
            handleUpdate(newDate);
          }
        });
      },
    );

  }

  Widget streamBuilderEntities({@required Stream<List<Entity>> entityStream, @required String tableName, String addText, Function handleNew, Function handleDelete}) {

    addText = addText?? "Add " + tableName;

    return StreamBuilder(
      stream: entityStream,
      builder: (BuildContext context, AsyncSnapshot<List<Entity>> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        return this.showResults(
            results: snapshot.data,
            tableName: tableName,
            addText: addText,
            handleNew: handleNew,
            handleDelete: handleDelete,
        );

      },
    );
  }

  Widget streamBuilderEntity({@required Stream<Entity> entityStream, @required String tableName, String addText, Function handleNew, Function handleDelete}) {

    addText = addText?? "Add " + tableName;

    return StreamBuilder(
      stream: entityStream,
      builder: (BuildContext context, AsyncSnapshot<Entity> snapshot) {
        if(!snapshot.hasData) { return LoadingIcon(); }

        return this.showResultsNonExpandable(
            result: snapshot.data.ID < 0? null : snapshot.data,
            tableName: tableName,
            addText: addText,
            handleNew: handleNew,
            handleDelete: handleDelete,
        );

      },
    );

  }

  List<Widget> getListFields() {}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.entity.getFormattedTitle()),
      ),
      body: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
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
            ButtonTheme.bar(
              child: ButtonBar(
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
            ),
          ],
        ),
      ),
    );

  }

}