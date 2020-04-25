import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/repository/collection_repository.dart';

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

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'item_search.dart';


Map<Type, ItemBloc> itemBlocs;

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

GameTab activeGameTab = GameTab.all;
ItemListBloc ItemListProvider(BuildContext context, MainTab activeTab) {

  switch(activeTab) {
    case MainTab.game:
      switch(activeGameTab) {
        case GameTab.all:
          return BlocProvider.of<AllListBloc>(context);
        case GameTab.game:
          return BlocProvider.of<GameListBloc>(context);
        case GameTab.rom:
          return BlocProvider.of<RomListBloc>(context);
      }
      return BlocProvider.of<GameListBloc>(context);
    case MainTab.dlc:
      return BlocProvider.of<DLCListBloc>(context);
    case MainTab.purchase:
      return BlocProvider.of<PurchaseListBloc>(context);
    case MainTab.store:
      return BlocProvider.of<StoreListBloc>(context);
    case MainTab.platform:
      return BlocProvider.of<PlatformListBloc>(context);
  }

}

Widget ItemDetailProvider(CollectionItem item) {

  int itemID = item.ID;

  switch(item.runtimeType) {
    case Game:
      return BlocProvider<GameDetailBloc>(
        create: (BuildContext context) {
          return GameDetailBloc(
            itemBloc: itemBlocs[Game],
          );
        },
        child: GameDetail(
          ID: itemID,
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
          ID: itemID,
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
          ID: itemID,
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
          ID: itemID,
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
          ID: itemID,
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

Widget ItemRepositorySearchProvider(Type itemType) {

  return BlocProvider<ItemRepositorySearchBloc>(
    create: (BuildContext context) {
      return ItemRepositorySearchBloc(
        collectionRepository: CollectionRepository(),
        itemType: itemType,
      )..add(SearchTextChanged('')); //put empty string first, so suggestions will be shown
    },
    child: ItemSearch<ItemRepositorySearchBloc>(
      searchType: itemType,
      itemBloc: itemBlocs[itemType],
      allowNewButton: true,
      onTapBehaviour: (BuildContext context, CollectionItem result) {
        return () {
          Navigator.maybePop(context, result);
        };
      },
    ),
  );

}

Widget ItemLocalSearchProvider(List<CollectionItem> itemList) {

  Type itemType = itemList.first.runtimeType;

  return BlocProvider<ItemLocalSearchBloc>(
    create: (BuildContext context) {
      return ItemLocalSearchBloc(
        itemType: itemType,
        itemList: itemList,
      )..add(SearchTextChanged('')); //put empty string first, so suggestions will be shown
    },
    child: ItemSearch<ItemLocalSearchBloc>(
      searchType: itemType,
      itemBloc: itemBlocs[itemType],
      allowNewButton: false,
      onTapBehaviour: (BuildContext context, CollectionItem result) {
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) {
                  return ItemDetailProvider(result);
                }
            ),
          );
        };
      },
    ),
  );

}