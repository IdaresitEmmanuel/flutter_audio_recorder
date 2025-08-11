//
//  AudioRecorderStatusStreamHandler.swift
//  Runner
//
//  Created by Emmanuel Idaresit on 10/08/2025.
//

class AudioRecorderStatusStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
 
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        AudioRecorder.shared.onRecordStatusData = { [weak self] samples in
            print("sample data = \(samples)")
            self?.eventSink?(samples) // send waveform data to Flutter
        }

        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        AudioRecorder.shared.stop()
        eventSink = nil
        return nil
    }
}
