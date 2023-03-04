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
    /// アプリの使い方タップ時の処理
    func settingVCTutorialDidTap(_ viewController: UIViewController)
}

class SettingViewController: UIViewController {

    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    private var cells: [[Cell]] = [[Cell.dataTransfer], [Cell.help, Cell.inquiry]]
    var delegate: SettingViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
    
    // MARK: - Viewer
    
    /// NavigationController初期化
    private func initNavigation() {
        self.title = TITLE_SETTING
        
        // 閉じるボタン
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(tapCloseButton(_:)))
        
        navigationItem.leftBarButtonItems = [closeButton]
    }
    
    // MARK: - Action
    
    /// 閉じる
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.settingVCDismiss(self)
    }
    
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    private enum Section: Int, CaseIterable {
        case data
        case help
        var title: String {
            switch self {
            case .data: return TITLE_DATA
            case .help: return TITLE_HELP
            }
        }
    }
    
    private enum Cell: Int, CaseIterable {
        case dataTransfer
        case help
        case inquiry
        var title: String {
            switch self {
            case .dataTransfer: return TITLE_DATA_TRANSFER
            case .help: return TITLE_HOW_TO_USE_THIS_APP
            case .inquiry: return TITLE_INQUIRY
            }
        }
        var image: UIImage {
            switch self {
            case .dataTransfer: return UIImage(systemName: "icloud.and.arrow.up")!
            case .help: return UIImage(systemName: "questionmark.circle")!
            case .inquiry: return UIImage(systemName: "envelope")!
            }
        }
    }
    
    /// TableView初期化
    private func initTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.imageView?.image = cells[indexPath.section][indexPath.row].image
        cell.textLabel?.text = cells[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cells[indexPath.section][indexPath.row] {
        case .dataTransfer:
            delegate?.settingVCDataTransferDidTap(self)
            break
        case .help:
            delegate?.settingVCTutorialDidTap(self)
            break
        case .inquiry:
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
