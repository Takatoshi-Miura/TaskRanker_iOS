//
//  Coordinator.swift
//  TaskRanker
//
//  Created by Takatoshi Miura on 2022/09/10.
//

import UIKit

protocol Coordinator: AnyObject {
    
    func startFlow(in window: UIWindow?)
    
    func startFlow(in navigationController: UINavigationController)
    
    func startFlow(in viewController: UIViewController)
    
}
