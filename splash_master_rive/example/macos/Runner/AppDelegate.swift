import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
      override func applicationDidFinishLaunching(_ notification: Notification) {
            if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "macos_splash",
        binaryMessenger: controller.engine.binaryMessenger
      )

      channel.setMethodCallHandler { [weak self] call, result in
        if call.method == "removeSplash" {
          (self?.mainFlutterWindow as? MainFlutterWindow)?.removeSplash()
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }

        super.applicationDidFinishLaunching(notification)
      }
    
}
