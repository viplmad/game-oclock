import 'query_builder.dart';
import 'query_builder_options.dart';
import 'util.dart';
import 'expression.dart';

/// Validator & Sanitizer
class Validator {
  Validator();

  static String sanitizeFieldAlias(String value, QueryBuilderOptions options) {
    final String result = options.autoQuoteAliasNames
        ? options.fieldAliasQuoteCharacter + value + options.fieldAliasQuoteCharacter
        : value;

    return result;
  }

  static String sanitizeFieldFromQueryBuilder(QueryBuilder value) {
    return '(${value.toString()})';
  }

  static String sanitizeField(String value, QueryBuilderOptions options) {
    String result = value;
    if (options.autoQuoteFieldNames) {
      final String quoteChar = options.nameQuoteCharacter;
      if (options.ignorePeriodsForFieldNameQuotes) {
        // a.b.c -> `a.b.c`
        result = quoteChar + value + quoteChar;
      } else {
        // a.b.c -> `a`.`b`.`c`
        final List<String> parts = value.split('\\.');
        final List<String> newParts = <String>[];
        for (final String part in parts) {
          // treat '*' as special case
          if (part == '*') {
            newParts.add(part);
          } else {
            newParts.add(quoteChar + part + quoteChar);
          }
        }
        result = Util.join('.', newParts);
      }
    }

    return result;
  }

  static String sanitizeTable(String name, QueryBuilderOptions options) {
    return options.autoQuoteTableNames ? options.nameQuoteCharacter + name + options.nameQuoteCharacter : name;
  }

  static String sanitizeTableAlias(String? value, QueryBuilderOptions options) {
    return value != null
        ? (options.autoQuoteAliasNames
            ? options.tableAliasQuoteCharacter + value + options.tableAliasQuoteCharacter
            : value)
        : '';
  }

  static String formatValue(Object? value, QueryBuilderOptions options) {
    if (value == null) {
      return formatNull();
    } else {
      if (value is num) {
        return formatNumber(value);
      } else if (value is String) {
        return formatString(value, options);
      } else if (value is bool) {
        return formatBoolean(value);
      } else if (value is QueryBuilder) {
        return formatQueryBuilder(value);
      } else if (value is Expression) {
        return formatExpression(value);
      } else if (value is List<Object>) {
        return formatArray(value, options);
      }
    }

    return value.toString();
  }

  static String escapeValue(String value, QueryBuilderOptions options) {
    String result = '';
    if (options.dontQuote) {
      if (value.startsWith("'") && value.endsWith("'")) {
        final String v = value.substring(1, value.length - 1);
        result = options.replaceSingleQuotes ? v.replaceAll("'", options.singleQuoteReplacement) : value;
        result = "'$result'";
      } else {
        result = options.replaceSingleQuotes ? value.replaceAll("'", options.singleQuoteReplacement) : value;
      }
    } else {
      result = options.replaceSingleQuotes ? value.replaceAll("'", options.singleQuoteReplacement) : value;
    }
    return result;
  }

  static String formatNull() {
    return '';
  }

  // ignore: avoid_positional_boolean_parameters
  static String formatBoolean(bool value) {
    return value ? 't' : 'f';
  }

  static String formatNumber(num value) {
    return value.toString();
  }

  static String formatString(String value, QueryBuilderOptions options) {
    final String result = options.dontQuote
        ? '${escapeValue(value, options)}'
        : '${options.valueQuoteCharacter}${escapeValue(value, options)}${options.valueQuoteCharacter}';

    return result;
  }

  static String formatQueryBuilder(QueryBuilder value) {
    return '(${value.toString()})';
  }

  static String formatExpression(Expression value) {
    return '(${value.toString()})';
  }

  static String formatIterable(List<dynamic> values, QueryBuilderOptions options) {
    final List<String> results = <String>[];
    for (final dynamic value in values) {
      results.add(formatValue(value, options));
    }
    return "(${Util.join(', ', results)})";
  }

  static String formatArray(List<Object> values, QueryBuilderOptions options) {
    return formatIterable(values, options);
  }

  static String sanitizeTableDotField(String? tableName, String field, QueryBuilderOptions options) {

    String fieldValue = Validator.sanitizeField(field.trim(), options);

    final String? tableNameValue =
        tableName != null ? Validator.sanitizeTableAlias(tableName, options) : null;

    /// quote table and field string with dot, example:
    /// "tablename"."fieldname"
    if (options.quoteStringWithFieldsTablesSeparator) {
      if (fieldValue.contains(options.fieldsTablesSeparator)) {
        fieldValue = fieldValue
            .split(options.fieldsTablesSeparator)
            .map((String f) => f)
            .join(
                '${options.fieldAliasQuoteCharacter}${options.fieldsTablesSeparator}${options.fieldAliasQuoteCharacter}');
      }
    } else if(tableNameValue != null) {
      fieldValue = tableNameValue + options.fieldsTablesSeparator + fieldValue;
    }

    return fieldValue;
  }
}
