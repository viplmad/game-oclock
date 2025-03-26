import 'package:equatable/equatable.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;

final class LayoutTierState extends Equatable {
  final LayoutTier tier;

  const LayoutTierState({required this.tier});

  @override
  List<Object?> get props => [tier];
}
