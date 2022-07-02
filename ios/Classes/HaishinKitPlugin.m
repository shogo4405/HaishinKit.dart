#import "HaishinKitPlugin.h"
#if __has_include(<haishin_kit/haishin_kit-Swift.h>)
#import <haishin_kit/haishin_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "haishin_kit-Swift.h"
#endif

@implementation HaishinKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHaishinKitPlugin registerWithRegistrar:registrar];
}
@end
