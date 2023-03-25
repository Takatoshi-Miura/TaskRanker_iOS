//
//  CharacterViewModel.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/25.
//

import UIKit

class CharacterViewModel {
    
    private var character: Character
    
    // MARK: - Initializer
    
    init(character: Character) {
        self.character = character
    }
    
    // MARK: - Method
    
    /// キャラクター名を取得
    /// - Returns: キャラクター名
    func getCharacterName() -> String {
        return character.name
    }
    
    /// キャラクターの説明を取得
    /// - Returns: 説明
    func getDescription() -> String {
        return character.description
    }
    
    /// キャラクターの画像を取得
    /// - Returns: 画像
    func getImage() -> UIImage {
        return character.image
    }
    
    /// キャラクターのひとことを取得
    /// - Returns: ひとこと
    func getMessage() -> String {
        return character.message
    }
    
    /// キャラクター設定を保存
    func saveCharacter() {
        UserDefaultsKey.character.set(value: character.rawValue)
    }
    
}
