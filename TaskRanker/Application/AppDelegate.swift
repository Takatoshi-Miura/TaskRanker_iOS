//
//  AppDelegate.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit
import RealmSwift
import Firebase
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初期化
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // 初回起動判定
        if !(UserDefaultsKey.firstLaunch.object() is Bool) {
            UserDefaultsKey.firstLaunch.set(value: true)
        }
        
        // ユーザーIDを作成
        if !(UserDefaultsKey.userID.object() is String) {
            UserDefaultsKey.userID.set(value: NSUUID().uuidString)
        }
        
        // キャラクターを設定
        if !(UserDefaultsKey.character.object() is Int) {
            UserDefaultsKey.character.set(value: Character.chipoyo.rawValue)
        }
        
        // Firebaseログイン
        if ((UserDefaultsKey.address.object() is String)) &&
            ((UserDefaultsKey.password.object() is String))
        {
            let address =  UserDefaultsKey.address.string()
            let password = UserDefaultsKey.password.string()
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if error == nil {
                    // ログイン成功時、FirebaseのユーザーIDを使用
                    UserDefaultsKey.userID.set(value: Auth.auth().currentUser!.uid)
                    UserDefaultsKey.useFirebase.set(value: true)
                }
            }
        } else {
            UserDefaultsKey.useFirebase.set(value: false)
        }
        
        // 初期画面を表示
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator()
        appCoordinator?.startFlow(in: window)
        
        return true
    }

}

