import 'package:game_oclock/models/models.dart'
    show
        OptionTextField,
        deviceFieldOptions,
        gameFieldOptions,
        locationFieldOptions,
        playthroughFieldOptions,
        tagFieldOptions,
        userFieldOptions;

class CommonSpaces {
  CommonSpaces._();

  static const game = 'game';
  static const location = 'location';
  static const device = 'device';
  static const tag = 'tag';
  static const playthrough = 'playthrough';
  static const user = 'user';
}

List<OptionTextField<String>> getSpaceFieldOptions(final String space) {
  return switch (space) {
    CommonSpaces.game => gameFieldOptions,
    CommonSpaces.location => locationFieldOptions,
    CommonSpaces.device => deviceFieldOptions,
    CommonSpaces.tag => tagFieldOptions,
    CommonSpaces.playthrough => playthroughFieldOptions,
    CommonSpaces.user => userFieldOptions,
    _ => List.empty(growable: false),
  };
}
