//
//  Character.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/21.
//

import UIKit

enum Character: Int, CaseIterable {
    
    case okaeri
    case addTask
    case update
    case complete
    
    var image: UIImage {
        switch self {
        case .okaeri:   return UIImage(named: "001_okaeri")!
        case .addTask:  return UIImage(named: "002_addTask")!
        case .update:   return UIImage(named: "003_update")!
        case .complete: return UIImage(named: "004_complete")!
        }
    }
    
    var message: String {
        switch self {
        case .okaeri:   return "ちいぽよだよ\nすまほのなかに あそびに きちゃったもんね"
        case .addTask:  return "やだやだ！めんどくちゃい！"
        case .update:   return "やることを みなおした！\nえらい！"
        case .complete: return "やることできた！\nえらい！"
        }
    }
    
}
