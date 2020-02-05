import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/ui/item_detail.dart';

import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/model/model.dart';

import 'package:game_collection/ui/common/loading_icon.dart';
import 'package:game_collection/ui/common/show_snackbar.dart';


class DLCDetail extends StatelessWidget {

  const DLCDetail({Key key, this.ID}) : super(key: key);

  final int ID;

  @override
  Widget build(BuildContext context) {

    return BlocProvider<DLCDetailBloc>(
      create: (BuildContext context) {
        return DLCDetailBloc(
          itemBloc: BlocProvider.of<DLCBloc>(context),
        )..add(LoadItem(ID));
      },
      child: Scaffold(
        body: DLCDetailBar(),
      ),
    );

  }

}

class DLCDetailBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocListener<ItemBloc, ItemState>(
      bloc: BlocProvider.of<DLCBloc>(context),
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
        bloc: BlocProvider.of<DLCDetailBloc>(context),
        builder: (BuildContext context, ItemDetailState state) {

          if(state is ItemLoaded) {

            DLC dlc = state.item;

            return ItemDetailBar(
              item: dlc,
              listFields: DLCDetailFields(context, dlc),
            );

          }

          return LoadingIcon();

        },
      ),
    );

  }

  List<Widget> DLCDetailFields(BuildContext context, DLC dlc) {

    return [
      ItemTextField(
        fieldName: dlc_nameField,
        value: dlc.name,
        update: (String newValue) {
          BlocProvider.of<DLCBloc>(context).add(
            UpdateItemField(
              dlc,
              dlc_nameField,
              newValue,
            ),
          );
        },
        onTap: () {
          TextEditingController fieldController = TextEditingController();
          fieldController.text = dlc.name;

          return showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Edit " + dlc_nameField),
                content: TextField(
                  controller: fieldController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: dlc_nameField,
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
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.maybePop(context, fieldController.text);
                    },
                  ),
                ],
              );
            },
          );
        },
      )
    ];

  }

}

class ItemTextField<T> extends StatelessWidget {

  ItemTextField({@required this.fieldName, @required this.value, this.shownValue, @required this.onTap, @required this.update});

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
        trailing: Text(shownValue?? value?? "Unknown"),
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