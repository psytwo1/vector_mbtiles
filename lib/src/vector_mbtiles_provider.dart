/// Library of MB Tiles in vector format.
library vector_mbtiles;

import 'dart:typed_data';

import 'package:vector_map_tiles/vector_map_tiles.dart';

import 'mbtiles_utility.dart';
import 'provider_exception.dart';

/// Vector MBTiles Provider.
class VectorMBTilesProvider extends VectorTileProvider {
  /// [mbtilesPath] the URL template, e.g. `'assets/data/map.mbtiles'`
  /// [maximumZoom] the maximum zoom supported by the tile provider, not to be
  ///  confused with the maximum zoom of the map widget. The map widget will
  ///  automatically use vector tiles from lower zoom levels once the maximum
  ///  supported by this provider is reached.
  VectorMBTilesProvider({required String mbtilesPath, int maximumZoom = 16})
      : _mbtilesURL = mbtilesPath,
        _maximumZoom = maximumZoom {
    _mbTiles = MBTilesUtility(_mbtilesURL);
  }
  final String _mbtilesURL;
  final int _maximumZoom;
  late MBTilesUtility _mbTiles;

  @override
  int get maximumZoom => _maximumZoom;

  @override
  Future<Uint8List> provide(TileIdentity tile) async {
    _checkTile(tile);
    return _mbTiles.getVectorTileBytes(tile);
  }

  void _checkTile(TileIdentity tile) {
    if (tile.z < 0 || tile.z > _maximumZoom || tile.x < 0 || tile.y < 0) {
      throw ProviderException(
        message: 'out of range',
        retryable: Retryable.none,
      );
    }
  }
}
