import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('package imports match the pubspec package name', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final nameMatch = RegExp(r'^name:\s*(\S+)', multiLine: true).firstMatch(pubspec);
    expect(nameMatch, isNotNull, reason: 'pubspec.yaml must define a package name');

    final packageName = nameMatch!.group(1)!;
    final libDir = Directory('lib');
    final oldImports = <String>[];

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }

      final content = entity.readAsStringSync();
      if (content.contains("package:tencent_cloud_chat_flutter_demo/")) {
        oldImports.add(entity.path);
      }
    }

    expect(
      oldImports,
      isEmpty,
      reason: 'Found imports using package:tencent_cloud_chat_flutter_demo/ while pubspec package name is $packageName.',
    );
  });
}
