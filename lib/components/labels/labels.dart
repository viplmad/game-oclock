import 'package:flutter/material.dart';
import 'package:game_oclock/components/label_chip.dart';
import 'package:game_oclock/constants/icons.dart';
import 'package:game_oclock/models/models.dart';
import 'package:game_oclock/utils/localisation_extension.dart';

class LabelsContainer extends StatelessWidget {
  const LabelsContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) {
    return Column(spacing: 0.0, children: children);
  }
}

class TextLabel extends StatelessWidget {
  const TextLabel({
    super.key,
    required this.label,
    required this.value,
    this.multiline = false,
  });

  final String label;
  final String? value;
  final bool multiline;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      subtitle: Text(
        value ?? '',
        style: Theme.of(context).textTheme.bodyLarge,
        maxLines: multiline ? null : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class MultipleTextLabel extends StatelessWidget {
  const MultipleTextLabel({super.key, required this.label, this.value});

  final String label;
  final List<String>? value;
  final separator = ',';

  @override
  Widget build(final BuildContext context) {
    return TextLabel(label: label, value: value?.join('$separator '));
  }
}

class BoolLabel extends StatelessWidget {
  const BoolLabel({super.key, required this.label, required this.value});

  final String label;
  final bool? value;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: value == null
          ? const Text('-')
          : value!
          ? CommonIcons.yes
          : CommonIcons.no,
    );
  }
}

class DateLabel extends StatelessWidget {
  const DateLabel({
    super.key,
    required this.label,
    required this.value,
    required this.dateConfig,
  });

  final String label;
  final DateTime? value;
  final DateLocaleConfig dateConfig;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null ? null : dateConfig.dateFormat.format(value!),
    );
  }
}

class TimeLabel extends StatelessWidget {
  const TimeLabel({
    super.key,
    required this.label,
    required this.value,
    required this.dateConfig,
  });

  final String label;
  final DateTime? value;
  final DateLocaleConfig dateConfig;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null ? null : dateConfig.timeFormat.format(value!),
    );
  }
}

class DateTimeLabel extends StatelessWidget {
  const DateTimeLabel({
    super.key,
    required this.label,
    required this.value,
    required this.dateConfig,
  });

  final String label;
  final DateTime? value;
  final DateLocaleConfig dateConfig;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null ? null : dateConfig.dateTimeFormat.format(value!),
    );
  }
}

class DurationLabel extends StatelessWidget {
  const DurationLabel({super.key, required this.label, required this.value});

  final String label;
  final Duration? value;

  @override
  Widget build(final BuildContext context) {
    return TextLabel(
      label: label,
      value: value == null ? '0' : context.localize().duration(value!),
    );
  }
}

class ChoiceLabel extends StatelessWidget {
  const ChoiceLabel({
    super.key,
    required this.label,
    required this.value,
    required this.options,
  });

  final String label;
  final String? value;
  final List<DropdownField> options;

  @override
  Widget build(final BuildContext context) {
    final option = options.firstWhere(
      (final element) => element.value == value,
      orElse: () => DropdownField(
        value: value ?? '',
        labelBuilder: (final context) => value ?? '',
      ),
    );

    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: value == null
          ? const Text('-')
          : LabelChip(label: option.labelBuilder(context), color: option.color),
    );
  }
}

class RatingLabel extends StatelessWidget {
  const RatingLabel({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final int? value;
  final Color? color;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: value == null
          ? const Text('-')
          : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonIcons.star(color),
                Text(
                  value!.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
    );
  }
}
