//
//  FilterViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    /// モーダルを閉じる
    func filterVCDismiss(_ viewController: UIViewController)
}

class FilterViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: FilterViewControllerDelegate?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
    
    /// NavigationController初期化
    private func initNavigation() {
        self.title = TITLE_FILTER
        
        // 閉じるボタン
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(tapCloseButton(_:)))
        
        // クリアボタン
        let clearButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(tapClearButton(_:)))
        
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [clearButton]
    }
    
    // MARK: - Action
    
    /// 閉じる
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.filterVCDismiss(self)
    }
    
    /// クリア
    @objc func tapClearButton(_ sender: UIBarButtonItem) {
        
    }

}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// TableView初期化
    private func initTableView() {
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Color.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = Color.allCases[indexPath.row].title
        cell.accessoryType = .checkmark
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
