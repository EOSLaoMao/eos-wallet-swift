//
//  Error.swift
//  EOSWallet
//
//  Created by Shawn Lee on 2020/4/17.
//

import Foundation

enum WalletError: Error {
    case invalidCipher
    case invalidPassword
    case decryptFailed
}
