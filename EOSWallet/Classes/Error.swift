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
        return (self as NSError).localizedDescription
    }
}

extension WalletError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidCipher:
            return NSLocalizedString("invalid cipher text", comment: "invalid cipher text")
        case .invalidPassword:
            return NSLocalizedString("invalid unlock password", comment: "invalid unlock password")
        case .decryptFailed:
            return NSLocalizedString("decrypt failed", comment: "decrypt failed")
        case .unsupportCurve:
            return NSLocalizedString("unsupport curve", comment: "unsupport curve")
        }
    }

    public var failureReason: String? {
        return errorDescription
    }

    public var recoverySuggestion: String? {
        return errorDescription
    }

    public var helpAnchor: String? {
        return errorDescription
    }
}
