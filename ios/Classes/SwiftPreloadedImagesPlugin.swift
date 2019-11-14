import Flutter
import UIKit
import Photos

public class SwiftPreloadedImagesPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "preloaded_images", binaryMessenger: registrar.messenger())
        let instance = SwiftPreloadedImagesPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
        }
        else if (call.method == "getImages") {
            var latestImagesThreshold = 10 // count by default
            guard let args = call.arguments else {
//                result([])
                return
            }
            if let myArgs = args as? [String: Any],
                let abc = myArgs["count"] as? Int {
                latestImagesThreshold = abc
            }else{
                print("Something went wrong in fetching the count")
//                result([])
            }
            
            DispatchQueue.main.async {
                let imgManager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
                fetchOptions.fetchLimit = latestImagesThreshold

                let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
                var allImages = [String]()
                
                var totalItration = 0
                print("fetchResult.count : \(fetchResult.count)")
                
                var savedLocalIdentifiers = [String]()
                
                for index in 0..<fetchResult.count
                {
                    let asset = fetchResult.object(at: index) as PHAsset
                    let localIdentifier = asset.localIdentifier
                    savedLocalIdentifiers.append(localIdentifier)
                    
                    imgManager.requestImage(for: asset, targetSize: CGSize(width: 512.0, height: 512.0), contentMode: PHImageContentMode.aspectFit, options: PHImageRequestOptions(), resultHandler:{(image, info) in
                        
                        if image != nil {
                            var imageData: Data?
                            if let cgImage = image!.cgImage, cgImage.renderingIntent == .defaultIntent {
                                imageData = image!.jpegData(compressionQuality: 0.8)
                            }
                            else {
                                imageData = image!.pngData()
                            }
                            let guid = ProcessInfo.processInfo.globallyUniqueString;
                            let tmpFile = String(format: "image_picker_%@.jpg", guid);
                            let tmpDirectory = NSTemporaryDirectory();
                            let tmpPath = (tmpDirectory as NSString).appendingPathComponent(tmpFile);
                            if(FileManager.default.createFile(atPath: tmpPath, contents: imageData, attributes: [:])) {
                                allImages.append(tmpPath)
                            }
                        }
                        totalItration += 1
                        if totalItration == (fetchResult.count) {
                            result(allImages)
                        }
                    })
                }
            }
        }
    }
}
