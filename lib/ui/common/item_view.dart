import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';


class DismissibleItem extends StatelessWidget {
  const DismissibleItem({
    Key? key,
    required this.dismissibleKey,
    required this.itemWidget,
    required this.onDismissed,
    required this.dismissIcon,
    this.padding = const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 4.0, top: 4.0),
    this.confirmDismiss,
  }) : super(key: key);

  final String dismissibleKey;
  final Widget itemWidget;
  final void Function(DismissDirection direction) onDismissed;
  final IconData dismissIcon;
  final EdgeInsetsGeometry padding;
  final Future<bool> Function(DismissDirection direction)? confirmDismiss;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: padding,
      child: Dismissible(
        key: ValueKey<String>(dismissibleKey),
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
      decoration: const BoxDecoration(
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
  const ItemCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.hasImage,
    this.imageURL,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? trailing;
  final bool hasImage;
  final String? imageURL;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        child: _ItemListTile(
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          hasImage: hasImage,
          imageURL: imageURL,
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
      margin: const EdgeInsets.all(0.0),
    );
  }
}

class _ItemListTile extends StatelessWidget {
  const _ItemListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.hasImage,
    this.imageURL,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? trailing;
  final bool hasImage;
  final String? imageURL;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: hasImage?
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 100,
              minHeight: 44,
              maxWidth: 100,
              maxHeight: 80,
            ),
            child: CachedImage(
              imageURL: imageURL?? '',
              fit: BoxFit.scaleDown,
              backgroundColour: Colors.white,
              applyGradient: false,
            ),
          )
          : null,
      title: Text(title),
      subtitle: subtitle != null?
          Text(subtitle!)
          : null,
      trailing: trailing != null?
      Text(trailing!)
          : null,
    );

  }
}

class ItemGrid extends StatelessWidget {
  const ItemGrid({
    Key? key,
    required this.title,
    required this.hasImage,
    this.imageURL,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final bool hasImage;
  final String? imageURL;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(4.0),),
        child: _ItemGridTile(
          title: title,
          hasImage: hasImage,
          imageURL: imageURL,
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ItemGridTile extends StatelessWidget {
  const _ItemGridTile({
    Key? key,
    required this.title,
    required this.hasImage,
    this.imageURL,
  }) : super(key: key);

  final String title;
  final bool hasImage;
  final String? imageURL;

  @override
  Widget build(BuildContext context) {

    return GridTile(
      child: hasImage?
        CachedImage(
          imageURL: imageURL?? '',
          fit: BoxFit.cover,
          backgroundColour: Colors.black87,
          applyGradient: false,
        ) : Container(),
      footer: Container(
        color: Colors.black87.withOpacity(0.5),
        child: Text(title, style: const TextStyle(fontSize: 18.0, color: Colors.white),),
      ),
    );

  }
}

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key? key,
    required this.imageURL,
    required this.fit,
    required this.backgroundColour,
    this.applyGradient = false,
  }) : super(key: key);

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
      color: Colors.black87,
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
      progressIndicatorBuilder: (BuildContext context, String url, DownloadProgress downloadProgress) {
        return Center(
          child: CircularProgressIndicator(value: downloadProgress.progress),
        );
      },
      errorWidget: (BuildContext context, String url, dynamic error) => Container(color: backgroundColour),
    );

  }
}

class ItemChip extends StatelessWidget {
  const ItemChip({
    Key? key,
    required this.title,
    this.selected = true,
    this.onTap,
  }) : super(key: key);

  final String title;
  final bool selected;
  final void Function(bool)? onTap;

  @override
  Widget build(BuildContext context) {

    return FilterChip(
      label: Text(title),
      selected: selected,
      onSelected: onTap,
    );

  }
}