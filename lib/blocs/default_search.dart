import 'package:game_oclock/constants/spaces.dart';
import 'package:game_oclock/models/models.dart'
    show
        FilterDTO,
        ListSearch,
        OperatorType,
        OrderType,
        SearchDTO,
        SearchValue,
        SortDTO,
        addedDatetimeField,
        gameStatusNextUp,
        gameStatusPlaying,
        gameStatusWishlist,
        releaseDateField,
        statusField,
        titleField,
        updatedDatetimeField;

final Map<String, List<ListSearch>> defaultListSearch = Map.unmodifiable(
  <String, List<ListSearch>>{CommonSpaces.game: gameDefaultFilters},
);

final List<ListSearch> gameDefaultFilters = List.unmodifiable(<ListSearch>[
  ListSearch(
    id: 'main',
    name: 'Main', // TODO i18n
    internal: true,
    search: SearchDTO(
      filter: List.unmodifiable(<FilterDTO>[
        FilterDTO(
          field: statusField.value,
          operator_: OperatorType.notEq,
          value: SearchValue(value: gameStatusWishlist.value),
        ),
      ]),
      sort: List.unmodifiable(<SortDTO>[
        SortDTO(field: releaseDateField.value, order: OrderType.asc),
        SortDTO(field: titleField.value, order: OrderType.asc),
      ]),
    ),
  ),
  ListSearch(
    id: 'lastAdded',
    name: 'Last Added',
    internal: true,
    search: SearchDTO(
      filter: List.unmodifiable(<FilterDTO>[
        FilterDTO(
          field: statusField.value,
          operator_: OperatorType.notEq,
          value: SearchValue(value: gameStatusWishlist.value),
        ),
      ]),
      sort: List.unmodifiable(<SortDTO>[
        SortDTO(field: addedDatetimeField.value, order: OrderType.desc),
      ]),
    ),
  ),
  ListSearch(
    id: 'lastUpdated',
    name: 'Last Updated',
    internal: true,
    search: SearchDTO(
      filter: List.unmodifiable(<FilterDTO>[
        FilterDTO(
          field: statusField.value,
          operator_: OperatorType.notEq,
          value: SearchValue(value: gameStatusWishlist.value),
        ),
      ]),
      sort: List.unmodifiable(<SortDTO>[
        SortDTO(field: updatedDatetimeField.value, order: OrderType.desc),
      ]),
    ),
  ),
  ListSearch(
    id: 'playing',
    name: 'Playing',
    internal: true,
    search: SearchDTO(
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
  ),
  ListSearch(
    id: 'nextUp',
    name: 'Next Up',
    internal: true,
    search: SearchDTO(
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
  ),
  ListSearch(
    id: 'wishlist',
    name: 'Wishlist',
    internal: true,
    search: SearchDTO(
      filter: List.unmodifiable(<FilterDTO>[
        FilterDTO(
          field: statusField.value,
          operator_: OperatorType.eq,
          value: SearchValue(value: gameStatusWishlist.value),
        ),
      ]),
    ),
  ),
]);
