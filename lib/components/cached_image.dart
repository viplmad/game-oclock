import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/components/skeletons/skeletons.dart';

class SimpleCachedNetworkImage extends StatelessWidget {
  const SimpleCachedNetworkImage({super.key, required this.imageUrl, this.fit});

  final String imageUrl;
  final BoxFit? fit;

  @override
  Widget build(final BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      useOldImageOnUrlChange: true,
      progressIndicatorBuilder: (_, _, _) => const Skeleton(),
      errorWidget: (_, _, _) => Container(color: Colors.grey),
    );
  }
}
