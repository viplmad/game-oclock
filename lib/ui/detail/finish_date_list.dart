import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';


// ignore: must_be_immutable
abstract class FinishDateList<T extends CollectionItem, K extends RelationBloc<T, DateTime>, S extends RelationManagerBloc<T, DateTime>> extends StatelessWidget {
  FinishDateList({
    Key key,
    @required this.fieldName,
    @required this.value,
    @required this.relationTypeName,
    @required this.onUpdate,
  }) : super(key: key);

  final String fieldName;
  final DateTime value;
  final String relationTypeName;
  final void Function() onUpdate;

  bool _hasUpdated = false;

  @override
  Widget build(BuildContext outerContext) {

    String shownValue = value != null? GameCollectionLocalisations.of(outerContext).dateString(value) : '';

    return BlocListener<S, RelationManagerState>(
      listener: (BuildContext context, RelationManagerState state) {
        if(state is RelationAdded<DateTime>) {
          _hasUpdated = true;

          String message = GameCollectionLocalisations.of(context).addedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is RelationNotAdded) {
          String message = GameCollectionLocalisations.of(context).unableToAddString(relationTypeName);
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
        if(state is RelationDeleted<DateTime>) {
          _hasUpdated = true;

          String message = GameCollectionLocalisations.of(context).deletedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
          );
        }
        if(state is RelationNotDeleted) {
          String message = GameCollectionLocalisations.of(context).unableToDeleteString(relationTypeName);
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
      child: ListTileTheme.merge(
        child: ListTile(
          title: Text(fieldName),
          trailing: BlocBuilder<K, RelationState>(
            builder: (BuildContext context, RelationState state) {
              String extra = '';
              if(state is RelationLoaded<DateTime>) {

                extra = state.otherItems.length > 1? '(+)' : '';

              }

              return Text(shownValue + ' ' + extra);
            },
          ),
          onTap: () {

            showDialog(
              context: outerContext,
              builder: (BuildContext context) {

                return WillPopScope(
                  onWillPop: () {

                    if(_hasUpdated) { onUpdate(); }
                    return Future<bool>.value(true);

                  },
                  child: AlertDialog(
                    title: Text(fieldName),
                    content: Container(
                      width: double.maxFinite,
                      child: BlocBuilder<K, RelationState>(
                        cubit: BlocProvider.of<K>(outerContext),
                        builder: (BuildContext context, RelationState state) {

                          if(state is RelationLoaded<DateTime>) {

                            final List<DateTime> values = state.otherItems;

                            if(values.isEmpty) {
                              return Text(GameCollectionLocalisations.of(context).emptyFinishDatesString);
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime date = values.elementAt(index);
                                String dateString = GameCollectionLocalisations.of(context).dateString(date);

                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
                                  child: ListTile(
                                    title: Text(dateString),
                                    trailing: IconButton(
                                      icon: Icon(Icons.link_off),
                                      onPressed: () {
                                        BlocProvider.of<S>(outerContext).add(
                                          DeleteRelation<DateTime>(date),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          if(state is RelationNotLoaded) {
                            return Center(
                              child: Text(state.error),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              LinearProgressIndicator(),
                            ],
                          );
                        },

                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(GameCollectionLocalisations.of(context).addString(relationTypeName)),
                        onPressed: () {

                          showDatePicker(
                            context: context,
                            firstDate: DateTime(1970),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                          ).then((DateTime value) {
                            if(value != null) {
                              BlocProvider.of<S>(outerContext).add(
                                AddRelation<DateTime>(value),
                              );
                            }
                          });

                        },
                      ),
                      FlatButton(
                        child: Text(MaterialLocalizations.of(context).okButtonLabel),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                    ],
                  ),
                );

              },
            );

          },
        ),
      ),
    );

  }

  Widget backgroundBuilder(AlignmentGeometry alignment, IconData dismissIcon) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
      ),
      child: Align(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Icon(dismissIcon, color: Colors.white),
        ),
        alignment: alignment,
      ),
    );

  }
}