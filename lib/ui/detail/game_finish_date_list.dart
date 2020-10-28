import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';

class GameFinishDateList extends StatelessWidget {
  const GameFinishDateList({
    Key key,
    @required this.fieldName,
    @required this.relationTypeName,
  }) : super(key: key);

  final String fieldName;
  final String relationTypeName;

  @override
  Widget build(BuildContext outerContext) {

    return BlocListener<FinishGameRelationManagerBloc, RelationManagerState>(
      listener: (BuildContext context, RelationManagerState state) {
        if(state is RelationAdded<DateTime>) {
          String message = GameCollectionLocalisations.of(context).addedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
            snackBarAction: SnackBarAction(
              label: GameCollectionLocalisations.of(context).undoString,
              onPressed: () {

                BlocProvider.of<FinishGameRelationManagerBloc>(context).add(
                  DeleteRelation<DateTime>(
                    state.otherItem,
                  ),
                );

              },
            ),
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
          String message = GameCollectionLocalisations.of(context).deletedString(relationTypeName);
          showSnackBar(
            scaffoldState: Scaffold.of(context),
            message: message,
            snackBarAction: SnackBarAction(
              label: GameCollectionLocalisations.of(context).undoString,
              onPressed: () {

                BlocProvider.of<FinishGameRelationManagerBloc>(context).add(
                  AddRelation<DateTime>(
                    state.otherItem,
                  ),
                );

              },
            ),
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
      child: BlocBuilder<FinishDateRelationBloc, RelationState>(
        builder: (BuildContext context, RelationState state) {

          if(state is RelationLoaded<DateTime>) {

            final List<DateTime> values = state.otherItems;

            String shownDate;
            if(values.isNotEmpty) {
              shownDate = GameCollectionLocalisations.of(context).dateString(values.first);
            }
            final String shownValue = shownDate != null? values.length > 1? shownDate + ' (+)' : shownDate : '';

            return ListTileTheme.merge(
              child: ListTile(
                title: Text(fieldName),
                trailing: Text(shownValue),
                onTap: () {

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {

                      return AlertDialog(
                        title: Text(fieldName),
                        content: Container(
                          width: double.maxFinite,
                          child: BlocBuilder<FinishDateRelationBloc, RelationState>(
                            cubit: BlocProvider.of<FinishDateRelationBloc>(outerContext),
                            builder: (BuildContext context, RelationState state) {
                              if(state is RelationLoaded<DateTime>) {

                                final List<DateTime> values = state.otherItems;

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: values.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    DateTime date = values.elementAt(index);
                                    String dateString = GameCollectionLocalisations.of(context).dateString(date);

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
                                      child: Dismissible(
                                        key: ValueKey<DateTime>(date),
                                        child: ListTile(
                                          title: Text(dateString),
                                        ),
                                        background: backgroundBuilder(Alignment.centerLeft, Icons.link_off),
                                        secondaryBackground: backgroundBuilder(Alignment.centerRight, Icons.link_off),
                                        onDismissed: (DismissDirection direction) {
                                          BlocProvider.of<FinishGameRelationManagerBloc>(outerContext).add(
                                            DeleteRelation<DateTime>(date),
                                          );
                                        },
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
                                  BlocProvider.of<FinishGameRelationManagerBloc>(outerContext).add(
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
                      );

                    },
                  );

                },
              ),
            );

          }

          if(state is RelationNotLoaded) {
            return Center(
              child: Text(state.error),
            );
          }

          return Column(
            children: [
              ListTileTheme.merge(
                child: ListTile(
                  title: Text(fieldName),
                ),
              ),
              LinearProgressIndicator(),
            ],
          );

        },
      ),
    );

  }Widget backgroundBuilder(AlignmentGeometry alignment, IconData dismissIcon) {

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