//
//  Decoder.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import Foundation

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
}

public struct PublicKey {
    let curve: Curve
    let bytes: Data
}

public struct PrivateKey {
    let curve: Curve
    let bytes: Data
}

public struct DecodedWallet {
    let checksum: Data
    let keys: [(pub: PublicKey, pri: PrivateKey)]
}
