import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock_client/api.dart';

List<FilterDTO> buildStartDateBetweenFilters(
  final DateTime startDate,
  final DateTime endDate,
) {
  return List.unmodifiable(<FilterDTO>[
    FilterDTO(
      field: 'start_date',
      operator_: OperatorType.lt,
      value: SearchValue(value: endDate.toIso8601WithTzString()),
      chainOperator: ChainOperatorType.and,
    ),
    FilterDTO(
      field: 'end_date',
      operator_: OperatorType.gte,
      value: SearchValue(value: startDate.toIso8601WithTzString()),
      chainOperator: ChainOperatorType.and,
    ),
  ]);
}

FilterDTO buildFinishedFilter() {
  return FilterDTO(
    field: 'finished_status',
    operator_: OperatorType.eq,
    value: SearchValue(value: MediaStatus.completed.toJson()),
    chainOperator: ChainOperatorType.and,
  );
}

FetchMode calculateOnCurrentYear(final DateTime startDate) {
  final currentYear = DateTime.now().year;
  return currentYear == startDate.year
      ? FetchMode.onlyCalculate
      : FetchMode.storedOrCalculate;
}
