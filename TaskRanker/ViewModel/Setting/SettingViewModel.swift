//
//  SettingViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/16.
//

import UIKit

class SettingViewModel: NSObject {
    
    // MARK: - Variable
    
    private let sectionItem = [[Cell.dataTransfer], [Cell.character], [Cell.help, Cell.inquiry]]
    
    private enum Section: Int, CaseIterable {
        
        case data
        case character
        case help
        
        var title: String {
            switch self {
            case .data:      return TITLE_DATA
            case .character: return TITLE_CHARACTER
            case .help:      return TITLE_HELP
            }
        }
        
    }
    
    enum Cell: Int, CaseIterable {
        
        case dataTransfer
        case character
        case help
        case inquiry
        
        var title: String {
            switch self {
            case .dataTransfer: return TITLE_DATA_TRANSFER
            case .character:    return TITLE_CHARACTER_SETTING
            case .help:         return TITLE_HOW_TO_USE_THIS_APP
            case .inquiry:      return TITLE_INQUIRY
            }
        }
        var image: UIImage {
            switch self {
            case .dataTransfer: return UIImage(systemName: "icloud.and.arrow.up")!
            case .character:    return UIImage(systemName: "face.smiling")!
            case .help:         return UIImage(systemName: "questionmark.circle")!
            case .inquiry:      return UIImage(systemName: "envelope")!
            }
        }
        
    }
    
    /// 選択されたセルを返却
    /// - Parameter indexPath: IndexPath
    /// - Returns: セル
    func didSelectRowAt(indexPath: IndexPath) -> Cell {
        return sectionItem[indexPath.section][indexPath.row]
    }
    
}

extension SettingViewModel: UITableViewDataSource {
    
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
        return sectionItem[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = sectionItem[indexPath.section][indexPath.row].image
        cell.textLabel?.text  = sectionItem[indexPath.section][indexPath.row].title
        if indexPath.section == Section.character.rawValue {
            cell.detailTextLabel?.text = CharacterType.allCases[UserDefaultsKey.character.integer()].name
        }
        return cell
    }
    
}
