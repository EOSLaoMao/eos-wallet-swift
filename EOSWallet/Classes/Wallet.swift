//
//  Wallet.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import Foundation
import CommonCrypto

let kCheckSumLen = 64
let kDecryptKeyLen = 32
let kAESBlockSize = 16

public class Wallet {
    public let cipher: Data
    
    private(set) var isLocked: Bool = false
    
    public init(cipherText: String) throws {
        guard let hexed = Data(hexString: cipherText) else {
            throw WalletError.invalidCipher
        }
        self.cipher = hexed
    }
    
    public func unlock(password: String) throws {
        guard password.count > 0 else {
            throw WalletError.invalidPassword
        }
        guard let passwordData = password.data(using: .utf8) else {
            throw WalletError.invalidPassword
        }
        
        let hashedPassword = passwordData.sha512()
        guard hashedPassword.count == kCheckSumLen else {
            throw WalletError.invalidPassword
        }
        
        let key = hashedPassword.subdata(in: Range(0..<kDecryptKeyLen))
        let iv = hashedPassword.subdata(in: Range(kDecryptKeyLen..<kDecryptKeyLen+kAESBlockSize))

        let decrypted = AESCBCDecrypt(data: cipher, key: key, iv: iv)
        guard let decryptedData = decrypted else {
            throw WalletError.decryptFailed
        }
        
    }
}
