//
//  Definition+Network.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2023/02/26.
//

import Reachability

final class Network {

    static func isOnline() -> Bool {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            return false
        } else {
            return true
        }
    }

}
