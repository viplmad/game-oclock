import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';


class DismissibleItem extends StatelessWidget {
  DismissibleItem({Key key, @required this.dismissibleKey, @required this.itemWidget, @required this.onDismissed, @required this.dismissIcon, this.confirmDismiss}) : super(key: key);

  final int dismissibleKey;
  final Widget itemWidget;
  final void Function(DismissDirection direction) onDismissed;
  final Future<bool> Function(DismissDirection direction) confirmDismiss;
  final IconData dismissIcon;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
      child: Dismissible(
        key: ValueKey<int>(dismissibleKey),
        background: backgroundBuilder(Alignment.centerLeft),
        secondaryBackground: backgroundBuilder(Alignment.centerRight),
        child: itemWidget,
        onDismissed: onDismissed,
        confirmDismiss: confirmDismiss,
      ),
    );

  }

  Widget backgroundBuilder(AlignmentGeometry alignment) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
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

class ItemCard extends StatelessWidget {
  const ItemCard({Key key, @required this.title, this.subtitle, this.imageURL, @required this.onTap}) : super(key: key);

  final String title;
  final String subtitle;
  final String imageURL;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        child: _ItemListTile(
          title: title,
          subtitle: subtitle,
          imageURL: imageURL,
        ),
        onTap: onTap,
      ),
      margin: EdgeInsets.all(0.0),
    );
  }

}

class _ItemListTile extends StatelessWidget {
  const _ItemListTile({Key key, @required this.title, this.subtitle, this.imageURL}) : super(key: key);

  final String title;
  final String subtitle;
  final String imageURL;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: imageURL != null?
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 100,
              minHeight: 44,
              maxWidth: 100,
              maxHeight: 80,
            ),
            child: CachedImage(
              imageURL: imageURL,
              fit: BoxFit.scaleDown,
              backgroundColour: Colors.white,
              applyGradient: false,
            ),
          )
          : null,
      title: Text(title),
      subtitle: subtitle != null?
          Text(subtitle)
          : null,
    );

  }

}

class ItemGrid extends StatelessWidget {
  const ItemGrid({Key key, @required this.title, this.imageURL, @required this.onTap}) : super(key: key);

  final String title;
  final String imageURL;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4.0),),
        child: _ItemGridTile(
          title: title,
          imageURL: imageURL,
        ),
        onTap: onTap,
      ),
    );
  }

}

class _ItemGridTile extends StatelessWidget {

  const _ItemGridTile({Key key, @required this.title, this.imageURL}) : super(key: key);

  final String title;
  final String imageURL;

  @override
  Widget build(BuildContext context) {

    return GridTile(
      child: imageURL != null?
        CachedImage(
          imageURL: imageURL,
          fit: BoxFit.cover,
          backgroundColour: Colors.black,
          applyGradient: false,
        ) : Container(),
      footer: Container(
        color: Colors.black.withOpacity(0.5),
        child: Text(title, style: TextStyle(fontSize: 18.0, color: Colors.white),),
      ),
    );

  }

}

class CachedImage extends StatelessWidget {
  const CachedImage({Key key, @required this.imageURL, @required this.fit, @required this.backgroundColour, this.applyGradient = false}) : super(key: key);

  final String imageURL;
  final BoxFit fit;
  final Color backgroundColour;
  final bool applyGradient;

  @override
  Widget build(BuildContext context) {

    return imageURL.isNotEmpty?
      applyGradient? _getGradientImage() : _getCachedImage()
      : Container();

  }

  Widget _getGradientImage() {

    return Container(
      color: Colors.black,
      child: Opacity(
        opacity: 0.75,
        child: _getCachedImage(),
      ),
    );

  }

  CachedNetworkImage _getCachedImage() {

    return CachedNetworkImage(
      imageUrl: imageURL,
      fit: fit,
      useOldImageOnUrlChange: true,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: CircularProgressIndicator(value: downloadProgress.progress),
        );
      },
      errorWidget: (BuildContext context, String url, Object error) => Container(color: backgroundColour),
    );

  }

}

class ItemChip extends StatelessWidget {
  const ItemChip({Key key, @required this.title, this.selected = true, this.onTap}) : super(key: key);

  final String title;
  final bool selected;
  final Function(bool) onTap;

  @override
  Widget build(BuildContext context) {

    return FilterChip(
      label: Text(title),
      selected: selected,
      onSelected: onTap,
    );

  }

}