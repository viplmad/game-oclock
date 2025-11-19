import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:game_oclock/constants/constants.dart';

const Color _gradientColor = Colors.black26;
const int _animationDurationMilliseconds = 1000;
const int _timeBetweenMilliseconds = 200;

Animation<double> _createGradientAnimation(
  final AnimationController animationController,
) {
  return Tween<double>(begin: 1.0, end: 0.2).animate(animationController);
}

class RoundSkeleton extends StatelessWidget {
  const RoundSkeleton({super.key, this.width, this.height, this.order = 0});

  final double? width;
  final double? height;
  final int order;

  @override
  Widget build(final BuildContext context) {
    return Skeleton(
      width: width,
      height: height,
      order: order,
      borderRadius: const BorderRadius.all(Radius.circular(kCardBorderRadius)),
    );
  }
}

class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.order = 0,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final int order;
  final BorderRadiusGeometry? borderRadius;

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
      duration: const Duration(milliseconds: _animationDurationMilliseconds),
      vsync: this,
    );
    gradientAnimation = _createGradientAnimation(animationController)
      ..addListener(() {
        setState(() {});
      });

    final int delayMilliseconds = widget.order * _timeBetweenMilliseconds;
    delayFuture = CancelableOperation<void>.fromFuture(
      Future<void>.delayed(
        Duration(milliseconds: delayMilliseconds),
        () => animationController.repeat(reverse: true),
      ),
    );
  }

  @override
  void dispose() async {
    unawaited(delayFuture.cancel());
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Opacity(
      opacity: gradientAnimation.value,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: _gradientColor,
        ),
      ),
    );
  }
}
