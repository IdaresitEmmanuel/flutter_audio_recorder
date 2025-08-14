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
    func setUpFlutterMethodChannels(_ controller: FlutterViewController) {
        // Set Up MethodChannel
        let methodChannel = FlutterMethodChannel(name: "com.hyequest.audiorecorder.methodchannel", binaryMessenger:
                                                    controller.binaryMessenger)
        methodChannel.setMethodCallHandler(HyeFlutterMethodHandler.handle)
        // Set up Recorder Waveform EventChannel
        let recorderWaveformEventChannel = FlutterEventChannel(name: "com.hyequest.audiorecorder.recorder_waveform_eventchannel", binaryMessenger: controller.binaryMessenger)
        recorderWaveformEventChannel.setStreamHandler(AudioRecorderWaveformStreamHandler())
        
        // Set up Recorder Status EventChannel
        let recorderStatusEventChannel = FlutterEventChannel(name: "com.hyequest.audiorecorder.recorder_status_eventchannel", binaryMessenger: controller.binaryMessenger)
        recorderStatusEventChannel.setStreamHandler(AudioRecorderStatusStreamHandler())
        
//        Task{
//            try? await AudioRecorder.shared.prepare()
//        }
    }
}
