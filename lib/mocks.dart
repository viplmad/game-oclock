import 'package:game_oclock/models/models.dart' show UserGame;

UserGame mockUserGame() {
  return UserGame(
    id: 'lkdasmdlknuhiuahfksdjfha',
    externalId: 'steam',
    title: 'title',
    edition: '',
    releaseDate: DateTime.now(),
    genres: [],
    series: [],
    coverUrl:
        'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/224760/header.jpg',
    status: 'Played',
    rating: 9,
    notes: 'cosas',
  );
}
