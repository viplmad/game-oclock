import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_detail.dart';


class TagDetailBloc extends ItemDetailBloc<Tag> {

  TagDetailBloc({
    @required TagBloc itemBloc
  }) : super(itemBloc: itemBloc);

  @override
  Stream<Tag> getReadIDStream(LoadItem event) {

    return collectionRepository.getTagWithID(event.ID);

  }

}