//
//  Util.swift
//  TIM venda cantada
//
//  Created by Joe on 09/04/2018.
//  Copyright © 2018 Joel Sene. All rights reserved.
//

import UIKit
import SystemConfiguration

class Util  {
    static func getVisibleViewController(rootViewController: UIViewController?) -> UIViewController?
    {
        var currentViewController = rootViewController
        
        if currentViewController == nil {
            currentViewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if currentViewController?.presentedViewController == nil {
            return currentViewController
        }
        
        if let presented = currentViewController?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(rootViewController: presented)
        }
        return nil
    }
}
