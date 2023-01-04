class DetailArguments<T extends Object> {
  const DetailArguments({
    required this.item,
    this.onUpdate,
  });

  final T item;
  final void Function(T? item)? onUpdate;
}
