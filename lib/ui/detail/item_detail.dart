import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:game_collection/ui/common/loading_icon.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';
import 'package:game_collection/ui/common/item_view.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'package:game_collection/model/model.dart';

abstract class ItemDetailBody extends StatelessWidget {

  ItemDetailBody({Key key, @required this.itemID, @required this.itemDetailBloc}) : super(key: key);

  final int itemID;
  final ItemDetailBloc itemDetailBloc;
  CollectionItem item;

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
      },
      child: BlocBuilder<ItemDetailBloc, ItemDetailState> (
        bloc: itemDetailBloc,
        builder: (BuildContext context, ItemDetailState state) {

          if(state is ItemLoaded) {

            item = state.item;
            return listHolder(context);

          }
          if(state is ItemNotLoaded) {
            return Center(
              child: Text(state.error),
            );
          }

          return LoadingIcon();

        },
      ),
    );

  }

  Widget listHolder(BuildContext context) {

    return NestedScrollView(
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
                  tag: item.getUniqueID() + 'text',
                  child: Text(item.getTitle()),
                  flightShuttleBuilder: (BuildContext flightContext, Animation<double> animation, HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) {
                    return DefaultTextStyle(
                      style: DefaultTextStyle.of(toHeroContext).style,
                      child: toHeroContext.widget,
                    );
                  },
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
          ),
        ];
      },
      body: ListView(
        children: itemDetailFields(context),
      ),
    );

  }

  external List<Widget> itemDetailFields(BuildContext context);

}

class ItemGenericField<T> extends StatelessWidget {

  ItemGenericField({@required this.fieldName, @required this.value, this.shownValue, @required this.onTap, @required this.update});

  final String fieldName;
  final T value;
  final String shownValue;
  final Future<T> Function() onTap;
  final Function(T) update;

  @override
  Widget build(BuildContext context) {

    return ListTileTheme.merge(
      child: ListTile(
        title: Text(fieldName),
        trailing: Text(shownValue?? "Unknown"),
        onTap: () {
          onTap().then( (T newValue) {
            if (newValue != null) {
              update(newValue);
            }
          });
        },
      ),
    );

  }

}
class ItemTextField extends StatelessWidget {

  ItemTextField({@required this.fieldName, @required this.value, this.shownValue, @required this.update});

  final String fieldName;
  final String value;
  final String shownValue;
  final Function(String) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
      fieldName: fieldName,
      value: value,
      shownValue: shownValue?? value,
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
                keyboardType: TextInputType.text,
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
          },
        );
      },
    );

  }

}
class ItemIntField extends StatelessWidget {

  ItemIntField({@required this.fieldName, @required this.value, @required this.update});

  final String fieldName;
  final int value;
  final Function(int) update;

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
class ItemMoneyField extends StatelessWidget {

  ItemMoneyField({@required this.fieldName, @required this.value, @required this.update});

  final String fieldName;
  final double value;
  final Function(double) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.toString() + ' €'
          :
          null,
      update: update,
      onTap: () {
        return showDialog<double>(
            context: context,
            builder: (BuildContext context) {

              MaterialLocalizations localizations = MaterialLocalizations.of(context);

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
    );

  }

}
class ItemYearField extends StatelessWidget {

  ItemYearField({@required this.fieldName, @required this.value, @required this.update});

  final String fieldName;
  final int value;
  final Function(int) update;

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
  final Function(DateTime) update;

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
  final Function(Duration) update;

  @override
  Widget build(BuildContext context) {

    return ItemGenericField(
      fieldName: fieldName,
      value: value,
      shownValue: value != null?
          value.inHours.toString() + ":" + (value.inMinutes - (value.inHours * 60)).toString()
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
                padding: const EdgeInsets.only(left: 16.0, top:16.0, right: 16.0),
                child: Text(fieldName, style: Theme.of(context).textTheme.subhead),
              ),
            ],
          ),
          SmoothStarRating(
            allowHalfRating: false,
            starCount: 10,
            rating: value.roundToDouble(),
            color: Colors.yellow,
            borderColor: Colors.orangeAccent,
            size: 40.0,
            onRatingChanged: (double newRating) {
              if (newRating != null) {
                update(newRating.toInt());
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

class ResultsListSingle extends StatelessWidget {

  ResultsListSingle({this.items, this.tableName, this.onTap, this.updateAdd, this.updateDelete});

  final List<CollectionItem> items;
  final String tableName;
  final Function(CollectionItem) onTap;
  final Function(CollectionItem) updateAdd;
  final Function(CollectionItem) updateDelete;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {

        if(items.isEmpty) {

          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: RaisedButton.icon(
              label: Text("Link " + tableName),
              icon: Icon(Icons.link),
              elevation: 1.0,
              highlightElevation: 2.0,
              onPressed: () {
                /*showSearch<CollectionItem>(
                  context: context,
                  delegate: EntitySearch(
                    searchTable: tableName,
                  ),
                ).then( (CollectionItem result) {
                  if (result != null) {
                    updateAdd(result);
                  }
                });*/
              },
            ),
          );

        } else {
          CollectionItem result = items[index];

          return DismissibleItem(
            item: result,
            dismissIcon: Icons.link_off,
            onDismissed: (DismissDirection direction) {
              updateDelete(result);
            },
            onTap: onTap(result),
          );

        }
      },
    );

  }

}
class ResultsListMany extends StatelessWidget {

  ResultsListMany({this.items, this.tableName, this.onTap, this.updateAdd, this.updateDelete});

  final List<CollectionItem> items;
  final String tableName;
  final Function(CollectionItem) onTap;
  final Function(CollectionItem) updateAdd;
  final Function(CollectionItem) updateDelete;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {

        if(index == items.length) {

          return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: RaisedButton.icon(
              label: Text("Link " + tableName),
              icon: Icon(Icons.link),
              elevation: 1.0,
              highlightElevation: 2.0,
              onPressed: () {
                /*showSearch<CollectionItem>(
                  context: context,
                  delegate: EntitySearch(
                    searchTable: tableName,
                  ),
                ).then( (CollectionItem result) {
                  if (result != null) {
                    updateAdd(result);
                  }
                });*/
              },
            ),
          );

        } else {
          CollectionItem result = items[index];

          return DismissibleItem(
            item: result,
            dismissIcon: Icons.link_off,
            onDismissed: (DismissDirection direction) {
              updateDelete(result);
            },
            onTap: onTap(result),
          );

        }
      },
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