# preloaded_images

A new flutter plugin to fetch latest 'X' images from mobile storage. It returns list of asset url's and works both on IOS and Android.

### Usage

```

Future<void> loadImageList() async {
    List<String> allImage = List<String>();
    List allImageTemp = await PreloadedImages.getImages(count: 5); // your custom count goes here
    allImage.addAll(allImageTemp);
  }
  
  
```

## Note

  IOS: As getting Path URL from PHAsset is asynchronous, the order may not be in sorted form but you will get latest 'X' number of images for sure.
  
  Android: You get images in sorted order.

### Preview
![grab-landing-page](https://github.com/sur950/preloaded_images/blob/master/image2.png)

![grab-landing-page](https://github.com/sur950/preloaded_images/blob/master/image1.png)
