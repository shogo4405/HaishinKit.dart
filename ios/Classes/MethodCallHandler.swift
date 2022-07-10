import Foundation

protocol MethodCallHandler {
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
}
