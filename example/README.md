# preloaded_images_example

Demonstrates how to use the preloaded_images plugin.

## Getting Started

```

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

  // Call this function at your app start or at any place
  // to fetch the latest images from your phone storage.
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: loading
              ? CircularProgressIndicator()
              : allImage.length == 0
                  ? Text(
                      "Either permission was declined or no images in storage",
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              "${allImage[index]}",
                              fit: BoxFit.cover,
                              height: 100,
                              // width: 100,
                            ),
                          ),
                        );
                      },
                      itemCount: allImage.length,
                    ),
        ),
      ),
    );
  }
}

```