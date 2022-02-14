class SingleGameCalendarArguments {
  const SingleGameCalendarArguments({
    required this.itemId,
    this.onUpdate,
  });

  final int itemId;
  final void Function()? onUpdate;
}
