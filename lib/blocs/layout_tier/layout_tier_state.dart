import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;

sealed class LayoutTierState extends Equatable {
  const LayoutTierState();
}

final class LayoutTierInitital extends LayoutTierState {
  const LayoutTierInitital();

  @override
  List<Object?> get props => [];
}

final class LayoutTierChange extends LayoutTierState {
  final LayoutTier tier;

  const LayoutTierChange({required this.tier});

  @override
  List<Object?> get props => [tier];
}
