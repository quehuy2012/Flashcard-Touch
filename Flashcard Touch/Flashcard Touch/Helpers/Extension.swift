//
//  Extension.swift
//  Restaurant
//
//  Created by Nham Que Huy on 4/15/17.
//  Copyright © 2017 1542231. All rights reserved.
//

import Foundation
import UIKit

protocol MasterDetailControllerDelegate: class {
    
    func didAdd<T>(object: T)
    func didUpdate<T>(object: T, at indexPath:IndexPath)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlert(withTitle title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(dismissAction)
        
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alert.dismiss(animated: true, completion: nil)
            }
        })
    }
}

extension UITableView {
    func dequeueReusableCell<T:UITableViewCell>(type: T.Type) -> T? {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = fullName.substring(from: range.upperBound)
        }
        return self.dequeueReusableCell(withIdentifier: fullName) as? T
    }
    
    func dequeueReusableCell<T:UITableViewCell>(type: T.Type, forIndexPath indexPath:IndexPath) -> T? {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = fullName.substring(from: range.upperBound)
        }
        return self.dequeueReusableCell(withIdentifier: fullName, for: indexPath) as? T
    }
}

extension UICollectionView {    
    func dequeueReusableCell<T:UICollectionViewCell>(type: T.Type, forIndexPath indexPath:IndexPath) -> T? {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards) {
            fullName = fullName.substring(from: range.upperBound)
        }
        return self.dequeueReusableCell(withReuseIdentifier: fullName, for: indexPath) as? T
    }
}
