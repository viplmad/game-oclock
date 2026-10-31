import 'package:game_oclock/constants/spaces.dart';
import 'package:game_oclock/models/models.dart'
    show
        ListSearch,
        addedDatetimeField,
        gameStatusNextUp,
        gameStatusPlaying,
        releaseDateField,
        statusField,
        titleField,
        updatedDatetimeField;
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock_client/api.dart';

final Map<String, List<ListSearch>> defaultListSearch = Map.unmodifiable(
  <String, List<ListSearch>>{CommonSpaces.game: gameDefaultFilters},
);

final List<ListSearch> gameDefaultFilters = List.unmodifiable(<ListSearch>[
  ListSearch.internal(
    id: 'main',
    labelBuilder: (context) => context.localize().mainLabel,
    filter: List.unmodifiable(<FilterDTO>[]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: releaseDateField.value, order: OrderType.asc),
      SortDTO(field: titleField.value, order: OrderType.asc),
    ]),
  ),
  ListSearch.internal(
    id: 'lastAdded',
    labelBuilder: (context) => context.localize().lastAddedLabel,
    filter: List.unmodifiable(<FilterDTO>[]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: addedDatetimeField.value, order: OrderType.desc),
    ]),
  ),
  ListSearch.internal(
    id: 'lastUpdated',
    labelBuilder: (context) => context.localize().lastUpdatedLabel,
    filter: List.unmodifiable(<FilterDTO>[]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: updatedDatetimeField.value, order: OrderType.desc),
    ]),
  ),
  ListSearch.internal(
    id: 'playing',
    labelBuilder: (context) => context.localize().playingLabel,
    filter: List.unmodifiable(<FilterDTO>[
      FilterDTO(
        field: statusField.value,
        operator_: OperatorType.eq,
        value: SearchValue(value: gameStatusPlaying.value),
      ),
    ]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: releaseDateField.value, order: OrderType.asc),
      SortDTO(field: titleField.value, order: OrderType.asc),
    ]),
  ),
  ListSearch.internal(
    id: 'nextUp',
    labelBuilder: (context) => context.localize().nextUpLabel,
    filter: List.unmodifiable(<FilterDTO>[
      FilterDTO(
        field: statusField.value,
        operator_: OperatorType.eq,
        value: SearchValue(value: gameStatusNextUp.value),
      ),
    ]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: releaseDateField.value, order: OrderType.asc),
      SortDTO(field: titleField.value, order: OrderType.asc),
    ]),
  ),
]);
