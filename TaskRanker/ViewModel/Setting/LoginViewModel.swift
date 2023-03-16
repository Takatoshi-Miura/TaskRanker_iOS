//
//  LoginViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import Firebase

class LoginViewModel {
    
    /// ログイン処理
    /// - Parameters:
    ///   - address: メールアドレス
    ///   - pass: パスワード
    /// - Returns: エラーメッセージ
    func login(mail: String, password: String) -> String? {
        var errorMessage: String?
        Auth.auth().signIn(withEmail: mail, password: password) { authResult, error in
            if error != nil {
                if let errorCode = AuthErrorCode.Code(rawValue: error!._code) {
                    switch errorCode {
                    case .invalidEmail:
                        errorMessage = MESSAGE_INVALID_EMAIL
                    case .wrongPassword:
                        errorMessage = MESSAGE_WRONG_PASSWORD
                    default:
                        errorMessage = MESSAGE_LOGIN_ERROR
                    }
                }
            } else {
                // UserDefaultsにユーザー情報を保存
                UserDefaultsKey.userID.set(value: Auth.auth().currentUser!.uid)
                UserDefaultsKey.address.set(value: mail)
                UserDefaultsKey.password.set(value: password)
                UserDefaultsKey.useFirebase.set(value: true)
                
                // Realmデータを全削除
                let realmManager = RealmManager()
                realmManager.deleteAllRealmData()
            }
        }
        return errorMessage
    }
    
    /// ログアウト処理
    /// - Returns: 結果(true: 成功、false: 失敗)
    func logout() -> Bool {
        var result = true
        do {
            try Auth.auth().signOut()
            actionAfterLogout()
        } catch _ as NSError {
            result = false
        }
        return result
    }
    
    /// ログアウト時の共通処理
    private func actionAfterLogout() {
        // Realmデータを全削除
        let realmManager = RealmManager()
        realmManager.deleteAllRealmData()
        
        // UserDefaultsのユーザー情報を削除&新規作成
        UserDefaultsKey.userID.remove()
        UserDefaultsKey.address.remove()
        UserDefaultsKey.password.remove()
        UserDefaultsKey.userID.set(value: NSUUID().uuidString)
        UserDefaultsKey.useFirebase.set(value: false)
    }
    
    
    func sendPasswordReset(mail: String) -> Bool {
        var result = true
        Auth.auth().sendPasswordReset(withEmail: mail) { (error) in
            if error != nil {
                result = false
            }
        }
        return result
    }
    
    
}
