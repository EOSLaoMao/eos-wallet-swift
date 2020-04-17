//
//  AppDelegate.swift
//  EOSWallet
//
//  Created by iCell on 04/17/2020.
//  Copyright (c) 2020 iCell. All rights reserved.
//

import UIKit
import EOSWallet

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        let wallet = try? Wallet(cipherText: "e8db2ebb34fa705645343868ef34372d3c0a9e8f09faf19380ea19d6eedb7248871c65fecc377221ea3c3ee07cb25b0b3b198810bd850595e989b5406a35de112503598c9c47d7ac8d76e659e612614611386373d3d4b57028b5cd42e4c0425900cd9a37e8bd5cd8a0bff2b0a1a40988f8a95e5d784f47cdba998c82e302e1e145cd460c14d9b41d14d07fcd41914f663313b7164ed0dd058a22d831282f8d73a9a71d49f39d2fa7c8ff48bc280456d059048382c77efd3d6f6fb3e110b4a0f22a2d3ea2d34ac7b720c0c73f45587161")
        try? wallet?.unlock(password: "PW5Kf7h86a2WvStSY3f5M6ntdiqqD7a6whvbMrWZMNSMtyrUYD92P")
        
        return true
    }

}

