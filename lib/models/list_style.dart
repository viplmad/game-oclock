enum ListStyle { tile, grid }

const defaultListStyle = ListStyle.tile;

ListStyle parseListStyle(String value) =>
    ListStyle.values.firstWhere((element) => element.name == value);

String listStyleToString(ListStyle value) => value.name;
