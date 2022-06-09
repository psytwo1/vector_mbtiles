import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_mbtiles/vector_mbtiles_provider.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart'
    as vector_tile_renderer;
import 'test_osm_bright_ja_style.dart';

void main() {
  testWidgets('adds one to input values', (tester) async {
    // final calculator = Calculator();
    // expect(calculator.addOne(2), 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);

    await tester.pumpWidget(const TestApp());
    // expect(find.byType(FlutterMap), findsOneWidget);
    // expect(find.byType(VectorTileLayerWidget), findsOneWidget);
  });
}

class TestApp extends StatefulWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  State<TestApp> createState() => _MyHomePageState();
}

// class _TestAppState extends State<TestApp> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: SizedBox(
//             width: 200,
//             height: 200,
//             child: FlutterMap(
//                 options: MapOptions(
//                   center: LatLng(35.68132332775388, 139.76712479771956),
//                   zoom: 13,
//                 ),
//                 children: [
//                   VectorTileLayerWidget(
//                     options: VectorTileLayerOptions(
//                         theme: _mapTheme(context),
//                         tileProviders: TileProviders({
//                           'openmaptiles': VectorMBTilesProvider(
//                               mbtilesPath:
//                                   '/Users/jrc/Documents/vector_mbtiles/example/assets/example.mbtiles',
//                               // this is the maximum zoom of the provider, not the
//                               // maximum of the map. vector tiles are rendered
//                               // to larger sizes to support higher zoom levels
//                               maximumZoom: 18)
//                         })),
//                   ),
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
// }

// _mapTheme(BuildContext context) {
//   // maps are rendered using themes
//   // to provide a dark theme do something like this:
//   // if (MediaQuery.of(context).platformBrightness == Brightness.dark) return myDarkTheme();
//   return TestOSMBrightTheme.osmBrightJaTheme();
// }

// extension TestOSMBrightTheme on ProvidedThemes {
//   static vector_tile_renderer.Theme osmBrightJaTheme({Logger? logger}) =>
//       ThemeReader(logger: logger).read(testOsmBrightJaStyle());
// }
class _MyHomePageState extends State<TestApp> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MaterialApp(
        home: Scaffold(
            body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(35.68132332775388, 139.76712479771956),
            zoom: 15,
            maxZoom: 18,
            plugins: [VectorMapTilesPlugin()],
          ),
          children: [
            VectorTileLayerWidget(
              options: VectorTileLayerOptions(
                  theme: _mapTheme(context),
                  tileProviders: TileProviders(
                      {'openmaptiles': _cachingTileProvider(_basemapPath())})),
            ),
          ]),
    )));
  }
}

VectorTileProvider _cachingTileProvider(String mbtilesPath) {
  return MemoryCacheVectorTileProvider(
      delegate: VectorMBTilesProvider(
          mbtilesPath: mbtilesPath,
          // this is the maximum zoom of the provider, not the
          // maximum of the map. vector tiles are rendered
          // to larger sizes to support higher zoom levels
          maximumZoom: 18),
      maxSizeBytes: 1024 * 1024 * 2);
}

_mapTheme(BuildContext context) {
  // maps are rendered using themes
  // to provide a dark theme do something like this:
  // if (MediaQuery.of(context).platformBrightness == Brightness.dark) return myDarkTheme();
  return OSMBrightTheme.osmBrightJaTheme();
}

extension OSMBrightTheme on ProvidedThemes {
  static vector_tile_renderer.Theme osmBrightJaTheme({Logger? logger}) =>
      ThemeReader(logger: logger).read(testOsmBrightJaStyle());
}

String _basemapPath() {
  return '/Users/jrc/Documents/vector_mbtiles/example/assets/example.mbtiles';
}
