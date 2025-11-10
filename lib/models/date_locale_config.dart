import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

final class DateLocaleConfig extends Equatable {
  final int? startingDayOfWeek;
  final DateFormat? dateFormat;
  final DateFormat? timeFormat;

  const DateLocaleConfig({
    this.startingDayOfWeek,
    this.dateFormat,
    this.timeFormat,
  });
  const DateLocaleConfig.def() : this();

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (startingDayOfWeek != null) {
      json[r'startingDayOfWeek'] = startingDayOfWeek;
    }
    if (dateFormat != null) {
      json[r'dateFormat'] = dateFormatToJson(dateFormat!);
    }
    if (timeFormat != null) {
      json[r'timeFormat'] = dateFormatToJson(timeFormat!);
    }
    return json;
  }

  static DateLocaleConfig fromJson(final dynamic value) {
    final json = value.cast<String, dynamic>();

    return DateLocaleConfig(
      startingDayOfWeek: json[r'startingDayOfWeek'],
      dateFormat: dateFormatFromJson(json[r'dateFormat']),
      timeFormat: dateFormatFromJson(json[r'timeFormat']),
    );
  }

  @override
  List<Object?> get props => [
    startingDayOfWeek,
    dateFormat?.pattern,
    timeFormat?.pattern,
  ];
}

DateFormat? dateFormatFromJson(final dynamic value) =>
    value != null ? DateFormat(value) : null;

String dateFormatToJson(final DateFormat value) => value.pattern ?? '';
