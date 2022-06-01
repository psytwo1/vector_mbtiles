import 'package:flutter_test/flutter_test.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_mbtiles/vector_mbtiles_provider.dart';
import 'package:vector_tile/vector_tile.dart';

void main() {
  test('adds one to input values', () async {
    // final calculator = Calculator();
    // expect(calculator.addOne(2), 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);

    final VectorMBTilesProvider vectorMBTilesProvider =
        VectorMBTilesProvider(mbtilesPath: 'mbtilesPath');
    TileIdentity testTileIdentity = TileIdentity(1, 1, 1);
    final tilebytes = await vectorMBTilesProvider.provide(testTileIdentity);
    final VectorTile vectorTile = VectorTile.fromBytes(bytes: tilebytes);
    final geojson = vectorTile.toGeoJson(
        x: testTileIdentity.x, y: testTileIdentity.y, z: testTileIdentity.z);
  });
}
