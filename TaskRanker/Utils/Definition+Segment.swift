//
//  Definition+Segment.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/11.
//

import UIKit

enum SegmentType: Int, CaseIterable {
    case A
    case B
    case C
    case D
    
    var title: String {
        switch self {
        // TODO: 多言語対応
        case .A: return "重要度(高),緊急度(高)"
        case .B: return "重要度(高),緊急度(低)"
        case .C: return "重要度(低),緊急度(高)"
        case .D: return "重要度(低),緊急度(低)"
        }
    }
    
    var importanceColor: UIColor {
        switch self {
        case .A: return UIColor.red
        case .B: return UIColor.red
        case .C: return UIColor.blue
        case .D: return UIColor.blue
        }
    }
    
    var urgencyColor: UIColor {
        switch self {
        case .A: return UIColor.red
        case .B: return UIColor.blue
        case .C: return UIColor.red
        case .D: return UIColor.blue
        }
    }
}
