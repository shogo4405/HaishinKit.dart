import Flutter
import UIKit
import HaishinKit

public class SwiftHaishinKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.haishinkit", binaryMessenger: registrar.messenger())
    let instance = SwiftHaishinKitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  lazy var rtmpStreamHandler = RTMPStreamHandler(plugin: self)
  lazy var rtmpConnectionHandler = RTMPConnectionHandler(plugin: self)

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if call.method.contains("RtmpStream") {
          rtmpStreamHandler.handle(call, result: result)
          return
      }
      if call.method.contains("RtmpConnection") {
          rtmpConnectionHandler.handle(call, result: result)
          return
      }
      switch call.method {
      case "getVersion":
          result("1.0.0")
      default:
          result(FlutterMethodNotImplemented)
      }
  }
}
