import Foundation
import Flutter

protocol MethodCallHandler {
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)
}
