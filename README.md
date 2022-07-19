<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# VectorMBTiles

VectorMB Tiles is a Flutter plugin for working with Mapbox Vector Tiles in FlutterMap. 

![Screenshot_1654750708](https://user-images.githubusercontent.com/17922561/179644816-e5d0f2f4-f38e-4e6f-a7d2-02dcde6bebd8.png)

## Features

By extending VectorTileProvider and specifying VectorMBTiles as the argument of MemoryCacheVectorTileProvider to delegate, it can operate at high speed in memory.

## Getting started

Add the package with the following command
```bash
flutter pub add vector_mbtiles
```

## Usage

refer to the following. See `/example` folder for details

```dart
VectorTileLayerWidget(
    options: VectorTileLayerOptions(
        theme: Theme,
        tileProviders: TileProviders({
            'openmaptiles': VectorMBTilesProvider(
                mbtilesPath: '/path/to/mbtiles',
                maximumZoom: 18)
        })
    ),
)
```
