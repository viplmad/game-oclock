class PageResultDTO<T> {
  PageResultDTO({this.data = const [], this.page = 0, this.size = 0});

  final List<T> data;

  final int page;

  final int size;
}
