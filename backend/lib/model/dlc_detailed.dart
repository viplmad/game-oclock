import 'package:game_collection_client/api.dart' show DLCDTO;

class DLCDetailed extends DLCDTO {
  DLCDetailed({
    required super.addedDatetime,
    super.baseGameId,
    super.coverFilename,
    required super.id,
    required super.name,
    super.releaseYear,
    required super.updatedDatetime,
    this.firstFinish,
  });

  final DateTime? firstFinish;

  static DLCDetailed withDTO(DLCDTO dto, DateTime? firstFinish) {
    return DLCDetailed(
      addedDatetime: dto.addedDatetime,
      baseGameId: dto.baseGameId,
      coverFilename: dto.coverFilename,
      id: dto.id,
      name: dto.name,
      releaseYear: dto.releaseYear,
      updatedDatetime: dto.updatedDatetime,
      firstFinish: firstFinish,
    );
  }
}
