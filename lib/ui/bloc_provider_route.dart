import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

import 'package:game_collection/bloc/connection/connection.dart';
import 'start.dart';

import 'package:game_collection/model/app_tab.dart';
import 'package:game_collection/bloc/tab/tab.dart';
import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'homepage.dart';


Widget StartBlocProvider() {

  return BlocProvider<ConnectionBloc>(
    create: (BuildContext context) {
      return ConnectionBloc(
        collectionRepository: CollectionRepository(),
      )..add(AppStarted());
    },
    child: StartPage(),
  );

}

Widget EssentialProvider() {

  return MultiBlocProvider(
    providers: [
      BlocProvider<GameBloc>(
        create: (BuildContext context) {
          return GameBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
      BlocProvider<DLCBloc>(
        create: (BuildContext context) {
          return DLCBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
      BlocProvider<PlatformBloc>(
        create: (BuildContext context) {
          return PlatformBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
      BlocProvider<PurchaseBloc>(
        create: (BuildContext context) {
          return PurchaseBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
      BlocProvider<StoreBloc>(
        create: (BuildContext context) {
          return StoreBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
      BlocProvider<SystemBloc>(
        create: (BuildContext context) {
          return SystemBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
      BlocProvider<TagBloc>(
        create: (BuildContext context) {
          return TagBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
      BlocProvider<TypeBloc>(
        create: (BuildContext context) {
          return TypeBloc(
            collectionRepository: CollectionRepository(),
          );
        },
      ),
    ],
    child: HomepageProvider(),
  );

}

Widget HomepageProvider() {

  return MultiBlocProvider(
    providers: [
      BlocProvider<TabBloc>(
        create: (BuildContext context) {
          return TabBloc()..add(UpdateTab(AppTab.game));
        },
      ),
      BlocProvider<GameListBloc>(
        create: (BuildContext context) {
          return GameListBloc(
            itemBloc: BlocProvider.of<GameBloc>(context),
          )..add(LoadItemList());
        },
      ),
      BlocProvider<DLCListBloc>(
        create: (BuildContext context) {
          return DLCListBloc(
            itemBloc: BlocProvider.of<DLCBloc>(context),
          )..add(LoadItemList());
        },
      ),
      BlocProvider<PlatformListBloc>(
        create: (BuildContext context) {
          return PlatformListBloc(
            itemBloc: BlocProvider.of<PlatformBloc>(context),
          )..add(LoadItemList());
        },
      ),
      BlocProvider<PurchaseListBloc>(
        create: (BuildContext context) {
          return PurchaseListBloc(
            itemBloc: BlocProvider.of<PurchaseBloc>(context),
          )..add(LoadItemList());
        },
      ),
      BlocProvider<StoreListBloc>(
        create: (BuildContext context) {
          return StoreListBloc(
            itemBloc: BlocProvider.of<StoreBloc>(context),
          )..add(LoadItemList());
        },
      ),

      BlocProvider<GameDetailBloc>(
        create: (BuildContext context) {
          return GameDetailBloc(
            itemBloc: BlocProvider.of<GameBloc>(context),
          );
        },
      ),
      BlocProvider<DLCDetailBloc>(
        create: (BuildContext context) {
          return DLCDetailBloc(
            itemBloc: BlocProvider.of<DLCBloc>(context),
          );
        },
      ),
    ],
    child: Homepage(),
  );

}

Widget SearchProvider() {

  return Center();

}