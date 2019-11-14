#import "PreloadedImagesPlugin.h"
#import <preloaded_images/preloaded_images-Swift.h>

@implementation PreloadedImagesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPreloadedImagesPlugin registerWithRegistrar:registrar];
}
@end
