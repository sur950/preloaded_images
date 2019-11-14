import 'dart:async';
import 'package:flutter/services.dart';

class PreloadedImages {
  static const MethodChannel _channel = const MethodChannel('preloaded_images');

  /// To fetch the latest 'X' images from phone storage
  /// This function returns list of Local Image url's
  static Future<List> getImages({int count = 10}) async {
    List object = await _channel.invokeMethod('getImages', {"count": count});
    print(object);
    return object;
  }
}
