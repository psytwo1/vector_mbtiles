import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'provider_exception.dart';

class MBTilesUtility {
  final String _mbtilesPath;
  Database? _database;
  MBTilesUtility(this._mbtilesPath) {
    _getDatabase(_mbtilesPath).then((value) => _database);
  }

  Future<Uint8List> getVectorTileBytes(TileIdentity tile) async {
    final max = pow(2, tile.z).toInt();
    if (tile.x >= max || tile.y >= max || tile.x < 0 || tile.y < 0) {
      throw ProviderException(
          message: 'Invalid tile coordinates $tile',
          retryable: Retryable.none,
          statusCode: 400);
    }
    _database ??= await _getDatabase(_mbtilesPath);

    final resultSet =
        await _database!.query('tiles', columns: ['tile_data'], where: '''
      zoom_level = ?
      AND tile_column = ?
      AND tile_row = ?
      ''', whereArgs: [tile.z, tile.x, max - tile.y - 1]);

    if (resultSet.length == 1) {
      final tileData = resultSet.first['tile_data'];
      final ungzipTile = GZipCodec().decode(tileData as Uint8List);
      return ungzipTile as Uint8List;
    } else if (resultSet.length > 1) {
      throw ProviderException(
          message: 'Too many match tiles', retryable: Retryable.none);
    } else {
      return Uint8List(0);
    }
  }

  Future<Database> _getDatabase(String url) async {
    var databasesPath = await getDatabasesPath();
    final dbFilename = url.split('/').last;
    var path = join(databasesPath, dbFilename);
    var exists = await databaseExists(path);

    if (!exists) {
      var data = await rootBundle.load(url);
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }
}
