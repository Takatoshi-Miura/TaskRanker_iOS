//
//  UserDefaultsKey.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/13.
//

import UIKit

enum UserDefaultsKey: String {
    // 保存Key一覧
    case firstLaunch = "firstLaunch"    // 初回起動判定
    case agree       = "agree"          // 利用規約への同意状況
    case userID      = "userID"         // アカウント持ちならFirebaseID、なければ端末のUID
    case address     = "address"        // アカウントのメールアドレス
    case password    = "password"       // アカウントのパスワード
    case useFirebase = "useFirebase"    // Firebase利用フラグ
    case character   = "character"      // キャラクター番号
    
    // メソッド
    func set(value: Int) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
 
    func integer() -> Int {
        return UserDefaults.standard.integer(forKey: self.rawValue)
    }
    
    func set(value: Float) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func float() -> Float {
        return UserDefaults.standard.float(forKey: self.rawValue)
    }
    
    func set(value: Double) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func double() -> Double {
        return UserDefaults.standard.double(forKey: self.rawValue)
    }
    
    func set(value: Bool) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func bool() -> Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
    
    func set(value: String) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func string() -> String {
        return UserDefaults.standard.string(forKey: self.rawValue)!
    }

    func set(value: Any) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    // 存在判定用
    func object() -> Any? {
        return UserDefaults.standard.object(forKey: self.rawValue)
    }
    
    func remove() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
    
    func register(value: [String:Any]) {
        UserDefaults.standard.register(defaults: value)
    }
    
}
