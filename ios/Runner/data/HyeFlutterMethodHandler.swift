//
//  FlutterMethodHandler.swift
//  Runner
//
//  Created by Emmanuel Idaresit on 08/08/2025.
//

class HyeFlutterMethodHandler {
    // Audio Recorder variables
    private static let audioRecorder = AudioRecorder.shared
    
    static func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        switch call.method {
        case "requestMicrophonePermission":
            Task{
                do{
                   let granted = try await audioRecorder.setUp()
                    result(granted)
                } catch {
                    result(FlutterError(code: "RECORDER_PERMISSION_ERROR", message: "Unable to setup recorder", details:"\(error)"))
                }
            }
        case "startRecorder":
            Task{
                do{
                    print("why me!!")
                    try await audioRecorder.start()
                    result(true)
                } catch RecorderError.missingMicrophonePermission {
                    result(FlutterError(code: "MISSING_MICROPHONE_PERMISSION", message: "Microphone permission denied", details: ""))
                } catch {
                    result(FlutterError(code: "RECORDER_START_ERROR", message: "Unable to start recorder", details:"\(error)"))
                }
            }
        case "pauseRecorder":
            audioRecorder.pause()
            result(true)
        case "resumeRecorder":
            do{
                try audioRecorder.resume()
                result(true)
            }catch {
                result(FlutterError(code: "RECORDER_RESUME_ERROR", message: "Unable to resume recorder", details:"\(error)"))
            }
        case "stopRecorder":
            audioRecorder.stop()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
