//
//  UIViewController+Alert.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

public extension UIViewController {
    
    /// アラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - actions: [okAction、cancelAction]等
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    /// OKアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    func showOKAlert(title: String, message: String) {
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        showAlert(title: title, message: message, actions: [OKAction])
    }
    
    /// OK,Cancelアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - OKAction: OKタップ時のアクション
    func showOKCancelAlert(title: String, message: String, OKAction: @escaping () -> ()) {
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in OKAction()})
        let cancelAction = UIAlertAction(title: TITLE_CANCEL, style: UIAlertAction.Style.default, handler: nil)
        showAlert(title: title, message: message, actions: [cancelAction, OKAction])
    }
    
    /// OKアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - OKAction: OKタップ時のアクション
    func showOKAlert(title: String, message: String, OKAction: @escaping () -> ()) {
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction) in OKAction()})
        showAlert(title: title, message: message, actions: [OKAction])
    }
    
    /// エラーアラートを表示
    /// - Parameter message: メッセージ
    func showErrorAlert(message: String) {
        showOKAlert(title: TITLE_ERROR, message: message)
    }
    
    /// 削除アラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - OKAction: OKタップ時のアクション
    func showDeleteAlert(title: String, message: String, OKAction: @escaping () -> ()) {
        let OKAction = UIAlertAction(title: TITLE_DELETE,
                                     style: UIAlertAction.Style.destructive, handler: {(action: UIAlertAction) in OKAction()})
        let cancelAction = UIAlertAction(title: TITLE_CANCEL,
                                         style: UIAlertAction.Style.cancel, handler: nil)
        showAlert(title: title, message: message, actions: [OKAction, cancelAction])
    }
    
    /// アクションシートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - actions: [UIAlertAction]
    ///   - frame: フレーム(iPadの場合のみ必要)
    func showActionSheet(title: String, message: String, actions: [UIAlertAction], frame: CGRect?) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { actionSheet.addAction($0) }
        actionSheet.addAction(UIAlertAction(title: TITLE_CANCEL, style: .cancel, handler: nil))
        if isiPad() {
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = frame!
        }
        present(actionSheet, animated: true)
    }
    
    /// テキストエリア付きアラートを表示
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - actions: [okAction、cancelAction]等
    func showTextAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    /// 利用規約アラートを表示
    /// - Parameter completion: 完了処理
    func showAgreementAlert(_ completion: @escaping () -> ()) {
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
            self.showAgreementAlert({
                completion()
            })
        }
        showAlert(title: "利用規約の更新", message: "本アプリの利用規約とプライバシーポリシーに同意します。", actions: [agreeAction, termsAction])
    }

}

