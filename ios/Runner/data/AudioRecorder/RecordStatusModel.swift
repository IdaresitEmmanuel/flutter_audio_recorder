//
//  RecordStatusModel.swift
//  Runner
//
//  Created by Emmanuel Idaresit on 10/08/2025.
//
import Foundation

class RecordStatusModel {
    let isRecording: Bool
    let recordDuration: TimeInterval
    
    init(isRecording: Bool, recordDuration: TimeInterval) {
        self.isRecording = isRecording
        self.recordDuration = recordDuration
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "isRecording": isRecording,
            "recordDuration": recordDuration,
        ]
    }
}
