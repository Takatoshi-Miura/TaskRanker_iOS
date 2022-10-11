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
        
    }
    
    // MARK: - Action
    
    

}
