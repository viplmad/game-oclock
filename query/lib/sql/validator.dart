import '../query/query.dart';

import 'sql_builder.dart';
import 'sql_builder_options.dart';


/// Validator & Sanitizer
class Validator {
  Validator._();

  static String sanitizeFieldAlias(String? value, SQLBuilderOptions options) {
    final String result = value != null?
        options.autoQuoteAliasNames
          ? options.fieldAliasQuoteCharacter + value + options.fieldAliasQuoteCharacter
          : value
        : '';

    return result;
  }

  static String sanitizeField(String value, SQLBuilderOptions options) {
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
        result = newParts.join('.');
      }
    }

    return result;
  }

  static String sanitizeTable(String name, SQLBuilderOptions options) {
    return options.autoQuoteTableNames ? options.nameQuoteCharacter + name + options.nameQuoteCharacter : name;
  }

  static String sanitizeTableAlias(String? value, SQLBuilderOptions options) {
    return value != null
        ? (options.autoQuoteAliasNames
            ? options.tableAliasQuoteCharacter + value + options.tableAliasQuoteCharacter
            : value)
        : '';
  }

  static Object formatValue(Object value, SQLBuilderOptions options) {
    if (value is String) {
      return formatString(value, options);
    } else if (value is Query) {
      return formatQueryBuilder(value, options);
    }

    return value.toString();
  }

  static String formatString(String value, SQLBuilderOptions options) {
    final String result = options.dontQuote
        ? '${escapeValue(value, options)}'
        : '${options.valueQuoteCharacter}${escapeValue(value, options)}${options.valueQuoteCharacter}';

    return result;
  }

  static String formatQueryBuilder(Query value, SQLBuilderOptions options) {
    return '(' + SQLQueryBuilder.buildString(value, options) + ')';
  }

  static String escapeValue(String value, SQLBuilderOptions options) {
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

  static String sanitizeTableDotField(String? tableName, String field, SQLBuilderOptions options) {

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
