/*import 'package:game_collection/client/ifile_connector.dart';
import 'package:game_collection/client/iimage_connector.dart';

import 'package:game_collection/model/model.dart';

import 'icollection_repository.dart';


class LocalRepository extends ICollectionRepository {

  LocalRepository._(IFileConnector iFileConnector, IImageConnector iImageConnector) {
    _iFileConnector = iFileConnector;
    _iImageConnector = iImageConnector;
  }

  IFileConnector _iFileConnector;
  IImageConnector _iImageConnector;

  static LocalRepository _singleton;
  factory LocalRepository({IFileConnector iFileConnector, IImageConnector iImageConnector}) {
    if(_singleton == null) {
      _singleton = LocalRepository._(
        iFileConnector,
        iImageConnector,
      );
    }

    return _singleton;
  }

}*/