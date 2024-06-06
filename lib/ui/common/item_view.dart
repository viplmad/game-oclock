import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:game_oclock/ui/common/header_text.dart';
import 'package:game_oclock/ui/utils/field_utils.dart';
import 'package:game_oclock/ui/utils/shape_utils.dart';

import 'skeleton.dart';

class DismissibleItem extends StatelessWidget {
  const DismissibleItem({
    super.key,
    required this.itemWidget,
    required this.onDismissed,
    required this.dismissIcon,
    required this.dismissLabel,
    this.confirmDismiss,
  });

  final Widget itemWidget;
  final void Function() onDismissed;
  final IconData dismissIcon;
  final String dismissLabel;
  final Future<bool> Function()? confirmDismiss;

  @override
  Widget build(BuildContext context) {
    final MenuController menuController = MenuController();

    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) =>
          menuController.open(position: details.localPosition),
      child: MenuAnchor(
        controller: menuController,
        consumeOutsideTap: true,
        menuChildren: <Widget>[
          MenuItemButton(
            leadingIcon: Icon(dismissIcon),
            child: Text(dismissLabel),
            onPressed: () async {
              if (confirmDismiss != null) {
                confirmDismiss!().then((bool confirm) {
                  if (confirm) {
                    onDismissed();
                  }
                });
              } else {
                onDismissed();
              }
            },
          ),
        ],
        child: itemWidget,
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          // Ignore pointers on current if open
          return IgnorePointer(
            ignoring: controller.isOpen,
            child: child,
          );
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.hasImage,
    this.imageURL,
    this.preAdditionalWidgets = const <Widget>[],
    this.postAdditionalWidgets = const <Widget>[],
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool hasImage;
  final String? imageURL;
  final List<Widget> preAdditionalWidgets;
  final List<Widget> postAdditionalWidgets;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final _ItemListTile itemListTile = _ItemListTile(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      hasImage: hasImage,
      imageURL: imageURL,
    );
    final bool hasAdditionalWidgets =
        preAdditionalWidgets.isNotEmpty || postAdditionalWidgets.isNotEmpty;

    return CardWithTap(
      onTap: onTap,
      child: hasAdditionalWidgets
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ...preAdditionalWidgets,
                itemListTile,
                ...postAdditionalWidgets,
              ],
            )
          : itemListTile,
    );
  }
}

class CardWithTap extends StatelessWidget {
  const CardWithTap({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: ShapeUtils.cardBorderRadius,
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class _ItemListTile extends StatelessWidget {
  const _ItemListTile({
    required this.title,
    this.subtitle,
    this.trailing,
    required this.hasImage,
    this.imageURL,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
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
      title: HeaderText(title),
      subtitle: subtitle != null ? BodyText(subtitle!) : null,
      trailing: trailing,
    );
  }
}

class ItemGrid extends StatelessWidget {
  const ItemGrid({
    super.key,
    required this.title,
    this.imageURL,
    required this.onTap,
  });

  final String title;
  final String? imageURL;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: _ItemGridTile(
            title: title,
            imageURL: imageURL,
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemGridTile extends StatelessWidget {
  const _ItemGridTile({
    required this.title,
    this.imageURL,
  });

  final String title;
  final String? imageURL;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: imageURL == null
          ? Container(
              color: Colors.black87.withOpacity(0.5),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            )
          : null,
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
    super.key,
    required this.imageURL,
    required this.fit,
    required this.backgroundColour,
    this.applyGradient = false,
  });

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
      progressIndicatorBuilder: (_, __, ___) =>
          const Skeleton(omitRounding: true),
      errorWidget: (_, __, ___) => Container(color: backgroundColour),
    );
  }
}

class ItemChip extends StatelessWidget {
  const ItemChip({
    super.key,
    required this.title,
    this.selected = true,
    this.onTap,
  });

  final String title;
  final bool selected;
  final ValueChanged<bool>? onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(title),
      selected: selected,
      onSelected: onTap,
    );
  }
}
