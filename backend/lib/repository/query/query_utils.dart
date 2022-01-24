import 'package:query/query.dart';


class QueryUtils {
  QueryUtils._();

  static const int _pageRows = 100;

  static void paginate(Query query, int? page) {
    if(page != null && page >= 0) {
      query.offset(page * _pageRows);
      query.limit(_pageRows);
    }
  }
}