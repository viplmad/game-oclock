import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout_tier.dart'
    show
        LayoutContextChanged,
        LayoutTierCompact,
        LayoutTierEvent,
        LayoutTierExpanded,
        LayoutTierExtraLarge,
        LayoutTierInitital,
        LayoutTierLarge,
        LayoutTierMedium,
        LayoutTierState;

// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
const compactBreakpointWidth = 600;
const mediumBreakpointWidth = 840;
const expandedBreakpointWidth = 1200;
const largeBreakpointWidth = 1600;

class LayoutTierBloc extends Bloc<LayoutTierEvent, LayoutTierState> {
  LayoutTierBloc() : super(LayoutTierInitital()) {
    on<LayoutContextChanged>(
      (final event, final emit) async =>
          await onContextChanged(event.size, emit),
    );
  }

  Future<void> onContextChanged(
    final Size size,
    final Emitter<LayoutTierState> emit,
  ) async {
    final width = size.width;
    if (width < compactBreakpointWidth) {
      emit(LayoutTierCompact());
    } else if (compactBreakpointWidth <= width &&
        width < mediumBreakpointWidth) {
      emit(LayoutTierMedium());
    } else if (mediumBreakpointWidth <= width &&
        width < expandedBreakpointWidth) {
      emit(LayoutTierExpanded());
    } else if (expandedBreakpointWidth <= width &&
        width < largeBreakpointWidth) {
      emit(LayoutTierLarge());
    } else {
      emit(LayoutTierExtraLarge());
    }
  }
}
