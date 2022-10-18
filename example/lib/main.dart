import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_mbtiles/vector_mbtiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart'
    as vector_tile_renderer;

import 'osm_bright_ja_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VectorMBTiles example',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'VectorMBTiles example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(35.68132332775388, 139.76712479771956),
                zoom: 15,
                maxZoom: 18,
                // plugins: [VectorMapTilesPlugin()],
              ),
              children: [
                VectorTileLayer(
                  key: const Key('VectorTileLayerWidget'),
                  theme: _mapTheme(context),
                  tileProviders: TileProviders(
                      {'openmaptiles': _cachingTileProvider(_basemapPath())}),
                ),
              ]),
        ));
  }
}

VectorTileProvider _cachingTileProvider(String mbtilesPath) {
  return MemoryCacheVectorTileProvider(
      delegate: VectorMBTilesProvider(
          mbtilesPath: mbtilesPath,
          // this is the maximum zoom of the provider, not the
          // maximum of the map. vector tiles are rendered
          // to larger sizes to support higher zoom levels
          maximumZoom: 14),
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
      ThemeReader(logger: logger).read(osmBrightJaStyle());
}

String _basemapPath() {
  return 'assets/example.mbtiles';
}
