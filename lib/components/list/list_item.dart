import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

const double _imageWidth = 100;
const double _imageHeight = 56;

class TileListItem extends StatelessWidget {
  const TileListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.imageURL,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? imageURL;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool hasImage = true;

  @override
  Widget build(final BuildContext context) {
    return _ListItemListTile(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      imageURL: imageURL,
      onTap: onTap,
    );
  }
}

class TileListErrorItem extends StatelessWidget {
  const TileListErrorItem({
    super.key,
    required this.title,
    required this.onRetryTap,
  });

  final String title;
  final VoidCallback? onRetryTap;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(
        title,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      trailing: OutlinedButton.icon(
        icon: const Icon(CommonIcons.reload),
        label: Text(
          context.localize().retryLabel,
          maxLines: 1,
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        onPressed: onRetryTap,
      ),
    );
  }
}

class GridListItem extends StatelessWidget {
  const GridListItem({
    super.key,
    required this.title,
    this.imageURL,
    required this.onTap,
  });

  final String title;
  final String? imageURL;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: _ListItemGridTile(title: title, imageURL: imageURL),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTap: onTap),
          ),
        ),
      ],
    );
  }
}

class GridListErrorItem extends StatelessWidget {
  const GridListErrorItem({
    super.key,
    required this.title,
    required this.onRetryTap,
  });

  final String title;
  final VoidCallback? onRetryTap;

  @override
  Widget build(final BuildContext context) {
    return GridTile(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                maxLines: 1,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              OutlinedButton.icon(
                icon: const Icon(CommonIcons.reload),
                label: Text(
                  context.localize().retryLabel,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                onPressed: onRetryTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListItemListTile extends StatelessWidget {
  const _ListItemListTile({
    required this.title,
    this.subtitle,
    this.imageURL,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? imageURL;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool hasImage = true;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      leading: hasImage
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _imageWidth,
                minHeight: _imageHeight,
                maxWidth: _imageWidth,
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
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _ListItemGridTile extends StatelessWidget {
  const _ListItemGridTile({required this.title, this.imageURL});

  final String title;
  final String? imageURL;

  @override
  Widget build(final BuildContext context) {
    return GridTile(
      footer: Container(
        color: Colors.black87.withAlpha(128),
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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
  Widget build(final BuildContext context) {
    return imageURL.isNotEmpty
        ? applyGradient
              ? _getGradientImage()
              : _getCachedImage()
        : const SizedBox();
  }

  Widget _getGradientImage() {
    return Container(
      color: Colors.black87,
      child: Opacity(opacity: 0.75, child: _getCachedImage()),
    );
  }

  CachedNetworkImage _getCachedImage() {
    return CachedNetworkImage(
      imageUrl: imageURL,
      fit: fit,
      useOldImageOnUrlChange: true,
      //progressIndicatorBuilder: (_, __, ___) => const Skeleton(omitRounding: true), // TODO
      errorWidget: (_, __, ___) => Container(color: backgroundColour),
    );
  }
}
