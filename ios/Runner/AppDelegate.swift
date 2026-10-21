import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let reduceTransparency = ReduceTransparencyStreamHandler()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: ReduceTransparencyStreamHandler.channel
    ) {
      FlutterEventChannel(
        name: ReduceTransparencyStreamHandler.channel,
        binaryMessenger: registrar.messenger()
      ).setStreamHandler(reduceTransparency)
    }
  }
}

final class ReduceTransparencyStreamHandler: NSObject, FlutterStreamHandler {
  static let channel = "dev.oznel.fujin/reduce_transparency"

  private var observer: NSObjectProtocol?

  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    observer = NotificationCenter.default.addObserver(
      forName: UIAccessibility.reduceTransparencyStatusDidChangeNotification,
      object: nil,
      queue: .main
    ) { _ in
      events(UIAccessibility.isReduceTransparencyEnabled)
    }
    events(UIAccessibility.isReduceTransparencyEnabled)
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    if let observer {
      NotificationCenter.default.removeObserver(observer)
    }
    observer = nil
    return nil
  }
}
