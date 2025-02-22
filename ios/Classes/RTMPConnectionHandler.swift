import Foundation
import Flutter
import HaishinKit

final class RTMPConnectionHandler: NSObject, MethodCallHandler {
    var instance: RTMPConnection?
    private let plugin: HaishinKitPlugin
    private var channel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    private var subscription: Task<(), Error>? {
        didSet {
            oldValue?.cancel()
        }
    }

    init(plugin: HaishinKitPlugin) {
        self.plugin = plugin
        super.init()
        let id = Int(bitPattern: ObjectIdentifier(self))
        if let messanger = plugin.registrar?.messenger() {
            self.channel = FlutterEventChannel(name: "com.haishinkit.eventchannel/\(id)", binaryMessenger: messanger)
        } else {
            self.channel = nil
        }
        instance = RTMPConnection()
        channel?.setStreamHandler(self)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task {
            switch call.method {
            case "RtmpConnection#connect":
                guard
                    let arguments = call.arguments as? [String: Any?],
                    let command = arguments["command"] as? String else {
                    return
                }
                if let instance {
                    subscription = Task {
                        for await status in await instance.status {
                            eventSink?(status.makeEvent())
                        }
                    }
                }
                _ = try? await instance?.connect(command)
                result(nil)
            case "RtmpConnection#close":
                subscription = nil
                try? await instance?.close()
                result(nil)
            case "RtmpConnection#dispose":
                instance = nil
                plugin.onDispose(id: Int(bitPattern: ObjectIdentifier(self)))
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

extension RTMPConnectionHandler: FlutterStreamHandler {
    // MARK: FlutterStreamHandler
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
