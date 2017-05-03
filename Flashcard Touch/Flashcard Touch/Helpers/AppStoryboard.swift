//
//  AppStoryboard.swift
//  Restaurant
//
//  Created by Nham Que Huy on 4/15/17.
//  Copyright © 2017 1542231. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main, DeckDetail
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFrom(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
