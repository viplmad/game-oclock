class ItemImage {
  const ItemImage(String? url, String? filename)
      : url = url ?? '',
        filename = filename ?? '';

  const ItemImage.empty() : this(null, null);

  final String url;
  final String filename;
}
