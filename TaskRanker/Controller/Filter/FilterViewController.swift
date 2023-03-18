//
//  FilterViewController.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/10/11.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    /// モーダルを閉じる
    func filterVCDismiss(_ viewController: UIViewController, filterArray: [Bool])
}

class FilterViewController: UIViewController {
    
    // MARK: - UI,Variable
    
    @IBOutlet weak var tableView: UITableView!
    private var filterViewModel: FilterViewModel
    var delegate: FilterViewControllerDelegate?

    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter filterArray: nilの場合は新規作成
    init(filterArray: [Bool]?) {
        filterViewModel = FilterViewModel(filterArray: filterArray)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.filterVCDismiss(self, filterArray: filterViewModel.filterArray)
    }
    
    // MARK: - Viewer
    
    /// NavigationController初期化
    private func initNavigation() {
        self.title = TITLE_FILTER
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(tapCloseButton(_:)))
        let clearButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(tapClearButton(_:)))
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [clearButton]
    }
    
    // MARK: - Action
    
    /// 閉じる
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.filterVCDismiss(self, filterArray: filterViewModel.filterArray)
    }
    
    /// クリア
    @objc func tapClearButton(_ sender: UIBarButtonItem) {
        filterViewModel.clearArray()
        tableView.reloadData()
    }

}

extension FilterViewController: UITableViewDelegate {
    
    /// TableView初期化
    private func initTableView() {
        tableView.dataSource = filterViewModel
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterViewModel.toggleValue(indexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}
