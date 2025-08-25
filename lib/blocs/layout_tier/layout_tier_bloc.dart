import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;
import 'package:game_oclock/utils/layout_tier_utils.dart';

import 'layout_tier.dart'
    show LayoutContextChanged, LayoutTierEvent, LayoutTierState;

class LayoutTierBloc extends Bloc<LayoutTierEvent, LayoutTierState> {
  LayoutTierBloc() : super(const LayoutTierState(tier: LayoutTier.compact)) {
    on<LayoutContextChanged>(
      (final event, final emit) async =>
          await onContextChanged(event.size, emit),
    );
  }

  Future<void> onContextChanged(
    final Size size,
    final Emitter<LayoutTierState> emit,
  ) async {
    emit(LayoutTierState(tier: layoutTierFromSize(size)));
  }
}
