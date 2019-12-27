# preloaded_images

A new flutter plugin to fetch latest 'X' images from mobile storage. It returns list of asset url's and works both on IOS and Android.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

### Usage

```

Future<void> loadImageList() async {
    List<String> allImage = List<String>();
    List allImageTemp = await PreloadedImages.getImages(count: 5);
    allImage.addAll(allImageTemp);
  }
  
  
```

### Preview
![grab-landing-page](https://github.com/sur950/preloaded_images/blob/master/image2.png)

![grab-landing-page](https://github.com/sur950/preloaded_images/blob/master/image1.png)
