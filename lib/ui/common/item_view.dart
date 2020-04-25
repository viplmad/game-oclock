import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:game_collection/model/collection_item.dart';

import 'loading_icon.dart';

class DismissibleItem extends StatelessWidget {

  DismissibleItem({Key key, @required this.item, @required this.onTap, @required this.onDismissed, this.dismissIcon = Icons.delete, this.confirmDismiss}) : super(key: key);

  final CollectionItem item;
  final void Function(DismissDirection direction) onDismissed;
  final void Function() onTap;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final IconData dismissIcon;

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: ValueKey(item.ID),
      background: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                Icon(dismissIcon, color: Colors.white,),
                Icon(dismissIcon, color: Colors.white,),
              ],
            ),
          )
      ),
      child: ItemListCard(
        item: item,
        onTap: onTap,
      ),
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
    );

  }

}

class ItemListCard extends StatelessWidget {

  const ItemListCard({Key key, @required this.item, @required this.onTap}) : super(key: key);

  final CollectionItem item;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: _ItemListTile(
          item: item,
        ),
        onTap: onTap,
      ),
    );
  }

}

class _ItemListTile extends StatelessWidget {

  const _ItemListTile({Key key, @required this.item}) : super(key: key);

  final CollectionItem item;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: item.getImageURL() != null?
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 100,
              minHeight: 44,
              maxWidth: 100,
              maxHeight: 80,
            ),
            child: CachedImage(
              imageURL: item.getImageURL(),
              fit: BoxFit.scaleDown,
              applyGradient: false,
            ),//CachedNetworkImage(
          )
          : null,
      title: Text(item.getTitle()),
      subtitle: item.getSubtitle() != null?
          Text(item.getSubtitle())
          : null,
    );

  }

}

class ItemGridCard extends StatelessWidget {

  const ItemGridCard({Key key, @required this.item, @required this.onTap}) : super(key: key);

  final CollectionItem item;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: _ItemGridTile(
          item: item,
        ),
        onTap: onTap,
      ),
    );
  }

}

class _ItemGridTile extends StatelessWidget {

  const _ItemGridTile({Key key, @required this.item}) : super(key: key);

  final CollectionItem item;

  @override
  Widget build(BuildContext context) {

    return GridTile(
      child: CachedImage(
        imageURL: item.getImageURL(),
        fit: BoxFit.cover,
        applyGradient: false,
      ),
      footer: Container(
        color: Colors.black.withOpacity(0.5),
        child: Text(item.getTitle(), style: TextStyle(fontSize: 18.0, color: Colors.white),),
      ),
    );

  }

}

class CachedImage extends StatelessWidget {

  const CachedImage({Key key, @required this.imageURL, @required this.fit, this.backgroundColour = Colors.black, this.applyGradient = false}) : super(key: key);

  final String imageURL;
  final BoxFit fit;
  final Color backgroundColour;
  final bool applyGradient;

  @override
  Widget build(BuildContext context) {

    return imageURL != null?
      applyGradient?
        Container(
          color: Colors.black,
          child: Opacity(
            opacity: 0.75,
            child: _getCachedImage(),
          ),
        ) : _getCachedImage()
        : Container();

  }

  CachedNetworkImage _getCachedImage() {

    return CachedNetworkImage(
      imageUrl: imageURL,
      fit: fit,
      useOldImageOnUrlChange: true,
      placeholder: (BuildContext context, String url) => LoadingIcon(),
      errorWidget: (BuildContext context, String url, Object error) => Container( color: backgroundColour, ),
    );

  }

}

class ItemChip extends StatelessWidget {

  const ItemChip({Key key, this.item, this.selected = true, this.onTap}) : super(key: key);

  final CollectionItem item;
  final bool selected;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {

    return FilterChip(
      label: Text(item.getTitle()),
      selected: selected,
      onSelected: onTap,
    );

  }

}