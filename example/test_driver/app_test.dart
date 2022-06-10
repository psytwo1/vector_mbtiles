import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  // keyでWidgetを取得する
  final vectorTileLayerWidget = find.byValueKey('VectorTileLayerWidget');
  late FlutterDriver driver; // Dart2以降はNullsafetyのため lateで初期化を遅延させる

  // すべてのテストの前にDriverに接続する
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });
  // すべてのテストの後にDriverを開放する
  tearDownAll(() async {
    driver.close();
  });

  test('display map', () async {
    await driver.waitFor(vectorTileLayerWidget);
    final dir = Directory.current.path;
    final path = p.join(dir, 'test_driver', 'expect.png');
    final expectImage = File(path).readAsBytes();

    await Future.delayed(const Duration(seconds: 20));
    final image = await driver.screenshot();
    expect(image, await expectImage);
  }, timeout: const Timeout(Duration(minutes: 1)));
}
