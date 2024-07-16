import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        /// This code is for the integration with Apple Watch App
        assert(WCSession.isSupported(), "This app requires Watch Connectivity support!")
        WCSession.default.delegate = self
        WCSession.default.activate()
        
        initFlutterChannel()

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func initFlutterChannel() {
      if let controller = window?.rootViewController as? FlutterViewController {
        let channel = FlutterMethodChannel(
          name: "com.example.myquitbuddy.watchkitapp",
          binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({ [weak self] (
          call: FlutterMethodCall,
          result: @escaping FlutterResult) -> Void in
          switch call.method {
            case "flutterToWatch":
              guard WCSession.default.activationState == .activated else {
                  return
              }
              if let methodData = call.arguments as? [String: Any] {
                  let method = methodData["method"]
                  let data = methodData["data"]
                  //              guard let watchSession = self?.session, watchSession.isPaired, let methodData = call.arguments as? [String: Any],
                  //                  let method = methodData["method"], let data = methodData["data"] as? Any else {
                  //                  result(false)
                  //               return
                  //               }
                  
                  let watchData: [String: Any] = ["method": method, "data": data]
                  
                  WCSession.default.sendMessage(watchData, replyHandler: nil) { error in
                      print("errror: \(error)")
                  }
                  //               watchSession.sendMessage(watchData, replyHandler: nil, errorHandler: nil)
              }
              result(true)
            default:
               result(FlutterMethodNotImplemented)
            }
         })
       }
    }
}
extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation completed")
        var isReachable = false
        if WCSession.default.activationState == .activated {
            isReachable = WCSession.default.isReachable
        }
        print("Reachable \(isReachable)")
    }
    
    // Monitor WCSession reachability state changes.
    //
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Session did change \(session.isReachable)")
        
        var isReachable = false
        if WCSession.default.activationState == .activated {
            isReachable = WCSession.default.isReachable
        }
        print("Reachable DidChange \(isReachable)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let method = message["method"] as? String, let controller = self.window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(
                    name: "com.example.myquitbuddy.watchkitapp",
                    binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod(method, arguments: message)
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    
}
