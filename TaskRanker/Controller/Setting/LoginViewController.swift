//
//  LoginViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit
//import PKHUD
//import Firebase

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
    private var isLogin: Bool = false
    var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // ログイン状態の判定
//        if let _ = UserDefaults.standard.object(forKey: "address") as? String,
//           let _ = UserDefaults.standard.object(forKey: "password") as? String
//        {
//            isLogin = true
//        }
        initView()
    }
    
    ///画面初期化
    private func initView() {
        initTextField(textField: loginTextField, placeholder: TITLE_MAIL_ADDRESS)
        initTextField(textField: passwordTextField, placeholder: TITLE_PASSWORD)
        if isLogin {
            detailLabel.text = TITLE_ALREADY_LOGIN
            loginButton.backgroundColor = UIColor.systemRed
            loginButton.setTitle(TITLE_LOGOUT, for: .normal)
            if let address = UserDefaults.standard.object(forKey: "address") as? String {
                loginTextField.text = address
            }
            if let password = UserDefaults.standard.object(forKey: "password") as? String {
                passwordTextField.text = password
            }
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
    }
    
    /// パスワード変更ボタン
    @IBAction func tapPasswordChangeButton(_ sender: Any) {
    }
    
    /// アカウント作成ボタン
    @IBAction func tapCreateAccountButton(_ sender: Any) {
    }
    
    /// アカウント削除ボタン
    @IBAction func tapDeleteAccountButton(_ sender: Any) {
    }
    
    /// キャンセルボタン
    @IBAction func tapCancelButton(_ sender: Any) {
        delegate?.loginVCCancelDidTap(self)
    }
    
}
