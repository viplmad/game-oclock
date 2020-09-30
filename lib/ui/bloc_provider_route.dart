import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';
import 'bloc_storage.dart';

import 'package:game_collection/bloc/connection/connection.dart';
import 'start.dart';

import 'package:game_collection/model/app_tab.dart';
import 'package:game_collection/bloc/maintab/maintab.dart';
import 'package:game_collection/bloc/item/item.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'homepage.dart';

import 'package:game_collection/model/model.dart';
import 'detail/detail.dart';
import 'statistics/statistiscs.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'item_search.dart';


Widget StartProvider() {

  return BlocProvider<ConnectionBloc>(
    create: (BuildContext context) {
      return ConnectionBloc(
        collectionRepository: CollectionRepository(),
      )..add(Connect());
    },
    child: StartPage(),
  );

}

Widget EssentialProvider() {

  itemBlocs = {
    Game : GameBloc(
      collectionRepository: CollectionRepository(),
    ),
    DLC : DLCBloc(
      collectionRepository: CollectionRepository(),
    ),
    Platform : PlatformBloc(
      collectionRepository: CollectionRepository(),
    ),
    Purchase : PurchaseBloc(
      collectionRepository: CollectionRepository(),
    ),
    Store : StoreBloc(
      collectionRepository: CollectionRepository(),
    ),
    System : SystemBloc(
      collectionRepository: CollectionRepository(),
    ),
    Tag : TagBloc(
      collectionRepository: CollectionRepository(),
    ),
    PurchaseType : TypeBloc(
      collectionRepository: CollectionRepository(),
    ),
  };

  return HomepageProvider();

}

Widget HomepageProvider() {

  return MultiBlocProvider(
    providers: [
      BlocProvider<MainTabBloc>(
        create: (BuildContext context) {
          return MainTabBloc()..add(UpdateMainTab(MainTab.game));
        },
      ),

      BlocProvider<AllListBloc>(
        create: (BuildContext context) {
          return AllListBloc(
            itemBloc: itemBlocs[Game],
          )..add(LoadItemList());
        },
      ),
      BlocProvider<GameListBloc>(
        create: (BuildContext context) {
          return GameListBloc(
            itemBloc: itemBlocs[Game],
          )..add(LoadItemList());
        },
      ),
      BlocProvider<RomListBloc>(
        create: (BuildContext context) {
          return RomListBloc(
            itemBloc: itemBlocs[Game],
          )..add(LoadItemList());
        },
      ),
      BlocProvider<DLCListBloc>(
        create: (BuildContext context) {
          return DLCListBloc(
            itemBloc: itemBlocs[DLC],
          )..add(LoadItemList());
        },
      ),
      BlocProvider<PlatformListBloc>(
        create: (BuildContext context) {
          return PlatformListBloc(
            itemBloc: itemBlocs[Platform],
          )..add(LoadItemList());
        },
      ),
      BlocProvider<PurchaseListBloc>(
        create: (BuildContext context) {
          return PurchaseListBloc(
            itemBloc: itemBlocs[Purchase],
          )..add(LoadItemList());
        },
      ),
      BlocProvider<StoreListBloc>(
        create: (BuildContext context) {
          return StoreListBloc(
            itemBloc: itemBlocs[Store],
          )..add(LoadItemList());
        },
      ),

      BlocProvider<DLCDetailBloc>(
        create: (BuildContext context) {
          return DLCDetailBloc(
            itemBloc: BlocProvider.of<DLCBloc>(context),
          );
        },
      ),
      BlocProvider<PlatformDetailBloc>(
        create: (BuildContext context) {
          return PlatformDetailBloc(
            itemBloc: BlocProvider.of<PlatformBloc>(context),
          );
        },
      ),
      BlocProvider<PurchaseDetailBloc>(
        create: (BuildContext context) {
          return PurchaseDetailBloc(
            itemBloc: BlocProvider.of<PurchaseBloc>(context),
          );
        },
      ),
      BlocProvider<StoreDetailBloc>(
        create: (BuildContext context) {
          return StoreDetailBloc(
            itemBloc: BlocProvider.of<StoreBloc>(context),
          );
        },
      ),
    ],
    child: Homepage(),
  );

}

Widget ItemDetailProvider<T extends CollectionItem>(T item) {

  switch(T) {
    case Game:
      return BlocProvider<GameDetailBloc>(
        create: (BuildContext context) {
          return GameDetailBloc(
            itemBloc: itemBlocs[Game],
          );
        },
        child: GameDetail(
          game: item as Game,
        ),
      );
    case DLC:
      return BlocProvider<DLCDetailBloc>(
        create: (BuildContext context) {
          return DLCDetailBloc(
            itemBloc: itemBlocs[DLC],
          );
        },
        child: DLCDetail(
          dlc: item as DLC,
        ),
      );
    case Platform:
      return BlocProvider<PlatformDetailBloc>(
        create: (BuildContext context) {
          return PlatformDetailBloc(
            itemBloc: itemBlocs[Platform],
          );
        },
        child: PlatformDetail(
          platform: item as Platform,
        ),
      );
    case Purchase:
      return BlocProvider<PurchaseDetailBloc>(
        create: (BuildContext context) {
          return PurchaseDetailBloc(
            itemBloc: itemBlocs[Purchase],
          );
        },
        child: PurchaseDetail(
          purchase: item as Purchase,
        ),
      );
    case Store:
      return BlocProvider<StoreDetailBloc>(
        create: (BuildContext context) {
          return StoreDetailBloc(
            itemBloc: itemBlocs[Store],
          );
        },
        child: StoreDetail(
          store: item as Store,
        ),
      );
    case System:
      return Center(
        child: Text("This is a System"),
      );
    case Tag:
      return Center(
        child: Text("This is a Tag"),
      );
    case PurchaseType:
      return Center(
        child: Text("This is a Type"),
      );
  }

  return Center();

}

Widget ItemRepositorySearchProvider<T extends CollectionItem>() {

  return ItemSearch<T>(
    itemSearchBloc: ItemRepositorySearchBloc<T>(
      collectionRepository: CollectionRepository(),
    )..add(SearchTextChanged('')),
    itemBloc: itemBlocs[T],
    allowNewButton: true,
    onTapBehaviour: (BuildContext context, T result) {
      return () {
        Navigator.maybePop<T>(context, result);
      };
    },
  );

}

Widget ItemLocalSearchProvider<T extends CollectionItem>(List<T> itemList) {

  return ItemSearch<T>(
    itemSearchBloc: ItemLocalSearchBloc<T>(
      itemList: itemList,
    )..add(SearchTextChanged('')),
    itemBloc: itemBlocs[T],
    allowNewButton: false,
    onTapBehaviour: (BuildContext context, T result) {
      return () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ItemDetailProvider<T>(result);
            },
          ),
        );
      };
    },
  );

}

Widget ItemStatisticsProvider<T extends CollectionItem>(List<T> itemList, String viewName) {

  switch(T) {
    case Game:
      return GameStatistics(
        yearData: GamesData(
          games: itemList as List<Game>,
        ).getYearData(2020),
      );
    case DLC:
      return Center();
    case Platform:
      return Center();
    case Purchase:
      return PurchaseStatistics(
        yearData: PurchasesData(
          purchases: itemList as List<Purchase>,
        ).getYearData(2020),
      );
    case Store:
      return Center();
    case System:
      return Center(
        child: Text("This is a System"),
      );
    case Tag:
      return Center(
        child: Text("This is a Tag"),
      );
    case PurchaseType:
      return Center(
        child: Text("This is a Type"),
      );
  }

  return Center();

}