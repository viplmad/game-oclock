import 'package:bloc/bloc.dart';

import 'repository_settings_radio.dart';


class RepositorySettingsRadioBloc extends Bloc<RepositorySettingsRadioEvent, RepositorySettingsRadioState> {

  RepositorySettingsRadioBloc() : super(RepositorySettingsRadioState());

  @override
  Stream<RepositorySettingsRadioState> mapEventToState(RepositorySettingsRadioEvent event) async* {

    if(event is UpdateRepositorySettingsRadio) {

      yield* _mapUpdateRadioToState(event);

    }

  }

  Stream<RepositorySettingsRadioState> _mapUpdateRadioToState(UpdateRepositorySettingsRadio event) async* {

    yield RepositorySettingsRadioState(event.radio);

  }

}