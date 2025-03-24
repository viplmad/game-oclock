import 'dart:ui';

sealed class LayoutTierEvent {}

final class LayoutContextChanged extends LayoutTierEvent {
  final Size size;

  LayoutContextChanged({required this.size});
}
