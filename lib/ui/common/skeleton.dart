import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'package:game_oclock/ui/utils/field_utils.dart';

import '../utils/shape_utils.dart';

class SkeletonUtils {
  SkeletonUtils._();

  static const Color _gradientColor = Colors.black26;
  static const BorderRadius _borderRadius = ShapeUtils.cardBorderRadius;
  static const int _animationDurationMilliseconds = 1000;
  static const int _timeBetweenMilliseconds = 200;

  static Animation<double> _createGradientAnimation(
    AnimationController animationController,
  ) {
    return Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(
      animationController,
    );
  }
}

class SkeletonItemCard extends StatefulWidget {
  const SkeletonItemCard({
    super.key,
    required this.hasImage,
    this.order = 0,
  });

  final bool hasImage;
  final int order;

  @override
  State<SkeletonItemCard> createState() => _SkeletonItemCardState();
}

class _SkeletonItemCardState extends State<SkeletonItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> gradientAnimation;
  late final CancelableOperation<void> delayFuture;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(
        milliseconds: SkeletonUtils._animationDurationMilliseconds,
      ),
      vsync: this,
    );
    gradientAnimation =
        SkeletonUtils._createGradientAnimation(animationController)
          ..addListener(() {
            setState(() {});
          });

    final int delayMilliseconds =
        widget.order * SkeletonUtils._timeBetweenMilliseconds;
    delayFuture = CancelableOperation<void>.fromFuture(
      Future<void>.delayed(
        Duration(milliseconds: delayMilliseconds),
        () => animationController.repeat(reverse: true),
      ),
    );
  }

  @override
  void dispose() async {
    delayFuture.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: widget.hasImage
            ? SizedBox(
                width: FieldUtils.imageWidth,
                height: FieldUtils.imageHeight,
                child: Opacity(
                  opacity: gradientAnimation.value,
                  child: Container(
                    color: SkeletonUtils._gradientColor,
                  ),
                ),
              )
            : null,
        title: SizedBox(
          height: FieldUtils.titleTextHeight,
          child: Opacity(
            opacity: gradientAnimation.value,
            child: Container(
              color: SkeletonUtils._gradientColor,
            ),
          ),
        ),
        subtitle: Opacity(
          opacity: gradientAnimation.value,
          child: Container(
            height: FieldUtils.subtitleTextHeight,
            color: SkeletonUtils._gradientColor,
          ),
        ),
      ),
    );
  }
}

class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.order = 0,
    this.omitRounding = false,
  });

  final double? width;
  final double? height;
  final int order;
  final bool omitRounding;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> gradientAnimation;
  late final CancelableOperation<void> delayFuture;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(
        milliseconds: SkeletonUtils._animationDurationMilliseconds,
      ),
      vsync: this,
    );
    gradientAnimation =
        SkeletonUtils._createGradientAnimation(animationController)
          ..addListener(() {
            setState(() {});
          });

    final int delayMilliseconds =
        widget.order * SkeletonUtils._timeBetweenMilliseconds;
    delayFuture = CancelableOperation<void>.fromFuture(
      Future<void>.delayed(
        Duration(milliseconds: delayMilliseconds),
        () => animationController.repeat(reverse: true),
      ),
    );
  }

  @override
  void dispose() async {
    delayFuture.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: gradientAnimation.value,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius:
              widget.omitRounding ? null : SkeletonUtils._borderRadius,
          color: SkeletonUtils._gradientColor,
        ),
      ),
    );
  }
}
