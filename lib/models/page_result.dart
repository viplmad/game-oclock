class PageResultDTO<T> {
  PageResultDTO({this.data = const [], this.page = 0, this.size = 0});

  List<T> data;

  int page;

  int size;
}
