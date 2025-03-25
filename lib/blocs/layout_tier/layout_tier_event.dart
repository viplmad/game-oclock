import 'dart:ui';

import 'package:equatable/equatable.dart';

sealed class LayoutTierEvent extends Equatable {
  const LayoutTierEvent();
}

final class LayoutContextChanged extends LayoutTierEvent {
  final Size size;

  const LayoutContextChanged({required this.size});

  @override
  List<Object?> get props => [size];
}
