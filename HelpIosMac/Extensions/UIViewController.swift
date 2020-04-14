//
//  UIViewController.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 09/04/20.
//  Copyright © 2020 Rinver. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showViewController(storyboard: String, identifier: String) -> UIViewController {
        let view = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        present(view, animated: true, completion: nil)
        return view
    }
    
    func goToViewWithNavController(storyboard: String, identifier: String) -> UIViewController {
        let view = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        navigationController?.show(view, sender: self)
        return view
    }
    
    func goToViewWithPushNavController(storyboard: String, identifier: String, animated: Bool? = true) -> UIViewController {
        let view = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(view, animated: animated!)
        return view
    }
    
    func showProgressIndicator() {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.mode = .indeterminate
    }
    
    func hideProgressIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func closeKeyboardOnOutsideTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}
