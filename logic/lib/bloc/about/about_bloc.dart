import 'package:bloc/bloc.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:game_oclock_client/api.dart' show ErrorCode;

import 'about.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(AboutLoading()) {
    on<LoadAbout>(_mapLoadInfoToState);
  }

  void _mapLoadInfoToState(LoadAbout event, Emitter<AboutState> emit) async {
    emit(
      AboutLoading(),
    );

    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      emit(
        AboutLoaded(packageInfo),
      );
    } catch (e) {
      _handleError(emit, e);
    }
  }

  void _handleError(Emitter<AboutState> emit, Object e) {
    emit(
      AboutNotLoaded(ErrorCode.unknown, e.toString()),
    );
  }
}
