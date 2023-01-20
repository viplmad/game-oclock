class DetailArguments<T extends Object> {
  const DetailArguments({
    required this.item,
    this.onChange,
  });

  final T item;
  final void Function()? onChange;
}
