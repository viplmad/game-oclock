import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/tag.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_list.dart';


class TagListBloc extends ItemListBloc {

  TagListBloc({
    @required ItemBloc itemBloc,
  }) : super(itemBloc: itemBloc);

  @override
  Stream<List<Tag>> getReadStream() {

    return collectionRepository.getAllTags();

  }

}