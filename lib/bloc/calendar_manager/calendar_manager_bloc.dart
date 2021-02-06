import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'calendar_manager.dart';


class CalendarManagerBloc extends Bloc<CalendarManagerEvent, CalendarManagerState> {
  CalendarManagerBloc({
    @required this.itemId,
    @required this.iCollectionRepository,
  }) : super(Initialised());

  final int itemId;
  final ICollectionRepository iCollectionRepository;

  @override
  Stream<CalendarManagerState> mapEventToState(CalendarManagerEvent event) async* {

    yield* _checkConnection();

    if(event is AddTimeLog) {

      yield* _mapAddTimeLogToState(event);

    } else if(event is DeleteTimeLog) {

      yield* _mapDeleteTimeLogToState(event);

    } else if(event is AddFinishDate) {

      yield* _mapAddFinishDateToState(event);

    } else if(event is DeleteFinishDate) {

      yield* _mapDeleteFinishDateToState(event);

    }

    yield Initialised();

  }

  Stream<CalendarManagerState> _checkConnection() async* {

    if(iCollectionRepository.isClosed()) {

      try {

        iCollectionRepository.reconnect();
        await iCollectionRepository.open();

      } catch(e) {
      }
    }

  }

  Stream<CalendarManagerState> _mapAddTimeLogToState(AddTimeLog event) async* {

    try {

      await createTimeLogFuture(event);
      yield TimeLogAdded(event.log);

    } catch (e) {

      yield TimeLogNotAdded(e.toString());

    }

  }

  Stream<CalendarManagerState> _mapDeleteTimeLogToState(DeleteTimeLog event) async* {

    try{

      await deleteTimeLogFuture(event);
      yield TimeLogDeleted(event.log);

    } catch (e) {

      yield TimeLogNotDeleted(e.toString());

    }

  }

  Stream<CalendarManagerState> _mapAddFinishDateToState(AddFinishDate event) async* {

    try {

      await createFinishDateFuture(event);
      yield FinishDateAdded(event.date);

    } catch (e) {

      yield FinishDateNotAdded(e.toString());

    }

  }

  Stream<CalendarManagerState> _mapDeleteFinishDateToState(DeleteFinishDate event) async* {

    try{

      await deleteFinishDateFuture(event);
      yield FinishDateDeleted(event.date);

    } catch (e) {

      yield FinishDateNotDeleted(e.toString());

    }

  }

  Future<dynamic> createTimeLogFuture(AddTimeLog event) {

    return iCollectionRepository.relateGameTimeLog(itemId, event.log.dateTime, event.log.time);

  }

  Future<dynamic> deleteTimeLogFuture(DeleteTimeLog event) {

    return iCollectionRepository.deleteGameTimeLog(itemId, event.log.dateTime);

  }

  Future<dynamic> createFinishDateFuture(AddFinishDate event) {

    return iCollectionRepository.relateGameFinishDate(itemId, event.date);

  }

  Future<dynamic> deleteFinishDateFuture(DeleteFinishDate event) {

    return iCollectionRepository.deleteGameFinishDate(itemId, event.date);

  }
}