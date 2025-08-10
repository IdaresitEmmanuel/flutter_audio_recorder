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
    
    private var timer: DispatchSourceTimer?
    private var recordDuration: TimeInterval = 0 // in seconds
    
    var onWaveformData: (([String: Any]) -> Void)?
    var onRecordStatusData: (([String: Any]) -> Void)?
    
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
        startTimer()
        print("Recording started at \(format.sampleRate) Hz")
        sendRecordStatus()
    }
    
    
    func pause(){
        audioEngine.pause()
        stopTimer()
        sendRecordStatus()
    }
    
    func resume() throws {
        try audioEngine.start()
        startTimer()
        sendRecordStatus()
    }
    
    func stop() {
        audioEngine.inputNode.removeTap(onBus: bus)
        audioEngine.stop()
        sendRecordStatus()
        stopTimer()
        recordDuration = 0
    }
    
    private func startTimer() {
        stopTimer() // ensure no duplicates
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInitiated))
        timer.schedule(deadline: .now(), repeating: 0.5) // every 500ms
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.recordDuration += 0.5
        }
        timer.resume()
        self.timer = timer
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    private  func processAudioBuffer(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        
        let samples = Array(UnsafeBufferPointer(start: channelData, count: frameLength))
        let normalized = samples.map { Double($0) } // Flutter will expect doubles
        
        
        let waveformModel = RecordWaveformModel(timestamp: recordDuration, data: normalized)
        onWaveformData?(waveformModel.toDictionary())
        sendRecordStatus()
    }
    
    private func sendRecordStatus(){
        let recordStatusModel = RecordStatusModel(isRecording: audioEngine.isRunning, recordDuration: recordDuration)
        onRecordStatusData?(recordStatusModel.toDictionary())
    }

}
