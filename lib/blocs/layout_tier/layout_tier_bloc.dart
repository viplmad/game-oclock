import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;

import 'layout_tier.dart'
    show
        LayoutContextChanged,
        LayoutTierChange,
        LayoutTierEvent,
        LayoutTierInitital,
        LayoutTierState;

// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
const compactBreakpointWidth = 600;
const mediumBreakpointWidth = 840;
const expandedBreakpointWidth = 1200;
const largeBreakpointWidth = 1600;

class LayoutTierBloc extends Bloc<LayoutTierEvent, LayoutTierState> {
  LayoutTierBloc() : super(const LayoutTierInitital()) {
    on<LayoutContextChanged>(
      (final event, final emit) async =>
          await onContextChanged(event.size, emit),
    );
  }

  Future<void> onContextChanged(
    final Size size,
    final Emitter<LayoutTierState> emit,
  ) async {
    final LayoutTier tier;
    final width = size.width;
    if (width < compactBreakpointWidth) {
      tier = LayoutTier.compact;
    } else if (compactBreakpointWidth <= width &&
        width < mediumBreakpointWidth) {
      tier = LayoutTier.medium;
    } else if (mediumBreakpointWidth <= width &&
        width < expandedBreakpointWidth) {
      tier = LayoutTier.expanded;
    } else if (expandedBreakpointWidth <= width &&
        width < largeBreakpointWidth) {
      tier = LayoutTier.large;
    } else {
      tier = LayoutTier.extraLarge;
    }
    emit(LayoutTierChange(tier: tier));
  }
}
