import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/components/skeletons/skeletons.dart';
import 'package:game_oclock/constants/colors.dart';

class SimpleCachedNetworkImage extends StatelessWidget {
  const SimpleCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.applyGradient = false,
  });

  final String imageUrl;
  final BoxFit? fit;
  final bool applyGradient;

  @override
  Widget build(final BuildContext context) {
    return applyGradient ? _getGradientImage() : _getCachedImage();
  }

  Widget _getGradientImage() {
    return Container(
      color: CommonColors.black,
      child: Opacity(opacity: 0.65, child: _getCachedImage()),
    );
  }

  Widget _getCachedImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      useOldImageOnUrlChange: true,
      progressIndicatorBuilder: (_, _, _) => const ImageSkeleton(),
      errorWidget: (_, _, _) => Container(color: CommonColors.grey),
    );
  }
}
