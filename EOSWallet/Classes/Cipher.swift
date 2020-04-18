//
//  Cipher.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import CommonCrypto
import CryptoKit

func AESCBCDecrypt(data: Data, key: Data, iv: Data) -> Data? {
    return key.withUnsafeBytes { keyUnsafe in
        return data.withUnsafeBytes { dataUnsafe in
            return iv.withUnsafeBytes { ivUnsafe in
                let outSize = data.count + kCCBlockSizeAES128 * 2
                let outData = UnsafeMutableRawPointer.allocate(byteCount: outSize, alignment: 1)
                
                defer {
                    outData.deallocate()
                }
                
                var moved = 0
                let status = CCCrypt(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), keyUnsafe.baseAddress, key.count, ivUnsafe.baseAddress, dataUnsafe.baseAddress, data.count, outData, outSize, &moved)
                guard status == kCCSuccess else {
                    return nil
                }
                
                return Data(bytes: outData, count: moved)
            }
        }
    }
}

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = Byte(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    func sha512() -> Data {
        let digest = SHA512.hash(data: self)
        let bytes = Bytes(digest.makeIterator())
        return Data(bytes: bytes)
    }
}
