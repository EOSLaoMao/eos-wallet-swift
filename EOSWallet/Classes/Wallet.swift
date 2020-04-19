//
//  Wallet.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import Foundation
import CommonCrypto

public typealias Keys = [(pub: PublicKey, pri: PrivateKey)]

public class Wallet {
    public let cipher: Data
    private var checksum: Data?
    
    public init(cipherText: String) throws {
        guard let hexed = Data(hexString: cipherText) else {
            throw WalletError.invalidCipher
        }
        self.cipher = hexed
    }
    
    public func unlock(password: String) throws -> Keys {
        guard password.count > 0 else {
            throw WalletError.invalidPassword
        }
        guard let passwordData = password.data(using: .utf8) else {
            throw WalletError.invalidPassword
        }
        
        let hashedPassword = passwordData.sha512()
        guard hashedPassword.count == Const.checkSumLen else {
            throw WalletError.invalidPassword
        }
        
        checksum = hashedPassword
        
        let key = hashedPassword.subdata(in: 0..<Const.decryptKeyLen)
        let iv = hashedPassword.subdata(in: Const.decryptKeyLen..<Const.decryptKeyLen+Const.aesBlockSize)

        let decrypted = AESCBCDecrypt(data: cipher, key: key, iv: iv)
        guard let decryptedData = decrypted else {
            throw WalletError.decryptFailed
        }
        
        return try decodeKeys(from: decryptedData)
    }
    
    private func decodeKeys(from decrypted: Data) throws -> Keys {
        let reader = BytesReader(data: decrypted)
        
        let checksum = try reader.getBytes(len: Const.checkSumLen)
        guard self.checksum != nil && checksum == self.checksum else {
            throw WalletError.decryptFailed
        }
        
        let count = try reader.getByte()

        var keys = Keys()
        for _ in 0..<count {
            let publicCurve = try Curve(byte: reader.getByte())
            let publicContent = try reader.getBytes(len: Const.publicKeyLen)
            
            let privateCurve = try Curve(byte: reader.getByte())
            let privateContent = try reader.getBytes(len: Const.privateKeyLen)
            
            let keyPair = (
                PublicKey(
                    curve: publicCurve,
                    bytes: publicContent
                ),
                PrivateKey(
                    curve: privateCurve,
                    bytes: privateContent
                )
            )
            keys.append(keyPair)
        }
        
        return keys
    }
}
