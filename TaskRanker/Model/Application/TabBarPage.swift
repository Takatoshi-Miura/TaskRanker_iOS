//
//  TabBarPage.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/12/14.
//

import UIKit

enum TabBarPage: Int {
    
    case list
    case map
    
    var title: String {
        switch self {
        case .list: return TITLE_LIST
        case .map:  return TITLE_MAP
        }
    }
    
    var order: Int {
        switch self {
        case .list: return 0
        case .map:  return 1
        }
    }
    
    var image: UIImage {
        switch self {
        case .list: return UIImage(systemName: "checklist")!
        case .map:  return UIImage(systemName: "square.split.2x2.fill")!
        }
    }
    
}
