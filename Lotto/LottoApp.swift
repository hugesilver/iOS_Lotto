//
//  LottoApp.swift
//  Lotto
//
//  Created by 김태은 on 2023/09/26.
//

import SwiftUI
import NMapsMap

@main
struct LottoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let ncpKeyId = Bundle.main.object(forInfoDictionaryKey: "NCP_KEY_ID") as! String
        NMFAuthManager.shared().ncpKeyId = ncpKeyId

        return true
    }
}
