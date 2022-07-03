import Foundation
import Flutter
import HaishinKit

class RTMPConnectionHandler {
    var instances: [Double: RTMPConnection] = [:]
    private let plugin: SwiftHaishinKitPlugin

    init(plugin: SwiftHaishinKitPlugin) {
        self.plugin = plugin
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "RtmpConnection#create":
            let memory = Double(instances.count)
            instances[memory] = RTMPConnection()
            result(NSNumber(value: memory))
        case "RtmpConnection#connect":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber,
                let command = arguments["command"] as? String else {
                return
            }
            instances[memory.doubleValue]?.connect(command)
        case "RtmpConnection#close":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            instances[memory.doubleValue]?.close()
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
