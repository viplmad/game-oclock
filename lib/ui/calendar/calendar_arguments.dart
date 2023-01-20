class SingleGameCalendarArguments {
  const SingleGameCalendarArguments({
    required this.itemId,
    this.onChange,
  });

  final int itemId;
  final void Function()? onChange;
}
