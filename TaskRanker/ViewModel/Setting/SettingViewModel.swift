//
//  SettingViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import UIKit

class SettingViewModel {
    
    // MARK: - Variable
    
    private let sectionItem = [[Cell.dataTransfer], [Cell.help, Cell.inquiry]]
    
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
    
    enum Cell: Int, CaseIterable {
        
        case dataTransfer
        case help
        case inquiry
        
        var title: String {
            switch self {
            case .dataTransfer: return TITLE_DATA_TRANSFER
            case .help:         return TITLE_HOW_TO_USE_THIS_APP
            case .inquiry:      return TITLE_INQUIRY
            }
        }
        var image: UIImage {
            switch self {
            case .dataTransfer: return UIImage(systemName: "icloud.and.arrow.up")!
            case .help:         return UIImage(systemName: "questionmark.circle")!
            case .inquiry:      return UIImage(systemName: "envelope")!
            }
        }
        
    }
    
    // MARK: - TableView DataSource
    
    /// セクション数を返却
    /// - Returns: セクション数
    func numberOfSections() -> Int {
        return Section.allCases.count
    }
    
    /// セクションのタイトルを返却
    /// - Parameter section: セクションのインデックス
    /// - Returns: タイトル
    func titleForHeaderInSection(section: Int) -> String {
        return Section.allCases[section].title
    }
    
    /// セクション内のセル数を返却
    /// - Parameter section: セクションのインデックス
    /// - Returns: セル数
    func numberOfRowsInSection(section: Int) -> Int {
        return sectionItem[section].count
    }
    
    /// セルを返却
    /// - Parameter indexPath: IndexPath
    /// - Returns: セル
    func cellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.imageView?.image = sectionItem[indexPath.section][indexPath.row].image
        cell.textLabel?.text  = sectionItem[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    /// 選択されたセルを返却
    /// - Parameter indexPath: IndexPath
    /// - Returns: セル
    func didSelectRowAt(indexPath: IndexPath) -> Cell {
        return sectionItem[indexPath.section][indexPath.row]
    }
    
}
