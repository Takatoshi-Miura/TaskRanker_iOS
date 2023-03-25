//
//  LoginViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit
import PKHUD
import Firebase

protocol LoginViewControllerDelegate: AnyObject {
    // ログイン時の処理
    func loginVCUserDidLogin(_ viewController: UIViewController)
    // ログイン時の処理
    func loginVCUserDidLogout(_ viewController: UIViewController)
    // キャンセルタップ時の処理
    func loginVCCancelDidTap(_ viewController: UIViewController)
}

class LoginViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordChangeButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private var loginViewModel = LoginViewModel()
    var delegate: LoginViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Viewer
    
    ///画面初期化
    private func initView() {
        initTextField(textField: loginTextField, placeholder: TITLE_MAIL_ADDRESS)
        initTextField(textField: passwordTextField, placeholder: TITLE_PASSWORD)
        if loginViewModel.isLogin() {
            detailLabel.text = TITLE_ALREADY_LOGIN
            loginButton.backgroundColor = UIColor.systemRed
            loginButton.setTitle(TITLE_LOGOUT, for: .normal)
            loginTextField.text = UserDefaultsKey.address.string()
            passwordTextField.text = UserDefaultsKey.password.string()
        } else {
            detailLabel.text = TITLE_LOGIN_HELP
            loginButton.backgroundColor = UIColor.systemBlue
            loginButton.setTitle(TITLE_LOGIN, for: .normal)
        }
        passwordChangeButton.setTitle(TITLE_PASSWORD_RESET, for: .normal)
        createAccountButton.setTitle(TITLE_CREATE_ACCOUNT, for: .normal)
        deleteAccountButton.setTitle(TITLE_DELETE_ACCOUNT, for: .normal)
        cancelButton.setTitle(TITLE_CANCEL, for: .normal)
    }
    
    // MARK: - Action
    
    /// ログインボタン
    @IBAction func tapLoginButton(_ sender: Any) {
        if loginViewModel.isLogin() {
            logout()
        } else {
            if loginTextField.text == "" || passwordTextField.text == "" {
                let alert = Alert.Error(message: MESSAGE_EMPTY_TEXT_ERROR)
                present(alert, animated: true)
                return
            }
            login(mail: loginTextField.text!, password: passwordTextField.text!)
        }
    }
    
    /// パスワード変更ボタン
    @IBAction func tapPasswordChangeButton(_ sender: Any) {
        if loginTextField.text == "" {
            let alert = Alert.Error(message: MESSAGE_EMPTY_TEXT_ERROR_PASSWORD_RESET)
            present(alert, animated: true)
            return
        }
        let alert = Alert.OKCancel(title: TITLE_PASSWORD_RESET, message:MESSAGE_PASSWORD_RESET, OKAction: {
            self.sendPasswordResetMail(mail: self.loginTextField.text!)
        })
        present(alert, animated: true)
    }
    
    /// アカウント作成ボタン
    @IBAction func tapCreateAccountButton(_ sender: Any) {
        if loginTextField.text == "" || passwordTextField.text == "" {
            let alert = Alert.Error(message: MESSAGE_EMPTY_TEXT_ERROR)
            present(alert, animated: true)
            return
        }
        let alert = Alert.OKCancel(title: TITLE_CREATE_ACCOUNT, message: MESSAGE_CREATE_ACCOUNT, OKAction: {
            self.createAccount(mail: self.loginTextField.text!, password: self.passwordTextField.text!)
        })
        present(alert, animated: true)
    }
    
    /// アカウント削除ボタン
    @IBAction func tapDeleteAccountButton(_ sender: Any) {
        if !loginViewModel.isLogin() {
            let alert = Alert.Error(message: MESSAGE_PLEASE_LOGIN)
            present(alert, animated: true)
            return
        }
        let alert = Alert.OKCancel(title: TITLE_DELETE_ACCOUNT, message: MESSAGE_DELETE_ACCOUNT, OKAction: {
            self.deleteAccount()
        })
        present(alert, animated: true)
    }
    
    /// キャンセルボタン
    @IBAction func tapCancelButton(_ sender: Any) {
        delegate?.loginVCCancelDidTap(self)
    }
    
    // MARK: - Private
    
    /// ログイン処理
    /// - Parameters:
    ///   - mail: メールアドレス
    ///   - password: パスワード
    private func login(mail: String, password: String) {
        HUD.show(.labeledProgress(title: "", subtitle: MESSAGE_DURING_LOGIN_PROCESS))
        loginViewModel.login(mail: mail, password: password, complete: { (errorMessage) in
            if let errorMessage = errorMessage {
                HUD.show(.labeledError(title: "", subtitle: errorMessage))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                    HUD.hide()
                }
            } else {
                HUD.show(.labeledSuccess(title: "", subtitle: MESSAGE_LOGIN_SUCCESSFUL))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    HUD.hide()
                    self.delegate?.loginVCUserDidLogin(self)
                }
            }
        })
    }
    
    /// ログアウト処理
    private func logout() {
        let result = loginViewModel.logout()
        if result {
            HUD.show(.labeledSuccess(title: "", subtitle: MESSAGE_LOGOUT_SUCCESSFUL))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                HUD.hide()
                self.clearTextField()
                self.delegate?.loginVCUserDidLogout(self)
            }
        } else {
            let alert = Alert.Error(message: MESSAGE_LOGOUT_ERROR)
            present(alert, animated: true)
        }
    }
    
    /// パスワードリセットメールを送信
    /// - Parameters:
    ///   - mail: メールアドレス
    private func sendPasswordResetMail(mail: String) {
        loginViewModel.sendPasswordReset(mail: mail, complete: { (errorMessage) in
            if let errorMessage = errorMessage {
                let alert = Alert.Error(message: errorMessage)
                self.present(alert, animated: true)
            } else {
                HUD.show(.labeledSuccess(title: "", subtitle: MESSAGE_MAIL_SEND_SUCCESSFUL))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    HUD.hide()
                    self.delegate?.loginVCUserDidLogin(self)
                }
            }
        })
    }
    
    /// アカウント作成処理
    /// - Parameters:
    ///   - mail: メールアドレス
    ///   - password: パスワード
    private func createAccount(mail: String, password: String) {
        HUD.show(.labeledProgress(title: "", subtitle: MESSAGE_DURING_CREATE_ACCOUNT_PROCESS))
        loginViewModel.createAccount(mail: mail, password: password, complete: { (errorMessage) in
            if let errorMessage = errorMessage {
                HUD.hide()
                let alert = Alert.Error(message: errorMessage)
                self.present(alert, animated: true)
            } else {
                HUD.show(.labeledSuccess(title: "", subtitle: MESSAGE_DATA_TRANSFER_SUCCESSFUL))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    HUD.hide()
                    self.delegate?.loginVCUserDidLogin(self)
                }
            }
        })
    }
    
    /// アカウント削除処理
    private func deleteAccount() {
        HUD.show(.labeledProgress(title: "", subtitle: MESSAGE_DURING_DELETE_ACCOUNT))
        loginViewModel.deleteAccount(complete: { (errorMessage) in
            if let errorMessage = errorMessage {
                HUD.hide()
                let alert = Alert.Error(message: MESSAGE_DELETE_ACCOUNT_ERROR)
                self.present(alert, animated: true)
            } else {
                self.clearTextField()
                HUD.show(.labeledSuccess(title: "", subtitle: MESSAGE_DELETE_ACCOUNT_SUCCESSFUL))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    HUD.hide()
                    self.delegate?.loginVCUserDidLogout(self)
                }
            }
        })
    }
    
    /// テキストフィールドをクリア
    private func clearTextField() {
        self.loginTextField.text = ""
        self.passwordTextField.text = ""
    }
    
}
