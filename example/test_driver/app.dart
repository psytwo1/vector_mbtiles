import 'package:example/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // 別プロセスのアプリケーションを起動できるようにするために拡張を有効にする
  enableFlutterDriverExtension();
  // アプリの起動
  app.main();
}
