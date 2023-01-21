import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../utils/field_utils.dart';
import '../utils/shape_utils.dart';
import 'skeleton.dart';

class DismissibleItem extends StatelessWidget {
  const DismissibleItem({
    Key? key,
    required this.dismissibleKey,
    required this.itemWidget,
    required this.onDismissed,
    required this.dismissIcon,
    this.confirmDismiss,
  }) : super(key: key);

  final String dismissibleKey;
  final Widget itemWidget;
  final void Function(DismissDirection direction) onDismissed;
  final IconData dismissIcon;
  final Future<bool> Function(DismissDirection direction)? confirmDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(dismissibleKey),
      background: backgroundBuilder(Alignment.centerLeft),
      secondaryBackground: backgroundBuilder(Alignment.centerRight),
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
      child: itemWidget,
    );
  }

  Widget backgroundBuilder(AlignmentGeometry alignment) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: ShapeUtils.cardBorderRadius,
      ),
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Icon(dismissIcon, color: Colors.white),
        ),
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
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? trailing;
  final bool hasImage;
  final String? imageURL;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      // No margin so dismissible background fits well
      margin: const EdgeInsets.all(0.0),
      child: InkWell(
        borderRadius: ShapeUtils.cardBorderRadius,
        onTap: onTap,
        child: _ItemListTile(
          title: title, // TODO add ellipsis
          subtitle: subtitle,
          trailing: trailing,
          hasImage: hasImage,
          imageURL: imageURL,
        ),
      ),
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
      leading: hasImage
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: FieldUtils.imageWidth,
                minHeight: FieldUtils.imageHeight,
                maxWidth: FieldUtils.imageWidth,
                maxHeight: 80,
              ),
              child: CachedImage(
                imageURL: imageURL ?? '',
                fit: BoxFit.scaleDown,
                backgroundColour: Colors.white,
                applyGradient: false,
              ),
            )
          : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing != null ? Text(trailing!) : null,
    );
  }
}

class ItemGrid extends StatelessWidget {
  const ItemGrid({
    Key? key,
    required this.title,
    this.imageURL,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String? imageURL;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: ShapeUtils.cardBorderRadius,
        onTap: onTap,
        child: _ItemGridTile(
          title: title,
          imageURL: imageURL,
        ),
      ),
    );
  }
}

class _ItemGridTile extends StatelessWidget {
  const _ItemGridTile({
    Key? key,
    required this.title,
    this.imageURL,
  }) : super(key: key);

  final String title;
  final String? imageURL;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Container(
        color: Colors.black87.withOpacity(0.5),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      child: CachedImage(
        imageURL: imageURL ?? '',
        fit: BoxFit.cover,
        backgroundColour: Colors.black87,
        applyGradient: false,
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
    return imageURL.isNotEmpty
        ? applyGradient
            ? _getGradientImage()
            : _getCachedImage()
        : const SizedBox();
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
      progressIndicatorBuilder: (_, __, ___) => const Skeleton(),
      errorWidget: (_, __, ___) => Container(color: backgroundColour),
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
