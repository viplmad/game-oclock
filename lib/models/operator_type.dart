import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

import 'nav_destination.dart';

final List<OptionTextField<String>> operatorOptions =
    List.unmodifiable(<OptionTextField<String>>[
      OptionTextField(
        value: OperatorType.eq.value,
        labelBuilder: (final context) => context.localize().equalLabel,
      ),
      OptionTextField(
        value: OperatorType.notEq.value,
        labelBuilder: (final context) => context.localize().notEqualLabel,
      ),
      OptionTextField(
        value: OperatorType.gt.value,
        labelBuilder: (final context) => context.localize().greaterThanLabel,
      ),
      OptionTextField(
        value: OperatorType.gte.value,
        labelBuilder: (final context) =>
            context.localize().greaterThanEqualLabel,
      ),
      OptionTextField(
        value: OperatorType.lt.value,
        labelBuilder: (final context) => context.localize().lessThanLabel,
      ),
      OptionTextField(
        value: OperatorType.lte.value,
        labelBuilder: (final context) => context.localize().lessThanEqualLabel,
      ),
      OptionTextField(
        value: OperatorType.startsWith.value,
        labelBuilder: (final context) => context.localize().startsWithLabel,
      ),
      OptionTextField(
        value: OperatorType.notStartsWith.value,
        labelBuilder: (final context) => context.localize().notStartsWithLabel,
      ),
      OptionTextField(
        value: OperatorType.endsWith.value,
        labelBuilder: (final context) => context.localize().endsWithLabel,
      ),
      OptionTextField(
        value: OperatorType.notEndsWith.value,
        labelBuilder: (final context) => context.localize().notEndsWithLabel,
      ),
      OptionTextField(
        value: OperatorType.contains.value,
        labelBuilder: (final context) => context.localize().containsLabel,
      ),
      OptionTextField(
        value: OperatorType.notContains.value,
        labelBuilder: (final context) => context.localize().notContainsLabel,
      ),
    ]);
