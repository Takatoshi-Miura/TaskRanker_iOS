//
//  RandomMessage.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/04/07.
//

import UIKit

enum RandomMessage: Int, CaseIterable {
    
    case quickly    // 期限日が近いタスクを通知
    case expired    // 期限切れタスクを通知
    case praise     // ユーザを褒める
    case advice     // アドバイス
    case color      // カラーの使い方
    case change     // キャラクター切替
    
    var image: UIImage {
        switch self {
        case .quickly:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return UIImage(named: "chipoyo_okaeri")!
            case .sub:      return UIImage(named: "tapoyo_okaeri")!
            case .chipoyo:  return UIImage(named: "chipoyo_addTask")!
            case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
            case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
            case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
            case .tencho:   return UIImage(named: "tencho_okaeri")!
            }
        case .expired:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return UIImage(named: "chipoyo_okaeri")!
            case .sub:      return UIImage(named: "tapoyo_addTask")!
            case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
            case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
            case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
            case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
            case .tencho:   return UIImage(named: "tencho_okaeri")!
            }
        case .praise:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return UIImage(named: "chipoyo_okaeri")!
            case .sub:      return UIImage(named: "tapoyo_okaeri")!
            case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
            case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
            case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
            case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
            case .tencho:   return UIImage(named: "tencho_okaeri")!
            }
        case .advice:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return UIImage(named: "chipoyo_okaeri")!
            case .sub:      return UIImage(named: "tapoyo_okaeri")!
            case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
            case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
            case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
            case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
            case .tencho:   return UIImage(named: "tencho_okaeri")!
            }
        case .color:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return UIImage(named: "chipoyo_okaeri")!
            case .sub:      return UIImage(named: "tapoyo_okaeri")!
            case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
            case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
            case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
            case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
            case .tencho:   return UIImage(named: "tencho_okaeri")!
            }
        case .change:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return UIImage(named: "chipoyo_okaeri")!
            case .sub:      return UIImage(named: "tapoyo_okaeri")!
            case .chipoyo:  return UIImage(named: "chipoyo_okaeri")!
            case .tapoyo:   return UIImage(named: "tapoyo_okaeri")!
            case .togepoyo: return UIImage(named: "togepoyo_okaeri")!
            case .warupoyo: return UIImage(named: "warupoyo_okaeri")!
            case .tencho:   return UIImage(named: "tencho_okaeri")!
            }
        }
    }
    
    var message: String {
        switch self {
        case .quickly:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return "メインキャラクター"
            case .sub:      return "サブキャラクター"
            case .chipoyo:  return "\nがもうすぐ きげんび！やだやだ！"
            case .tapoyo:   return "\nがもうすぐ きげんびだ！ゆうせんして とりくもう！"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "\nがもうすぐ きげんびじゃないか...もうあしたから こなくていいよ"
            }
        case .expired:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return "メインキャラクター"
            case .sub:      return "サブキャラクター"
            case .chipoyo:  return "\nが きげんびすぎちゃった...めんどくちゃいから やらないもんね。"
            case .tapoyo:   return "\nが きげんびすぎちゃってるよ...ちいぽよ〜(泣)"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "\nが きげんびすぎてるじゃないか...もうあしたから こなくていいよ"
            }
        case .praise:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return "メインキャラクター"
            case .sub:      return "サブキャラクター"
            case .chipoyo:  return "やることかくにんしてる！えらい！"
            case .tapoyo:   return "いつもがんばってるね！\nよこからえらい！"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "なにもしてないじゃないか...もうあしたから こなくていいよ"
            }
        case .advice:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return "メインキャラクター"
            case .sub:      return "サブキャラクター"
            case .chipoyo:  return "たあぽよが ひとつずつかたづけてれば だいじょうぶっていってた！"
            case .tapoyo:   return "ひとつずつかたづけてれば だいじょうぶ！がんばって！"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "はやくしないと ししゃもがこげるぞ"
            }
        case .color:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return "メインキャラクター"
            case .sub:      return "サブキャラクター"
            case .chipoyo:  return "あかは かいもの！あおは おうたクラブ！きいろは なににしようかな？"
            case .tapoyo:   return "あかは きのこハウス、あおは おべんきょうのタスク。きいろは なににしようかな？"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "あかは しいれ、あおは しこみ、きいろは...きいてるじゃないか...もうあしたから こなくていいよ"
            }
        case .change:
            switch Character.allCases[UserDefaultsKey.character.integer()] {
            case .main:     return "メインキャラクター"
            case .sub:      return "サブキャラクター"
            case .chipoyo:  return "「設定」で キャラクターをかえられるって。ちいぽよのほうが かわいいもんね。"
            case .tapoyo:   return "「設定」で キャラクターをかえられるよ。ちいぽよにしようかな。"
            case .togepoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .warupoyo: return "やーい！うんちいぽよ！うんちいぽよ！"
            case .tencho:   return "「設定」で てんちょうをかえる？...もうあしたから こなくていいよ"
            }
        }
    }
    
}

