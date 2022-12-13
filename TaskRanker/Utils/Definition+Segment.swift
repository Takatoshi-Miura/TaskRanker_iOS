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
    
    var typeTitle: String {
        switch self {
        case .A: return "A"
        case .B: return "B"
        case .C: return "C"
        case .D: return "D"
        }
    }
    
    var naviTitle: String {
        switch self {
        case .A: return "重要度(↑),緊急度(↑)"
        case .B: return "重要度(↑),緊急度(↓)"
        case .C: return "重要度(↓),緊急度(↑)"
        case .D: return "重要度(↓),緊急度(↓)"
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
