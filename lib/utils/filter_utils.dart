import 'package:game_oclock/models/models.dart'
    show endDateField, finishedStatusField, startDateField;
import 'package:game_oclock/utils/date_time_extension.dart';
import 'package:game_oclock_client/api.dart';

List<FilterDTO> buildStartDateBetweenFilters(
  DateTime startDate,
  DateTime endDate,
) {
  return List.unmodifiable(<FilterDTO>[
    FilterDTO(
      field: startDateField.value,
      operator_: OperatorType.lt,
      value: SearchValue(value: endDate.toIso8601WithTzString()),
      chainOperator: ChainOperatorType.and,
    ),
    FilterDTO(
      field: endDateField.value,
      operator_: OperatorType.gte,
      value: SearchValue(value: startDate.toIso8601WithTzString()),
      chainOperator: ChainOperatorType.and,
    ),
  ]);
}

FilterDTO buildFinishedFilter() {
  return FilterDTO(
    field: finishedStatusField.value,
    operator_: OperatorType.eq,
    value: SearchValue(value: MediaStatus.completed.toJson()),
    chainOperator: ChainOperatorType.and,
  );
}

FetchMode calculateOnCurrentYear(DateTime startDate) {
  final currentYear = DateTime.now().year;
  return currentYear == startDate.year
      ? FetchMode.onlyCalculate
      : FetchMode.storedOrCalculate;
}
