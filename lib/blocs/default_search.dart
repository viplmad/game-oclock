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
import 'package:game_oclock_client/api.dart';

final Map<String, List<ListSearch>> defaultListSearch = Map.unmodifiable(
  <String, List<ListSearch>>{CommonSpaces.game: gameDefaultFilters},
);

final List<ListSearch> gameDefaultFilters = List.unmodifiable(<ListSearch>[
  ListSearch(
    id: 'main',
    name: 'Main', // TODO i18n
    internal: true,
    filter: List.unmodifiable(<FilterDTO>[]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: releaseDateField.value, order: OrderType.asc),
      SortDTO(field: titleField.value, order: OrderType.asc),
    ]),
  ),
  ListSearch(
    id: 'lastAdded',
    name: 'Last Added',
    internal: true,
    filter: List.unmodifiable(<FilterDTO>[]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: addedDatetimeField.value, order: OrderType.desc),
    ]),
  ),
  ListSearch(
    id: 'lastUpdated',
    name: 'Last Updated',
    internal: true,
    filter: List.unmodifiable(<FilterDTO>[]),
    sort: List.unmodifiable(<SortDTO>[
      SortDTO(field: updatedDatetimeField.value, order: OrderType.desc),
    ]),
  ),
  ListSearch(
    id: 'playing',
    name: 'Playing',
    internal: true,
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
  ListSearch(
    id: 'nextUp',
    name: 'Next Up',
    internal: true,
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
