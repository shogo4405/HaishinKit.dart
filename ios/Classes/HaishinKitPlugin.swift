import Flutter
import UIKit
import HaishinKit

public final class HaishinKitPlugin: NSObject {
    private static let instance = HaishinKitPlugin()

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance.registrar = registrar
        let channel = FlutterMethodChannel(name: "com.haishinkit", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private(set) var mixer: MediaMixerHandler? {
        didSet {
            oldValue?.stopRunning()
        }
    }
    private(set) var registrar: FlutterPluginRegistrar?
    private var handlers: [Int: MethodCallHandler] = [:]

    func onDispose(id: Int) {
        handlers.removeValue(forKey: id)
        var hasStreamHandler = false
        for handler in handlers where handler.value is RTMPStreamHandler {
            hasStreamHandler = true
        }
        if !hasStreamHandler {
            mixer = nil
        }
    }
}

extension HaishinKitPlugin: FlutterPlugin {
    // MARK: FlutterPlugin
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let memory = (call.arguments as? [String: Any?])?["memory"] as? NSNumber {
            if let handler = handlers[memory.intValue] {
                handler.handle(call, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
            return
        }
        switch call.method {
        case "newRtmpConnection":
            let handler = RTMPConnectionHandler(plugin: self)
            let memory = Int(bitPattern: ObjectIdentifier(handler))
            handlers[memory] = handler
            result(NSNumber(value: memory))
        case "newRtmpStream":
            guard
                let connection = (call.arguments as? [String: Any?])?["connection"] as? NSNumber,
                let handler = handlers[connection.intValue] as? RTMPConnectionHandler else {
                result(nil)
                return
            }
            if mixer == nil {
                mixer = MediaMixerHandler()
            }
            let stream = RTMPStreamHandler(plugin: self, handler: handler)
            let memory = Int(bitPattern: ObjectIdentifier(stream))
            handlers[memory] = stream
            result(NSNumber(value: memory))
        case "getPlatformVersion":
            result(kHaishinKitIdentifier)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
