//
//  Character.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/21.
//

import UIKit

enum Character: Int, CaseIterable {
    
    case chipoyo
    case tapoyo
    case togepoyo
    case warupoyo
    case tencho
    
    /// 設定用画像
    var image: UIImage {
        switch self {
        case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
        case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
        case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
        case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
        case .tencho:   return UIImage(named: "tencho_okaeri")!
        }
    }
    
    /// キャラクター名
    var name: String {
        switch self {
        case .chipoyo:  return "ちいぽよ"
        case .tapoyo:   return "たあぽよ"
        case .togepoyo: return "とげぽよ"
        case .warupoyo: return "わるぽよ"
        case .tencho:   return "てんちょう"
        }
    }
    
    /// ひとこと
    var message: String {
        switch self {
        case .chipoyo:  return "ちいぽよだよ。ちいぽよのほうが かわいいもんね。"
        case .tapoyo:   return "たあぽよだよ。いっしょに がんばろうね！"
        case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
        case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
        case .tencho:   return "もうあしたから こなくていいよ。"
        }
    }
    
    /// キャラクター説明
    var description: String {
        switch self {
        case .chipoyo:  return "たあぽよのことが大好きなやさしいぽよ。ちょっと面倒くさがり。"
        case .tapoyo:   return "ちいぽよのことが大好きなやさしいぽよ。気ままな性格。"
        case .togepoyo: return "あたまにトゲがついているいじわるなぽよ。いたずら好き。"
        case .warupoyo: return "ふとっちょでいじわるなぽよ。とげぽよとなかよし。"
        case .tencho:   return "ししゃもやさんの店長。仕事ができないぽよはすぐクビにする。"
        }
    }
    
}

enum CharacterMessageType: Int, CaseIterable {
    
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
