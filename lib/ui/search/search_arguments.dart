class SearchArguments {
  const SearchArguments({
    required this.onTapReturn,
    this.viewIndex,
    this.viewYear,
  });

  final bool onTapReturn;
  final int? viewIndex;
  final int? viewYear;
}
