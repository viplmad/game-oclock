import 'package:game_oclock/mocks.dart';
import 'package:game_oclock/models/models.dart'
    show Device, PageResultDTO, SearchDTO;

class DeviceService {
  Future<PageResultDTO<Device>> search(
    final SearchDTO search,
    final String? quicksearch,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockPageResult(
      search: search,
      quicksearch: quicksearch,
      builder: (final index) =>
          mockDevice(name: 'name ($quicksearch) $index'),
    );
  }

  Future<int> count(final SearchDTO search, final String? quicksearch) async {
    await Future.delayed(const Duration(seconds: 1));
    return 500;
  }

  Future<Device> get(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockDevice();
  }

  Future<void> create(final Device device) async {
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<void> update(final Device device) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> delete(final String id) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
