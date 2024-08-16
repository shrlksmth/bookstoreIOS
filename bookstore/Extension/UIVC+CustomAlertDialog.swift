//
//  UIVC+CustomAlertDialog.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 03/06/1403 AP.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
