//
//  SettingViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit
import MessageUI

protocol SettingViewControllerDelegate: AnyObject {
    /// モーダルを閉じる
    func settingVCDismiss(_ viewController: UIViewController)
    /// データの引継ぎタップ時の処理
    func settingVCDataTransferDidTap(_ viewController: UIViewController)
    /// キャラクター設定タップ時の処理
    func settingVCCharacterDidTap(_ viewController: UIViewController)
    /// アプリの使い方タップ時の処理
    func settingVCTutorialDidTap(_ viewController: UIViewController)
}

class SettingViewController: UIViewController {

    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    private var settingViewModel = SettingViewModel()
    var delegate: SettingViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        }
    }
    
    // MARK: - Viewer
    
    /// NavigationController初期化
    private func initNavigation() {
        self.title = TITLE_SETTING
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(tapCloseButton(_:)))
        navigationItem.leftBarButtonItems = [closeButton]
    }
    
    // MARK: - Action
    
    /// 閉じる
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.settingVCDismiss(self)
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    /// TableView初期化
    private func initTableView() {
        tableView.dataSource = settingViewModel
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch settingViewModel.didSelectRowAt(indexPath: indexPath) {
        case .dataTransfer:
            delegate?.settingVCDataTransferDidTap(self)
            break
        case .character:
            delegate?.settingVCCharacterDidTap(self)
            break
        case .help:
            delegate?.settingVCTutorialDidTap(self)
            break
        case .inquiry:
            tableView.deselectRow(at: indexPath, animated: true)
            startMailer()
            break
        }
    }
    
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    /// メーラーを起動
    private func startMailer() {
        if MFMailComposeViewController.canSendMail() == false {
            let alert = Alert.Error(message: MESSAGE_MAILER_ERROR)
            present(alert, animated: true)
            return
        }
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients(["TaskRanker開発者<it6210ge@gmail.com>"])
        mailViewController.setSubject(TITLE_MAIL_SUBJECT)
        mailViewController.setMessageBody(TITLE_MAIL_MESSAGE, isHTML: false)
        self.present(mailViewController, animated: true, completion: nil)
    }
    
    /// メーラーを終了
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            let alert = Alert.OK(title: TITLE_SUCCESS, message: MESSAGE_MAIL_SEND_SUCCESS)
            present(alert, animated: true)
            break
        case .failed:
            let alert = Alert.Error(message: MESSAGE_MAIL_SEND_FAILED)
            present(alert, animated: true)
            break
        default:
            break
        }
    }
    
}
