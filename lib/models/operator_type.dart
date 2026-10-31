import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'nav_destination.dart';

final List<OptionTextField<String>> operatorOptions = List.unmodifiable(
  <OptionTextField<String>>[
    OptionTextField(
      value: OperatorType.eq.value,
      labelBuilder: (context) => context.localize().equalLabel,
    ),
    OptionTextField(
      value: OperatorType.notEq.value,
      labelBuilder: (context) => context.localize().notEqualLabel,
    ),
    OptionTextField(
      value: OperatorType.gt.value,
      labelBuilder: (context) => context.localize().greaterThanLabel,
    ),
    OptionTextField(
      value: OperatorType.gte.value,
      labelBuilder: (context) => context.localize().greaterThanEqualLabel,
    ),
    OptionTextField(
      value: OperatorType.lt.value,
      labelBuilder: (context) => context.localize().lessThanLabel,
    ),
    OptionTextField(
      value: OperatorType.lte.value,
      labelBuilder: (context) => context.localize().lessThanEqualLabel,
    ),
    OptionTextField(
      value: OperatorType.startsWith.value,
      labelBuilder: (context) => context.localize().startsWithLabel,
    ),
    OptionTextField(
      value: OperatorType.notStartsWith.value,
      labelBuilder: (context) => context.localize().notStartsWithLabel,
    ),
    OptionTextField(
      value: OperatorType.endsWith.value,
      labelBuilder: (context) => context.localize().endsWithLabel,
    ),
    OptionTextField(
      value: OperatorType.notEndsWith.value,
      labelBuilder: (context) => context.localize().notEndsWithLabel,
    ),
    OptionTextField(
      value: OperatorType.contains.value,
      labelBuilder: (context) => context.localize().containsLabel,
    ),
    OptionTextField(
      value: OperatorType.notContains.value,
      labelBuilder: (context) => context.localize().notContainsLabel,
    ),
  ],
);
