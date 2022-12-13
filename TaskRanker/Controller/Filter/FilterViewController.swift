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
    private var checkArray: [Bool]
    var delegate: FilterViewControllerDelegate?

    // MARK: - Initializer
    
    /// イニシャライザ
    /// - Parameter task: nilの場合は新規作成
    init(filterArray: [Bool]?) {
        if let filterArray = filterArray {
            checkArray = filterArray
        } else {
            checkArray = Array(repeating: true, count: TaskColor.allCases.count)
        }
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
        delegate?.filterVCDismiss(self, filterArray: checkArray)
    }
    
    /// NavigationController初期化
    private func initNavigation() {
        self.title = TITLE_FILTER
        
        // 閉じるボタン
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(tapCloseButton(_:)))
        
        // クリアボタン
        let clearButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                          target: self,
                                          action: #selector(tapClearButton(_:)))
        
        navigationItem.leftBarButtonItems = [closeButton]
        navigationItem.rightBarButtonItems = [clearButton]
    }
    
    // MARK: - Action
    
    /// 閉じる
    @objc func tapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.filterVCDismiss(self, filterArray: checkArray)
    }
    
    /// クリア
    @objc func tapClearButton(_ sender: UIBarButtonItem) {
        checkArray = Array(repeating: true, count: TaskColor.allCases.count)
        tableView.reloadData()
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
        return TaskColor.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = TaskColor.allCases[indexPath.row].title
        cell.accessoryType = checkArray[indexPath.row] ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkArray[indexPath.row].toggle()
        // 最低1つはチェックが必要
        if checkArray.firstIndex(of: true) == nil {
            checkArray[indexPath.row].toggle()
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}
