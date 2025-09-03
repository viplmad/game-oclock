import 'package:flutter/material.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

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
  final String? imageURL; // TODO
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      onTap: onTap,
      trailing: trailing,
    );
  }
}

class GridListErrorItem extends StatelessWidget {
  const GridListErrorItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

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
                onPressed: onTap,
              ),
            ],
          ),
        ),
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

class _ListItemGridTile extends StatelessWidget {
  const _ListItemGridTile({required this.title, this.imageURL});

  final String title;
  final String? imageURL;

  @override
  Widget build(final BuildContext context) {
    return GridTile(
      footer: imageURL == null
          ? Container(
              color: Colors.black87.withAlpha(128),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            )
          : null, // TODO
      child: Container(color: Colors.black87),
    );
  }
}
