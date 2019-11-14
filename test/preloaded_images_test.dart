import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preloaded_images/preloaded_images.dart';

void main() {
  const MethodChannel channel = MethodChannel('preloaded_images');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '3';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getImages', () async {
    expect(await PreloadedImages.getImages(count: 3), '3');
  });
}
