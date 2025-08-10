//
//  RecordWaveformModel.swift
//  Runner
//
//  Created by Hyebreed on 10/08/2025.
//

class RecordWaveformModel {
    let timestamp: TimeInterval
    let data: [Double]
    
    init(timestamp: TimeInterval, data: [Double]) {
        self.timestamp = timestamp
        self.data = data
    }
    
    func toDictionary() -> [String: Any]{
        return [
            "timestamp": timestamp,
            "data": data
        ]
    }
}
