import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `state` and is responsible for executing in response to
/// `state` changes.
typedef BiBlocWidgetListener<SA, SB> =
    void Function(BuildContext context, SA stateA, SB stateB);

/// Signature for the `listenWhen` function which takes the previous `state`
/// and the current `state` and is responsible for returning a [bool] which
/// determines whether or not to call [BlocWidgetListener] of [BlocListener]
/// with the current `state`.
typedef BiBlocListenerCondition<SA, SB> =
    bool Function(SA previousA, SA currentA, SB previousB, SB currentB);

/// {@template bloc_listener}
/// Takes a [BlocWidgetListener] and an optional [bloc] and invokes
/// the [listener] in response to `state` changes in the [bloc].
/// It should be used for functionality that needs to occur only in response to
/// a `state` change such as navigation, showing a `SnackBar`, showing
/// a `Dialog`, etc...
/// The [listener] is guaranteed to only be called once for each `state` change
/// unlike the `builder` in `BlocBuilder`.
///
/// If the [bloc] parameter is omitted, [BlocListener] will automatically
/// perform a lookup using [BlocProvider] and the current `BuildContext`.
///
/// ```dart
/// BlocListener<BlocA, BlocAState>(
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   child: Container(),
/// )
/// ```
/// Only specify the [bloc] if you wish to provide a [bloc] that is otherwise
/// not accessible via [BlocProvider] and the current `BuildContext`.
///
/// ```dart
/// BlocListener<BlocA, BlocAState>(
///   value: blocA,
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   child: Container(),
/// )
/// ```
/// {@endtemplate}
///
/// {@template bloc_listener_listen_when}
/// An optional [listenWhen] can be implemented for more granular control
/// over when [listener] is called.
/// [listenWhen] will be invoked on each [bloc] `state` change.
/// [listenWhen] takes the previous `state` and current `state` and must
/// return a [bool] which determines whether or not the [listener] function
/// will be invoked.
/// The previous `state` will be initialized to the `state` of the [bloc]
/// when the [BlocListener] is initialized.
/// [listenWhen] is optional and if omitted, it will default to `true`.
///
/// ```dart
/// BlocListener<BlocA, BlocAState>(
///   listenWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to invoke listener with state
///   },
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   child: Container(),
/// )
/// ```
/// {@endtemplate}
class CombineLatestBlocListener<
  BA extends StateStreamable<SA>,
  SA,
  BB extends StateStreamable<SB>,
  SB
>
    extends CombineLatestBlocListenerBase<BA, SA, BB, SB> {
  /// {@macro bloc_listener}
  /// {@macro bloc_listener_listen_when}
  const CombineLatestBlocListener({
    required BiBlocWidgetListener<SA, SB> listener,
    Key? key,
    BA? blocA,
    BB? blocB,
    BiBlocListenerCondition<SA, SB>? listenWhen,
    Widget? child,
  }) : super(
         key: key,
         child: child,
         listener: listener,
         blocA: blocA,
         blocB: blocB,
         listenWhen: listenWhen,
       );
}

/// {@template bloc_listener_base}
/// Base class for widgets that listen to state changes in a specified [bloc].
///
/// A [BlocListenerBase] is stateful and maintains the state subscription.
/// The type of the state and what happens with each state change
/// is defined by sub-classes.
/// {@endtemplate}
abstract class CombineLatestBlocListenerBase<
  BA extends StateStreamable<SA>,
  SA,
  BB extends StateStreamable<SB>,
  SB
>
    extends SingleChildStatefulWidget {
  /// {@macro bloc_listener_base}
  const CombineLatestBlocListenerBase({
    required this.listener,
    Key? key,
    this.blocA,
    this.blocB,
    this.child,
    this.listenWhen,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant of the
  /// [BlocListenerBase].
  final Widget? child;

  /// The [bloc] whose `state` will be listened to.
  /// Whenever the [bloc]'s `state` changes, [listener] will be invoked.
  final BA? blocA;

  final BB? blocB;

  /// The [BlocWidgetListener] which will be called on every `state` change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a `state` change.
  final BiBlocWidgetListener<SA, SB> listener;

  /// {@macro bloc_listener_listen_when}
  final BiBlocListenerCondition<SA, SB>? listenWhen;

  @override
  SingleChildState<CombineLatestBlocListenerBase<BA, SA, BB, SB>>
  createState() => _CombineLatestBlocListenerBaseState<BA, SA, BB, SB>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<BA?>('blocA', blocA))
      ..add(DiagnosticsProperty<BB?>('blocB', blocB))
      ..add(
        ObjectFlagProperty<BiBlocWidgetListener<SA, SB>>.has(
          'listener',
          listener,
        ),
      )
      ..add(
        ObjectFlagProperty<BiBlocListenerCondition<SA, SB>?>.has(
          'listenWhen',
          listenWhen,
        ),
      );
  }
}

class _CombineLatestBlocListenerBaseState<
  BA extends StateStreamable<SA>,
  SA,
  BB extends StateStreamable<SB>,
  SB
>
    extends SingleChildState<CombineLatestBlocListenerBase<BA, SA, BB, SB>> {
  StreamSubscription<List<Object?>>? _subscription;
  late BA _blocA;
  late BB _blocB;
  late SA _previousStateA;
  late SB _previousStateB;

  @override
  void initState() {
    super.initState();
    _blocA = widget.blocA ?? context.read<BA>();
    _blocB = widget.blocB ?? context.read<BB>();
    _previousStateA = _blocA.state;
    _previousStateB = _blocB.state;
    _subscribe();
  }

  @override
  void didUpdateWidget(
    CombineLatestBlocListenerBase<BA, SA, BB, SB> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    final oldBlocA = oldWidget.blocA ?? context.read<BA>();
    final oldBlocB = oldWidget.blocB ?? context.read<BB>();

    final currentBlocA = widget.blocA ?? oldBlocA;
    final currentBlocB = widget.blocB ?? oldBlocB;
    if (oldBlocA != currentBlocA || oldBlocB != currentBlocB) {
      if (_subscription != null) {
        _unsubscribe();
        _blocA = currentBlocA;
        _blocB = currentBlocB;
        _previousStateA = _blocA.state;
        _previousStateB = _blocB.state;
      }
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final blocA = widget.blocA ?? context.read<BA>();
    final blocB = widget.blocB ?? context.read<BB>();
    if (_blocA != blocA || _blocB != blocB) {
      if (_subscription != null) {
        _unsubscribe();
        _blocA = blocA;
        _blocB = blocB;
        _previousStateA = _blocA.state;
        _previousStateB = _blocB.state;
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiBlocListener must specify a child''',
    );
    if (widget.blocA == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<BA, bool>((bloc) => identical(_blocA, bloc));
    }
    if (widget.blocB == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<BB, bool>((bloc) => identical(_blocB, bloc));
    }
    return child!;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = CombineLatestStream.list([
      _blocA.stream.startWith(_blocA.state),
      _blocB.stream.startWith(_blocB.state),
    ]).listen((state) {
      if (!mounted) return;
      final stateA = state[0] as SA;
      final stateB = state[1] as SB;
      if (widget.listenWhen?.call(
            _previousStateA,
            stateA,
            _previousStateB,
            stateB,
          ) ??
          true) {
        widget.listener(context, stateA, stateB);
      }
      _previousStateA = stateA;
      _previousStateB = stateB;
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
