import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

class ItemDetailBar extends StatelessWidget {

  const ItemDetailBar({Key key, @required this.item, @required this.listFields}) : super(key: key);

  final CollectionItem item;
  final List<Widget> listFields;

  @override
  Widget build(BuildContext context) {

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
        children: listFields,
      ),
    );

  }

}