import 'package:flutter/material.dart';

import 'package:backend/model/model.dart' show GameStatus, PlatformType;
import 'package:backend/model/calendar_range.dart';

import 'package:backend/utils/duration_extension.dart';

import 'localisations.dart';

class GameCollectionLocalisationsEs implements GameCollectionLocalisations {
  const GameCollectionLocalisationsEs();

  @override
  final String connectingString = 'Conectando...';
  @override
  final String connectString = 'Conectar';
  @override
  final String failedConnectionString = 'Conexión fallida';
  @override
  final String retryString = 'Reintentar';
  @override
  final String changeRepositoryString = 'Cambiar ajustes de conexión';

  @override
  final String repositorySettingsString = 'Ajustes de conexión';
  @override
  final String updatedItemConnectionString = 'Conexión de ítem actualizada';
  @override
  final String updatedImageConnectionString = 'Conexión de imagen actualizada';
  @override
  final String unableToUpdateConnectionString =
      'No ha sido posible actualizar la conexión';
  @override
  final String deletedItemConnectionString = 'Conexión de ítem eliminada';
  @override
  final String deletedImageConnectionString = 'Conexión de imagen eliminada';
  @override
  final String unableToDeleteConnectionString =
      'No ha sido posible eliminar la conexión';
  @override
  final String saveString = 'Guardar';
  @override
  final String itemConnectionString = 'Conexión de ítem';
  @override
  final String imageConnectionString = 'Conexión de imagen';

  @override
  final String hostString = 'Host';
  @override
  final String portString = 'Puerto';
  @override
  final String databaseString = 'Base de datos';
  @override
  final String userString = 'Usuario';
  @override
  final String passwordString = 'Contraseña';

  @override
  final String cloudNameString = 'Nombre de cloud';
  @override
  final String apiKeyString = 'Clave de API';
  @override
  final String apiSecretString = 'Secreto de API';

  @override
  final String localString = 'Local';

  @override
  final String searchAllString = 'Busqueda global';
  @override
  final String changeStyleString = 'Cambio de estilo';
  @override
  final String changeViewString = 'Cambio de vista';
  @override
  final String changeRangeString = 'Cambio de rango';
  @override
  final String calendarView = 'Vista de calendario';
  @override
  final String searchInViewString = 'Búsqueda en vista';
  @override
  final String statsInViewString = 'Vista de estadísticas';

  @override
  final String gameListsString = 'Listas de juegos';

  @override
  String newString(String typeString) {
    return 'Nuevo $typeString';
  }

  @override
  final String openString = 'Abrir';
  @override
  String addedString(String typeString) {
    return '$typeString añadido';
  }

  @override
  String unableToAddString(String typeString) {
    return 'No ha sido posible añadir $typeString';
  }

  @override
  String deletedString(String typeString) {
    return '$typeString eliminado';
  }

  @override
  String unableToDeleteString(String typeString) {
    return 'No ha sido posible eliminar $typeString';
  }

  @override
  final String deleteString = 'Eliminar';
  @override
  final String deleteButtonLabel = 'ELIMINAR';
  @override
  String deleteDialogTitle(String itemString) {
    return 'Estás seguro que quieres eliminar $itemString?';
  }

  @override
  final String deleteDialogSubtitle = 'Esta acción es irreversible';

  //#region Common
  @override
  final String emptyValueString = '';
  @override
  final String showString = 'Mostrar';
  @override
  final String hideString = 'Ocultar';
  @override
  final String enterTextString = 'Por favor, introduce texto';

  @override
  final String nameFieldString = 'Nombre';
  @override
  final String filenameString = 'Nombre de archivo';
  @override
  final String releaseYearFieldString = 'Año de lanzamiento';
  @override
  final String finishDateFieldString = 'Fecha de fin';
  @override
  final String finishDatesFieldString = 'Fechas de fin';
  @override
  String get emptyFinishDatesString => 'No hay $finishDatesFieldString aún';

