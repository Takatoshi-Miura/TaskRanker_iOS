//
//  AppDelegate.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 初回起動判定
        if !(UserDefaultsKey.firstLaunch.object() is Bool) {
            UserDefaultsKey.firstLaunch.set(value: true)
        }
        
        // ユーザーIDを作成
        if !(UserDefaultsKey.userID.object() is String) {
            let uuid = NSUUID().uuidString
            UserDefaultsKey.userID.set(value: uuid)
        }
        // TODO: FirebaseID
        
        
        // 初期画面を表示
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator()
        appCoordinator?.startFlow(in: window)
        
        return true
    }

}

