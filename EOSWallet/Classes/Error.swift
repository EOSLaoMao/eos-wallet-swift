//
//  Error.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import Foundation

public enum WalletError: Error {
    case invalidCipher
    case invalidPassword
    case decryptFailed
    case unsupportCurve
    
    public var localizedDescription: String {
        switch self {
        case .invalidCipher:
            return "invalid cipher text"
        case .invalidPassword:
            return "invalid unlock password"
        case .decryptFailed:
            return "decrypt failed"
        case .unsupportCurve:
            return "unsupport curve"
        }
    }
}
