//
//  Wallet.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import Foundation
import CommonCrypto

let kCheckSumLen = 64
let kCurveLen = 1
let kPublicKeyLen = 33
let kPrivateKeyLen = 32
let kKeyCountLen = 1
let kDecryptKeyLen = 32
let kAESBlockSize = 16

public typealias Byte = UInt8
public typealias Bytes = [UInt8]

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
        guard hashedPassword.count == kCheckSumLen else {
            throw WalletError.invalidPassword
        }
        
        checksum = hashedPassword
        
        let key = hashedPassword.subdata(in: Range(0..<kDecryptKeyLen))
        let iv = hashedPassword.subdata(in: Range(kDecryptKeyLen..<kDecryptKeyLen+kAESBlockSize))

        let decrypted = AESCBCDecrypt(data: cipher, key: key, iv: iv)
        guard let decryptedData = decrypted else {
            throw WalletError.decryptFailed
        }
        
        return try decodeKeys(from: decryptedData)
    }
    
    func decodeKeys(from decrypted: Data) throws -> Keys {
        var index = 0
        
        guard decrypted.count >= kCheckSumLen else {
            throw WalletError.decryptFailed
        }
        let checksum = decrypted.subdata(in: Range(index..<index+kCheckSumLen))
        index += kCheckSumLen
        guard self.checksum != nil && checksum == self.checksum else {
            throw WalletError.decryptFailed
        }
        
        guard decrypted.count >= index + kKeyCountLen else {
            throw WalletError.invalidCipher
        }
        let count = decrypted.subdata(in: Range(index..<index+kKeyCountLen)).first!
        index += kKeyCountLen

        var keys = Keys()
        for _ in 0..<count {
            let publicCurveByte = decrypted.subdata(in: Range(index..<index+kCurveLen)).first!
            let publicCurve = try Curve(byte: publicCurveByte)
            index += kCurveLen
            
            let publicBytes = decrypted.subdata(in: Range(index..<index+kPublicKeyLen))
            index += kPublicKeyLen
            
            let privateCurveByte = decrypted.subdata(in: Range(index..<index+kCurveLen)).first!
            let privateCurve = try Curve(byte: privateCurveByte)
            index += kCurveLen
            
            let privateBytes = decrypted.subdata(in: Range(index..<index+kPrivateKeyLen))
            index += kPrivateKeyLen
            
            keys.append((PublicKey(curve: publicCurve, bytes: publicBytes), PrivateKey(curve: privateCurve, bytes: privateBytes)))
        }
        
        return keys
    }
}
