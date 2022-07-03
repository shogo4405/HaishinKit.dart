import Foundation
import Flutter
import HaishinKit
import AVFoundation

class RTMPStreamHandler {
    var instances: [Double: RTMPStream] = [:]
    private let plugin: SwiftHaishinKitPlugin

    init(plugin: SwiftHaishinKitPlugin) {
        self.plugin = plugin
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "RtmpStream#create":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber,
                let connection = plugin.rtmpConnectionHandler.instances[memory.doubleValue] else {
                return
            }
            let count = Double(instances.count)
            instances[count] = RTMPStream(connection: connection)
            result(NSNumber(value: count))
        case "RtmpStream#attachAudio":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            let source = arguments["source"] as? [String: Any?]
            if source == nil {
                instances[memory.doubleValue]?.attachAudio(nil)
            } else {
                instances[memory.doubleValue]?.attachAudio(AVCaptureDevice.default(for: .audio))
            }
        case "RtmpStream#attachVideo":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            let source = arguments["source"] as? [String: Any?]
            if source == nil {
                instances[memory.doubleValue]?.attachCamera(nil)
            } else {
                instances[memory.doubleValue]?.attachCamera(DeviceUtil.device(withPosition: .back))
            }
        case "RtmpStream#play":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            instances[memory.doubleValue]?.play(arguments["name"] as? String)
        case "RtmpStream#publish":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            instances[memory.doubleValue]?.publish(arguments["name"] as? String)
        case "RtmpStream#registerTexture":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber,
                let stream = instances[memory.doubleValue],
                let registry = plugin.registrar?.textures() else {
                return
            }
            let texture = NetStreamDrawableTexture(registry: registry)
            texture.attachStream(stream)
            result(texture.id)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
