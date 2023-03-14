class SingleGameCalendarArguments {
  const SingleGameCalendarArguments({
    required this.itemId,
    this.onChange,
  });

  final String itemId;
  final void Function()? onChange;
}
