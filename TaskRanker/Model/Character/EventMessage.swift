//
//  EventMessage.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/25.
//

import UIKit

enum EventMessage: Int, CaseIterable {
    
    case okaeri     // ログイン時
    case addTask    // Task追加時
    case update     // Task更新時
    case complete   // Task完了時
    
    var image: UIImage {
        switch self {
        case .okaeri:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
            case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
            case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
            case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
            case .tencho:   return UIImage(named: "tencho_okaeri")!
            }
        case .addTask:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return UIImage(named: "chipoyo_addTask")!
            case .tapoyo:   return UIImage(named: "tapoyo_addTask")!
            case .togepoyo: return UIImage(named: "togepoyo_addTask")!
            case .warupoyo: return UIImage(named: "warupoyo_addTask")!
            case .tencho:   return UIImage(named: "tencho_addTask")!
            }
        case .update:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return UIImage(named: "chipoyo_update")!
            case .tapoyo:   return UIImage(named: "tapoyo_update")!
            case .togepoyo: return UIImage(named: "togepoyo_update")!
            case .warupoyo: return UIImage(named: "warupoyo_update")!
            case .tencho:   return UIImage(named: "tencho_update")!
            }
        case .complete:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return UIImage(named: "chipoyo_complete")!
            case .tapoyo:   return UIImage(named: "tapoyo_complete")!
            case .togepoyo: return UIImage(named: "togepoyo_complete")!
            case .warupoyo: return UIImage(named: "warupoyo_complete")!
            case .tencho:   return UIImage(named: "tencho_complete")!
            }
        }
    }
    
    var message: String {
        switch self {
        case .okaeri:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return "ちいぽよだよ\nすまほのなかに あそびに きちゃったもんね"
            case .tapoyo:   return "たあぽよだよ\nちいぽよが きてたみたいだけど どこかなぁ"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "おそいじゃないか...もうあしたから こなくていいよ。"
            }
        case .addTask:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return "やだやだ！めんどくちゃい！"
            case .tapoyo:   return "やることふえちゃった！ちいぽよ〜泣"
            case .togepoyo: return "わー！"
            case .warupoyo: return "わー！"
            case .tencho:   return "しごと ふやしおって...もうあしたから こなくていいよ。"
            }
        case .update:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return "やることを みなおした！\nえらい！"
            case .tapoyo:   return "やることを みなおした！\nよこからえらい！"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "おわってないじゃないか...もうあしたから こなくていいよ。"
            }
        case .complete:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .chipoyo:  return "やることできた！\nえらい！"
            case .tapoyo:   return "やることできた！\nえらい！"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "やっとおわったか...そのちょうしで たのむぞ。"
            }
        }
    }
    
}
