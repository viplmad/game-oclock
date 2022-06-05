import 'dart:math' as math;

import 'package:flutter/material.dart';

const double _kOffset =
    30.0; // distance to bottom of banner, at a 45 degree angle inwards
const double _kHeight = 35.0; // height of banner
const Rect _kRect =
    Rect.fromLTWH(-_kOffset, _kOffset - _kHeight, _kOffset * 2.0, _kHeight);

const Color _kColor = Color(0xA0B71C1C);
const TextStyle _kTextStyle = TextStyle(
  color: Color(0xFFFFFFFF),
  fontSize: _kHeight * 0.85,
  fontWeight: FontWeight.w900,
  height: 1.0,
);

enum TriangleBannerLocation {
  start,
  end,
}

class TriangleBanner extends StatelessWidget {
  const TriangleBanner({
    Key? key,
    required this.child,
    required this.message,
    this.textDirection,
    required this.location,
    this.layoutDirection,
    this.showShadow = true,
    this.color = _kColor,
    this.textStyle = _kTextStyle,
    this.size,
  }) : super(key: key);

  final Widget child;
  final String message;
  final TextDirection? textDirection;
  final TriangleBannerLocation location;
  final TextDirection? layoutDirection;
  final Color color;
  final bool showShadow;
  final TextStyle textStyle;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _TriangleBannerPainter(
        message: message,
        textDirection: textDirection ?? Directionality.of(context),
        location: location,
        layoutDirection: layoutDirection ?? Directionality.of(context),
        showShadow: showShadow,
        color: color,
        textStyle: textStyle,
      ),
      child: child,
    );
  }
}

class _TriangleBannerPainter extends CustomPainter {
  _TriangleBannerPainter({
    required this.message,
    required this.textDirection,
    required this.location,
    required this.layoutDirection,
    this.showShadow = true,
    this.color = _kColor,
    this.textStyle = _kTextStyle,
  }) : super(repaint: PaintingBinding.instance.systemFonts);

  final String message;
  final TextDirection textDirection;
  final TriangleBannerLocation location;
  final TextDirection layoutDirection;
  final bool showShadow;
  final Color color;
  final TextStyle textStyle;

  static const BoxShadow _shadow = BoxShadow(
    color: Color(0x7F000000),
    blurRadius: 6.0,
  );

  bool _prepared = false;
  late TextPainter _textPainter;
  late Paint _paintShadow;
  late Paint _paintBanner;

  void _prepare() {
    if (showShadow) {
      _paintShadow = _shadow.toPaint();
    }

    _paintBanner = Paint()..color = color;
    _textPainter = TextPainter(
      text: TextSpan(style: textStyle, text: message),
      textAlign: TextAlign.center,
      textDirection: textDirection,
    );
    _prepared = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_prepared) {
      _prepare();
    }
    canvas
      ..translate(_translationX(size.width), 0.0)
      ..rotate(_rotation)
      ..drawRect(_kRect, _paintBanner);

    if (showShadow) {
      canvas.drawRect(_kRect, _paintShadow);
    }

    const double width = _kOffset * 2.0;
    _textPainter.layout(minWidth: width, maxWidth: width);
    _textPainter.paint(
      canvas,
      _kRect.topLeft + Offset(0.0, (_kRect.height - _textPainter.height)),
    );
  }

  @override
  bool shouldRepaint(_TriangleBannerPainter oldDelegate) {
    return message != oldDelegate.message ||
        location != oldDelegate.location ||
        color != oldDelegate.color ||
        textStyle != oldDelegate.textStyle;
  }

  @override
  bool hitTest(Offset position) => false;

  double _translationX(double width) {
    switch (layoutDirection) {
      case TextDirection.rtl:
        switch (location) {
          case TriangleBannerLocation.end:
            return 0.0;
          case TriangleBannerLocation.start:
            return width;
        }
      case TextDirection.ltr:
        switch (location) {
          case TriangleBannerLocation.end:
            return width;
          case TriangleBannerLocation.start:
            return 0.0;
        }
    }
  }

  double get _rotation {
    switch (layoutDirection) {
      case TextDirection.rtl:
        switch (location) {
          case TriangleBannerLocation.end:
            return -math.pi / 4.0;
          case TriangleBannerLocation.start:
            return math.pi / 4.0;
        }
      case TextDirection.ltr:
        switch (location) {
          case TriangleBannerLocation.end:
            return math.pi / 4.0;
          case TriangleBannerLocation.start:
            return -math.pi / 4.0;
        }
    }
  }
}
