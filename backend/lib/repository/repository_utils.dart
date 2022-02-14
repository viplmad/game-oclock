class RepositoryUtils {
  RepositoryUtils._();

  static Map<String, Object?> combineMaps(
    Map<String, Map<String, Object?>> manyMap,
    String primaryTableName,
  ) {
    final Map<String, Object?> combinedMaps = <String, Object?>{};

    manyMap.forEach((String table, Map<String, Object?> map) {
      if (table.isEmpty || table == primaryTableName) {
        combinedMaps.addAll(map);
      }
    });

    return combinedMaps;
  }
}
