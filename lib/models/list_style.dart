enum ListStyle { tile, grid }

const defaultListStyle = ListStyle.tile;

ListStyle parseListStyle(final String value) =>
    ListStyle.values.firstWhere((final element) => element.name == value);
