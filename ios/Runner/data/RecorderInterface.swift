//
//  RecorderInterface.swift
//  Runner
//
//  Created by Emmanuel Idaresit on 08/08/2025.
//


    enum RecorderError : Error {
        case missingMicrophonePermission
        case unexpectedStatus(OSStatus)
    }

