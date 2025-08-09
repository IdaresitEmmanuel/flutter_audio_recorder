import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        setUpFlutterMethodChannels(window?.rootViewController as! FlutterViewController)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: FLUTTER METHOD CHANNELS
    func setUpFlutterMethodChannels(_ controller: FlutterViewController){
        // Set Up MethodChannel
        let methodChannel = FlutterMethodChannel(name: "com.hyequest.audiorecorder.methodchannel", binaryMessenger:
                                                controller.binaryMessenger)
        methodChannel.setMethodCallHandler(HyeFlutterMethodHandler.handle)
        // Set up EventChannel
        let eventChannel = FlutterEventChannel(name: "com.hyequest.audiorecorder.waveform_eventchannel", binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(AudioRecorderEventStreamHandler())
    }
}
