//
//  AudioRecorder.swift
//  Runner
//
//  Created by Emmanuel Idaresit on 08/08/2025.
//

import AVFoundation

class AudioRecorder :  NSObject{
    
    static let shared = AudioRecorder()
    private override init(){}
    
    private  let audioEngine = AVAudioEngine()
    private  let bus = 0
    var onWaveformData: (([Double]) -> Void)?
    
    func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func start() async throws {
        let granted = await requestMicrophonePermission()
        guard granted else {
            throw RecorderError.missingMicrophonePermission
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputNode = self.audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: self.bus)
        
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: self.bus, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.processAudioBuffer(buffer: buffer)
        }
        
        try? self.audioEngine.start()
        print("Recording started at \(format.sampleRate) Hz")
        
    }
    
    
    func pause(){
        audioEngine.pause()
    }
    
    func resume() throws {
        try audioEngine.start()
    }
    
    func stop() {
        audioEngine.inputNode.removeTap(onBus: bus)
        audioEngine.stop()
    }
    
    private  func processAudioBuffer(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        
        let samples = Array(UnsafeBufferPointer(start: channelData, count: frameLength))
        let normalized = samples.map { Double($0) } // Flutter will expect doubles
        onWaveformData?(normalized)
    }

}
