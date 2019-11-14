import 'package:flutter/material.dart';
import 'package:preloaded_images/preloaded_images.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List allImage = List();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getImages();
  }

  getImages() async {
    allImage = [];
    List allImageTemp = await PreloadedImages.getImages(count: 5);
    allImage.addAll(allImageTemp);
    print(allImage);
    setState(() {
      loading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : Container(
                alignment: Alignment.center,
                child: Image.asset(
                  // displaying only first image
                  // but will return you the count
                  "${allImage.first}",
                  fit: BoxFit.contain,
                ),
              ),
      ),
    );
  }
}
