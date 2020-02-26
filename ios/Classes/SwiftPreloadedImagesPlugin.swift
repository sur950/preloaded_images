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
                return
            }
            if let myArgs = args as? [String: Any],
                let abc = myArgs["count"] as? Int {
                latestImagesThreshold = abc
            } else{
                print("Something went wrong in fetching the count")
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

                            asset.requestContentEditingInput(with: nil, completionHandler: { (input, dictInfo) in
                                if let input = input {
                                    let path = input.fullSizeImageURL?.absoluteString ?? ""
                                    if path != "" {
                                        allImages.append(path)
                                        totalItration += 1
                                        if totalItration == (fetchResult.count) {
                                            var finalList = [String]()
                                            // for ind in 0..<allImages.count{
                                            //     var newPath = ""
                                            //     var pat = allImages[ind].split(separator: "/")
                                            //     pat.remove(at: 0)
                                            //     for i in 0..<pat.count{
                                            //         newPath.append("/"+pat[i])
                                            //     }
                                            //     finalList.append(newPath)
                                            // }
                                            for ind in 0..<allImages.count{
                                                var newPath = ""
                                                var pat = allImages[ind].split(separator: "/")
                                                pat.remove(at: 0)
                                                for i in 0..<pat.count{
                                                    newPath.append("/"+pat[i])
                                                }
                                                let photoUrl = String(pat.last ?? "preloaded_images_%@.jpg")
                                                let imageData: Data = try! Data(contentsOf: URL(fileURLWithPath: newPath))
                                                let guid = ProcessInfo.processInfo.globallyUniqueString;
                                                let tmpFile = String(format: photoUrl, guid);
                                                let tmpDirectory = NSTemporaryDirectory();
                                                let tmpPath = (tmpDirectory as NSString).appendingPathComponent(tmpFile);
                                                if(FileManager.default.createFile(atPath: tmpPath, contents: imageData, attributes: [:])) {
                                                    finalList.append(tmpPath)
                                                }
                                            }
                                            result(finalList)
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
            }
        }
    }
}
