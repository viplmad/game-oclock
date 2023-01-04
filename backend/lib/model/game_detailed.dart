import 'package:game_collection_client/api.dart' show GameDTO;

class GameDetailed extends GameDTO {
  GameDetailed({
    required super.addedDatetime,
    required super.backup,
    super.coverFilename,
    required super.edition,
    required super.id,
    required super.name,
    required super.notes,
    required super.rating,
    super.releaseYear,
    required super.saveFolder,
    required super.screenshotFolder,
    required super.status,
    required super.updatedDatetime,
    this.firstFinish,
    required this.totalTime,
  });

  final DateTime? firstFinish;
  final Duration totalTime;

  static GameDetailed withDTO(
    GameDTO dto,
    DateTime? firstFinish,
    Duration? totalTime,
  ) {
    return GameDetailed(
      addedDatetime: dto.addedDatetime,
      backup: dto.backup,
      coverFilename: dto.coverFilename,
      edition: dto.edition,
      id: dto.id,
      name: dto.name,
      notes: dto.notes,
      rating: dto.rating,
      releaseYear: dto.releaseYear,
      saveFolder: dto.saveFolder,
      screenshotFolder: dto.screenshotFolder,
      status: dto.status,
      updatedDatetime: dto.updatedDatetime,
      firstFinish: firstFinish,
      totalTime: totalTime ?? const Duration(),
    );
  }
}