  @override
  final String mainViewString = 'Principal';
  @override
  final String lastCreatedViewString = 'Últimos creados';
  @override
  final String yearInReviewViewString = 'Repaso anual';

  @override
  final String generalString = 'General';
  @override
  final String changeYearString = 'Cambiar año';
  @override
  final List<String> daysOfWeek = const <String>[
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  @override
  final List<String> shortDaysOfWeek = const <String>[
    'Lun.',
    'Mar.',
    'Mie.',
    'Jue.',
    'Vie.',
    'Sáb.',
    'Dom.',
  ];
  @override
  final List<String> months = const <String>[
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  @override
  final List<String> shortMonths = const <String>[
    'Ene.',
    'Feb.',
    'Mar.',
    'Abr.',
    'May.',
    'Jun.',
    'Jul.',
    'Ago.',
    'Sep.',
    'Oct.',
    'Nov.',
    'Dic.',
  ];
  //#endregion Common

  //#region Game
  @override
  final String gameString = 'Juego';
  @override
  String get gamesString => _plural(gameString);
  @override
  final String allString = 'Todos';
  @override
  final String ownedString = 'Comprados';
  @override
  final String romsString = 'Roms';

  @override
  final String lowPriorityString = 'Baja prioridad';
  @override
  final String nextUpString = 'Siguiente';
  @override
  final String playingString = 'Jugando';
  @override
  final String playedString = 'Jugado';
  @override
  String gameStatusString(GameStatus? status) {
    switch (status) {
      case GameStatus.lowPriority:
        return lowPriorityString;
      case GameStatus.nextUp:
        return nextUpString;
      case GameStatus.playing:
        return playingString;
      case GameStatus.played:
        return playedString;
      default:
        return '';
    }
  }

  @override
  final String editionFieldString = 'Edición';
  @override
  final String statusFieldString = 'Estado';
  @override
  final String ratingFieldString = 'Valoración';
  @override
  final String thoughtsFieldString = 'Notas';
  @override
  final String timeLogFieldString = 'Tiempo de juego';
  @override
  final String timeLogsFieldString = 'Tiempo de juego';
  @override
  final String saveFolderFieldString = 'Carpeta de guardado';
  @override
  final String screenshotFolderFieldString = 'Carpeta de capturas';
  @override
  final String backupFieldString = 'Backup';

  @override
  String get singleCalendarViewString =>
      '$timeLogsFieldString & $finishDatesFieldString';
  @override
  String get multiCalendarViewString => timeLogsFieldString;
  @override
  final String editTimeString = 'Tiempo';
  @override
  final String selectedDateIsFinishDateString = 'Terminado este día';
  @override
  final String gameCalendarEventsString = 'Evento de calendario';
  @override
  String get firstTimeLog => 'Primer $timeLogsFieldString';
  @override
  String get lastTimeLog => 'Último $timeLogsFieldString';
  @override
  String get previousTimeLog => '$timeLogsFieldString anterior';
  @override
  String get nextTimeLog => '$timeLogsFieldString siguiente';
  @override
  String get emptyTimeLogsString => 'No existe $timeLogsFieldString';
  @override
  String rangeString(CalendarRange range) {
    switch (range) {
      case CalendarRange.day:
        return 'Día';
      case CalendarRange.week:
        return 'Semana';
      case CalendarRange.month:
        return 'Mes';
      case CalendarRange.year:
        return 'Año';
    }
  }

  @override
  String totalGames(int total) {
    return '$total ' + (total > 1 ? gamesString : gameString);
  }

  @override
  final String dateString = 'Fecha';
  @override
  final String startTimeString = 'Hora de inicio';
  @override
  final String endTimeString = 'Hora de fin';
  @override
  final String durationString = 'Tiempo';
  @override
  final String recalculationModeTitle = 'Modo de recálculo';
  @override
  final String recalculationModeSubtitle =
      'Afecta al valor que se recalculará si otros valores cambian';
  @override
  final String recalculationModeDurationString = 'Recalcular tiempo';
  @override
  final String recalculationModeTimeString = 'Recalcular horas';

  @override
  final String playingViewString = 'Jugando';
  @override
  final String nextUpViewString = 'Siguientes';
  @override
  final String lastPlayedString = 'Últimos jugaodos';
  @override
  final String lastFinishedViewString = 'Últimos terminados';

  @override
  String gamesFromYearString(int year) {
    return 'Terminado el ' + formatYear(year);
  }

  @override
  String get totalGamesString => '$gamesString totales';
  @override
  String get totalGamesPlayedString => '$gamesString jugados totales';
  @override
  String get totalTimeString => '$timeLogsFieldString totales';
  @override
  String get avgTimeString => '$timeLogsFieldString medio';
  @override
  String get avgRatingString => '$ratingFieldString medio';
  @override
  String get countByStatusString =>
      'Número de $gamesString por $statusFieldString';
  @override
  String get countByReleaseYearString =>
      'Número de $gamesString por $releaseYearFieldString';
  @override
  String get sumTimeByFinishDateString =>
      '$timeLogsFieldString total por $finishDateFieldString';
  @override
  String get sumTimeByMonth => '$timeLogsFieldString total por mes';
  @override
  String get countByRatingString =>
      'Número $gamesString por $ratingFieldString';
  @override
  String get countByFinishDate =>
      'Número de $gamesString por $finishDateFieldString';
  @override
  String get countByTimeString =>
      'Número de $gamesString por $timeLogsFieldString';
  @override
  String get avgRatingByFinishDateString =>
      'Media de $ratingFieldString por $finishDateFieldString';
  //#endregion Game

  //#region DLC
  @override
  final String dlcString = 'DLC';
  @override
  String get dlcsString => _plural(dlcString);

  @override
  final String baseGameFieldString = 'Juego base';
  //#endregion DLC

  //#region Purchase
  @override
  final String purchaseString = 'Compra';
  @override
  String get purchasesString => _plural(purchaseString);

  @override
  final String descriptionFieldString = 'Descripción';
  @override
  final String priceFieldString = 'Precio';
  @override
  final String externalCreditsFieldString = 'Crédito externo';
  @override
  final String purchaseDateFieldString = 'Fecha';
  @override
  final String originalPriceFieldString = 'Precio original';
  @override
  final String discountFieldString = 'Descuento';

  @override
  final String pendingViewString = 'Pendientes';
  @override
  final String lastPurchasedViewString = 'Últimos comprados';

  @override
  final String totalMoneySpentString = 'Dinero total gastado';
  @override
  final String totalMoneySavedString = 'Dinero total ahorrado';
  @override
  final String realValueString = 'Valor real';
  @override
  final String percentageSavedString = 'Porcentaje ahorrado';
  //#endregion Purchase

  //#region Store
  @override
  final String storeString = 'Tienda';
  @override
  String get storesString => _plural(storeString);
  //#endregion Store

  //#region Platform
  @override
  final String platformString = 'Plataforma';
  @override
  String get platformsString => _plural(platformString);

  @override
  final String physicalString = 'Físico';
  @override
  final String digitalString = 'Digital';
  @override
  String platformTypeString(PlatformType? type) {
    switch (type) {
      case PlatformType.physical:
        return physicalString;
      case PlatformType.digital:
        return digitalString;
      default:
        return '';
    }
  }

  @override
  final String platformTypeFieldString = 'Tipo';
  //#endregion Platform

  //#region System
  @override
  final String systemString = 'Sistema';
  @override
  String get systemsString => _plural(systemString);
  //#endregion System

  //#region Tag
  @override
  final String gameTagString = 'Etiqueta';
  @override
  String get gameTagsString => _plural(gameTagString);
  //#endregion Tag

  //#region PurchaseType
  @override
  final String purchaseTypeString = 'Tipo';
  @override
  String get purchaseTypesString => _plural(purchaseTypeString);
  //#endregion PurchaseType

  @override
  String formatEuro(double amount) {
    final String amountString = amount.toStringAsFixed(2);
    return '$amountString €';
  }

  @override
  String formatPercentage(double amount) {
    final String amountString = amount.toStringAsFixed(2);
    return '$amountString %';
  }

  @override
  String formatTimeOfDay(TimeOfDay time) {
    return _timeString(time.hour, time.minute);
  }

  @override
  String formatTime(DateTime date) {
    return _timeString(date.hour, date.minute);
  }

  String _timeString(int hour, int minute) {
    final String hourString = LocalisationsUtils.padTwoLeadingZeros(hour);
    final String minuteString = LocalisationsUtils.padTwoLeadingZeros(minute);
    return '$hourString:$minuteString';
  }

  @override
  String formatDate(DateTime date) {
    final String dayString = date.day.toString();
    final String monthString = date.month.toString();
    final String yearString = date.year.toString();
    return '$dayString/$monthString/$yearString';
  }

  @override
  String formatDateTime(DateTime date) {
    return formatDate(date) + ' ' + formatTime(date);
  }

  @override
  String formatDuration(Duration duration) {
    if (duration.isZero()) {
      return '0';
    }

    final int hours = duration.inHours;
    final int minutes = duration.extractNormalisedMinutes();

    final String hourString = formatHours(hours);
    final String minuteString = formatMinutes(minutes);

    if (hours == 0) {
      return minuteString;
    } else if (minutes == 0) {
      return hourString;
    }

    return '$hourString $minuteString';
  }

  @override
  String formatMonthYear(DateTime date) {
    final String month = months.elementAt(date.month - 1);
    final String year = formatYear(date.year);
    return '$month $year';
  }

  @override
  String formatYear(int year) {
    return year.toString();
  }

  @override
  String formatShortYear(int year) {
    return '\'' + year.toString().substring(2);
  }

  @override
  String formatHours(int hours) {
    return '$hours h.';
  }

  @override
  String formatMinutes(int minutes) {
    final String minuteString = LocalisationsUtils.padTwoLeadingZeros(minutes);
    return '$minuteString min.';
  }

  @override
  String editString(String fieldString) {
    return 'Editar $fieldString';
  }

  @override
  String addString(String fieldString) {
    return 'Añadir $fieldString';
  }

  @override
  final String fieldUpdatedString = 'Campo actualizado';
  @override
  final String unableToUpdateFieldString =
      'No ha sido posible actualizar el campo';
  @override
  final String uploadImageString = 'Subir imagen';
  @override
  final String replaceImageString = 'Reemplazar imagen';
  @override
  final String renameImageString = 'Renombrar imagen';
  @override
  final String deleteImageString = 'Borrar imagen';
  @override
  final String imageUpdatedString = 'Imagen actualizada';
  @override
  final String unableToUpdateImageString =
      'No ha sido posible actualizar la imagen';
  @override
  String unableToLaunchString(String urlString) {
    return 'No se puede abrir $urlString';
  }

  @override
  String linkString(String typeString) {
    return 'Vincular $typeString';
  }

  @override
  final String undoString = 'Deshacer';
  @override
  final String moreString = 'Más';
  @override
  final String searchInListString = 'Buscar en lista';
  @override
  String linkedString(String typeString) {
    return '$typeString vinculado';
  }

  @override
  String unableToLinkString(String typeString) {
    return 'No ha sido posible vincular $typeString';
  }

  @override
  String unlinkedString(String typeString) {
    return '$typeString desvinculado';
  }

  @override
  String unableToUnlinkString(String typeString) {
    return 'No ha sido posible desvincular $typeString';
  }

  @override
  String searchString(String typeString) {
    return 'Buscar $typeString';
  }

  @override
  final String clearSearchString = 'Limpiar';
  @override
  String newWithTitleString(String typeString, String titleString) {
    return '+ Nuevo $typeString con título \'$titleString\'';
  }

  @override
  final String noSuggestionsString = '';
  @override
  final String noResultsString = 'No se han encontrado resultados';

  String _plural(String string) => string + 's';
}
