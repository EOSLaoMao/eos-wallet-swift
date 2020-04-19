//
//  Decoder.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import Foundation

public typealias Byte = UInt8

struct Const {
    static let checkSumLen = 64
    static let publicKeyLen = 33
    static let privateKeyLen = 32
    static let decryptKeyLen = 32
    static let aesBlockSize = 16
}

public enum Curve {
    case k1
    case r1
    
    init(byte: UInt8) throws {
        switch byte {
        case 0:
            self = .k1
        case 1:
            self = .r1
        default:
            throw WalletError.unsupportCurve
        }
    }

    var name: String {
        get {
            switch self {
            case .k1:
                return "K1"
            case .r1:
                return "R1"
            }
        }
    }
    
    var byte: Byte {
        get {
            switch self {
            case .k1:
                return Byte(0)
            case .r1:
                return Byte(1)
            }
        }
    }
}

public struct PublicKey {
    public let curve: Curve
    public let bytes: Data
}

public struct PrivateKey {
    public let curve: Curve
    public let bytes: Data
}

public struct DecodedWallet {
    public let checksum: Data
    public let keys: [(pub: PublicKey, pri: PrivateKey)]
}
