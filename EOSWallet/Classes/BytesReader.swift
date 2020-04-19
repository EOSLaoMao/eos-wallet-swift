//
//  BytesReader.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/19.
//

import Foundation

class BytesReader {
    private var index = 0
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    func getByte() throws -> Byte {
        let step = 1
        try checkOutbounds(step)
        let result = data.subdata(in: Range(index..<index+1)).first!
        stepIndex(step: step)
        return result
    }
    
    func getBytes(len: Int) throws -> Data {
        try checkOutbounds(len)
        let result = data.subdata(in: Range(index..<index+len))
        stepIndex(step: len)
        return result
    }
    
    private func stepIndex(step: Int) {
        index += step
    }
    
    private func checkOutbounds(_ bound: Int) throws {
        if index + bound > data.count {
            throw WalletError.invalidCipher
        }
    }
}
