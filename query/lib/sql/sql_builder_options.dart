class SQLBuilderOptions {
  SQLBuilderOptions({
    this.autoQuoteTableNames = true,
    this.autoQuoteFieldNames = true,
    this.autoQuoteAliasNames = true,
    this.replaceSingleQuotes = false,
    this.replaceDoubleQuotes = false,
    this.ignorePeriodsForFieldNameQuotes = false,
    this.dontQuote = true,
    this.nameQuoteCharacter = '"',
    this.tableAliasQuoteCharacter = '"',
    this.valueQuoteCharacter = "'",
    this.fieldAliasQuoteCharacter = '"',
    this.singleQuoteReplacement = "''",
    this.doubleQuoteReplacement = '""',
    this.separator = ' ',
    this.quoteStringWithFieldsTablesSeparator = true,
    this.fieldsTablesSeparator = '.',
  });

  ///Indicates whether table names are rendered inside quotes. Default: TRUE.
  /// The quote character used is configurable via the `nameQuoteCharacter` option
  final bool autoQuoteTableNames;

  ///Indicates whether field names are rendered inside quotes. Default: TRUE.
  // The quote character used is configurable via the nameQuoteCharacter option.
  final bool autoQuoteFieldNames;

  /// Indicates whether alias names are rendered inside quotes. Default: TRUE.
  /// The quote character used is configurable via the `tableAliasQuoteCharacter` and `fieldAliasQuoteCharacter` options.
  final bool autoQuoteAliasNames;

  /// Indicates whether to replaces all single quotes within strings. Default: FALSE.
  /// The replacement string used is configurable via the `singleQuoteReplacement` option.
  final bool replaceSingleQuotes;

  /// Indicates whether to ignore period (.) when automatically quoting the `field` name. Default: FALSE.
  final bool replaceDoubleQuotes;

  /// Indicates whether don't quote string values while formatting. Default: FALSE.
  final bool ignorePeriodsForFieldNameQuotes;

  /// Specifies the quote character used for when quoting `table` and `field` names.
  final bool dontQuote;
  final String nameQuoteCharacter;

  /// Specifies the quote character used for when quoting `table alias` names.
  final String tableAliasQuoteCharacter;

  final String valueQuoteCharacter;

  /// Specifies the quote character used for when quoting `field alias` names.
  final String fieldAliasQuoteCharacter;

  /// Specifies the string to replace single quotes with in query strings.
  final String singleQuoteReplacement;
  final String doubleQuoteReplacement;

  /// Specifies the string to join individual blocks in a query when it's stringified.
  final String separator;

  /// quote table and field string with dot, example:
  /// db.select().fields(['tablename.fieldname']).from('tablename') result in
  ///  SELECT "tablename"."fieldname" FROM tablename
  final bool quoteStringWithFieldsTablesSeparator;
  final String fieldsTablesSeparator;

  int insertParamIndex = 0;
  int setParamIndex = 0;
  int whereParamIndex = 0;

  void incrementInsertParamIndex() {
    insertParamIndex++;
  }

  void incrementSetParamIndex() {
    setParamIndex++;
  }

  void incrementWhereParamIndex() {
    whereParamIndex++;
  }

  void resetIndexes() {
    insertParamIndex = 0;
    setParamIndex = 0;
    whereParamIndex = 0;
  }
}
