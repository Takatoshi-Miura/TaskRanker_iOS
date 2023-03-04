//
//  Alert.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

class Alert {
    
    /// アラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - actions: [okAction、cancelAction]等
    private static func showAlert(title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        return alert
    }
    
    /// OKアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    static func OK(title: String, message: String) -> UIAlertController {
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        return showAlert(title: title, message: message, actions: [OKAction])
    }
    
    /// OKアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - OKAction: OKタップ時のアクション
    static func OK(title: String, message: String, OKAction: @escaping () -> ()) -> UIAlertController {
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in OKAction()})
        return showAlert(title: title, message: message, actions: [OKAction])
    }
    
    /// OK,Cancelアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - OKAction: OKタップ時のアクション
    static func OKCancel(title: String, message: String, OKAction: @escaping () -> ()) -> UIAlertController {
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in OKAction()})
        let cancelAction = UIAlertAction(title: TITLE_CANCEL, style: UIAlertAction.Style.default, handler: nil)
        return showAlert(title: title, message: message, actions: [cancelAction, OKAction])
    }
    
    /// エラーアラートを表示
    /// - Parameter message: メッセージ
    static func Error(message: String) -> UIAlertController {
        return OK(title: TITLE_ERROR, message: message)
    }
    
    /// 削除アラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - OKAction: OKタップ時のアクション
    static func Delete(title: String, message: String, OKAction: @escaping () -> ()) -> UIAlertController {
        let OKAction = UIAlertAction(title: TITLE_DELETE,
                                     style: UIAlertAction.Style.destructive, handler: {(action: UIAlertAction) in OKAction()})
        let cancelAction = UIAlertAction(title: TITLE_CANCEL,
                                         style: UIAlertAction.Style.cancel, handler: nil)
        return showAlert(title: title, message: message, actions: [OKAction, cancelAction])
    }
    
    /// テキストエリア付きアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - actions: [okAction、cancelAction]等
    static func TextArea(title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        actions.forEach { alert.addAction($0) }
        return alert
    }
    
    /// 利用規約アラートを表示
    /// - Parameter completion: 完了処理
    static func Agreement(_ completion: @escaping () -> ()) -> UIAlertController {
        // 同意ボタン
        let agreeAction = UIAlertAction(title:"同意する",style:UIAlertAction.Style.default){(action:UIAlertAction)in
            completion()
        }
        // 利用規約ボタン
        let termsAction = UIAlertAction(title:"利用規約を読む",style:UIAlertAction.Style.default){(action:UIAlertAction)in
            // 規約画面に遷移
            let url = URL(string: "https://sportnote-b2c92.firebaseapp.com/")
            UIApplication.shared.open(url!)
            // アラートが消えるため再度表示
            self.Agreement({
                completion()
            })
        }
        return showAlert(title: "利用規約の更新", message: "本アプリの利用規約とプライバシーポリシーに同意します。", actions: [agreeAction, termsAction])
    }
    
}
