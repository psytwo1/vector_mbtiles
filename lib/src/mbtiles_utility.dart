import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import 'provider_exception.dart';

/// MBTilesUtility is MBTiles access utility.
class MBTilesUtility {
  /// A constructor of `MBTilesUtility` class.
  /// [_mbtilesPath] MBTiles path
  MBTilesUtility(this._mbtilesPath) {
    getDBFuture = _getDatabase(_mbtilesPath);
  }
  final String _mbtilesPath;
  Database? _database;
  late Future<Database> getDBFuture;

  /// Get VectorTileBytes in binary
  /// [tile] TileIdentity(z, x, y)
  Future<Uint8List> getVectorTileBytes(TileIdentity tile) async {
    final max = pow(2, tile.z).toInt();
    if (tile.x >= max || tile.y >= max || tile.x < 0 || tile.y < 0) {
      throw ProviderException(
        message: 'Invalid tile coordinates $tile',
        retryable: Retryable.none,
        statusCode: 400,
      );
    }

    _database ??= await getDBFuture;

    final resultSet = await _database!.query(
      'tiles',
      columns: ['tile_data'],
      where: '''
      zoom_level = ?
      AND tile_column = ?
      AND tile_row = ?
      ''',
      whereArgs: [tile.z, tile.x, max - tile.y - 1],
    );

    if (resultSet.length == 1) {
      final tileData = resultSet.first['tile_data'];
      final ungzipTile = GZipCodec().decode(tileData! as Uint8List);
      return ungzipTile as Uint8List;
    } else if (resultSet.length > 1) {
      throw ProviderException(
        message: 'Too many match tiles',
        retryable: Retryable.none,
      );
    } else {
      return Uint8List(0);
    }
  }

  Future<Database> _getDatabase(String url) async {
    String databasesPath;
    String dbFullPath;
    final dbFilename = url.split('/').last;

    databasesPath = await getDatabasesPath();
    dbFullPath = path.join(databasesPath, dbFilename);

    final exists = await databaseExists(dbFullPath);
    if (!exists) {
      final data = await rootBundle.load(url);
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(dbFullPath).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(dbFullPath);
  }
}
