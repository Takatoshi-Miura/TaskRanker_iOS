//
//  LoginViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import Firebase

class LoginViewModel {
    
    /// ログイン状態を取得
    /// - Returns: ログイン状態
    func isLogin() -> Bool {
        return UserDefaultsKey.useFirebase.bool()
    }
    
    /// ログイン処理
    /// - Parameters:
    ///   - mail: メールアドレス
    ///   - password: パスワード
    ///   - complete: 完了処理
    func login(mail: String, password: String, complete: @escaping (String?) -> ()) {
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
            complete(errorMessage)
        }
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
    
    /// パスワードリセットメール送信
    /// - Parameters:
    ///   - mail: メールアドレス
    ///   - complete: 完了処理
    func sendPasswordReset(mail: String, complete: @escaping (String?) -> ()) {
        var errorMessage: String?
        Auth.auth().sendPasswordReset(withEmail: mail) { (error) in
            if error != nil {
                errorMessage = MESSAGE_MAIL_SEND_ERROR
            }
            complete(errorMessage)
        }
    }
    
    /// アカウント作成処理
    /// - Parameters:
    ///   - mail: メールアドレス
    ///   - password: パスワード
    ///   - complete: 完了処理
    func createAccount(mail: String, password: String, complete: @escaping (String?) -> ()) {
        var errorMessage: String?
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if error != nil {
                if let errorCode = AuthErrorCode.Code(rawValue: error!._code) {
                    switch errorCode {
                    case .invalidEmail:
                        errorMessage = MESSAGE_INVALID_EMAIL
                    case .emailAlreadyInUse:
                        errorMessage = MESSAGE_EMAIL_ALREADY_INUSE
                    case .weakPassword:
                        errorMessage = MESSAGE_WEAK_PASSWORD
                    default:
                        errorMessage = MESSAGE_CREATE_ACCOUNT_ERROR
                    }
                }
                complete(errorMessage)
            } else {
                // FirebaseのユーザーIDとログイン情報を保存
                UserDefaultsKey.userID.set(value: Auth.auth().currentUser!.uid)
                UserDefaultsKey.address.set(value: mail)
                UserDefaultsKey.password.set(value: password)
                UserDefaultsKey.useFirebase.set(value: true)
                
                // RealmデータのuserIDを新しいIDに更新
                let realmManager = RealmManager()
                realmManager.updateAllRealmUserID(userID: Auth.auth().currentUser!.uid)
                
                // Firebaseと同期
                let taskManager = TaskManager()
                taskManager.syncDatabase(completion: {
                    complete(errorMessage)
                })
            }
        }
    }
    
    /// アカウント削除処理
    /// - Parameter complete: 完了処理
    func deleteAccount(complete: @escaping (String?) -> ()) {
        var errorMessage: String?
        Auth.auth().currentUser?.delete { (error) in
            if error != nil {
                errorMessage = MESSAGE_DELETE_ACCOUNT_ERROR
            } else {
                self.actionAfterLogout()
            }
            complete(errorMessage)
        }
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
    
}
