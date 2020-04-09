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
      child: ItemCard(
        item: item,
        onTap: onTap,
      ),
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
    );

  }

}

class ItemCard extends StatelessWidget {

  const ItemCard({Key key, @required this.item, @required this.onTap}) : super(key: key);

  final CollectionItem item;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: ItemListTile(
          item: item,
        ),
        onTap: onTap,
      ),
    );
  }

}

class ItemListTile extends StatelessWidget {

  const ItemListTile({Key key, @required this.item}) : super(key: key);

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

class CachedImage extends StatelessWidget {

  const CachedImage({Key key, @required this.imageURL, @required this.fit, this.applyGradient = false}) : super(key: key);

  final String imageURL;
  final BoxFit fit;
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
      errorWidget: (BuildContext context, String url, Object error) => Container(),
    );

  }

}

class ItemGridTile extends StatelessWidget {

  const ItemGridTile({Key key, @required this.item}) : super(key: key);

  final CollectionItem item;

  @override
  Widget build(BuildContext context) {

    return GridTile(
      child: CachedImage(
        imageURL: item.getImageURL(),
        fit: BoxFit.cover,
        applyGradient: false,
      ),
      footer: Text(item.getTitle()),
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