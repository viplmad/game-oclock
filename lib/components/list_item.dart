import 'package:flutter/material.dart';

class ListItemTile extends StatelessWidget {
  const ListItemTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      onTap: onTap,
    );
  }
}

class ListItemGrid extends StatelessWidget {
  const ListItemGrid({
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
      footer:
          imageURL == null
              ? Container(
                color: Colors.black87.withAlpha(128),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              )
              : null,
      child: Container(color: Colors.black87),
    );
  }
}
