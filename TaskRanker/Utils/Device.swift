//
//  Device.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/03/04.
//

import UIKit
import Reachability

class Device {
    
    /// iPad判定
    /// - Returns: true：iPad、false：iPhone
    static func isiPad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        } else {
            return false
        }
    }
    
    /// インターネット接続判定
    /// - Returns: true：オンライン、false：オフライン
    static func isOnline() -> Bool {
        let reachability = try! Reachability()
        switch reachability.connection {
        case .none:         return false
        case .unavailable:  return false
        case .wifi:         return true
        case .cellular:     return true
        }
    }
    
}
