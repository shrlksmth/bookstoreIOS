//
//  CreateVC + Ext.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 31/05/1403 AP.
//

import UIKit

extension CreateVC {

    func setupKeyboardLayout(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        hideKeyboardWhenTappedAround()
    }
    

    @objc func keyboardWillShow(_ notification: Notification) {
        // Get keyboard size and adjust the bottom constraint
        guard let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        let keyboardIsHidden = view.frame.origin.y == 0
        
        let bottomSpace = self.view.frame.height - (bookNotesTextField.frame.origin.y + bookNotesTextField.frame.height)
        if keyboardIsHidden{
            view.frame.origin.y -= keyboardFrame.cgRectValue.height - bottomSpace
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset the bottom constraint when the keyboard is hidden
        let keyboardIsHidden = view.frame.origin.y == 0
        if keyboardIsHidden{
            view.frame.origin.y = 0
        }
    }
    
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView  = false
        view.addGestureRecognizer(tap)
    }
     
    @objc func dismissKeyboard(){
        view.endEditing(true)
        view.frame.origin.y = 0
    }

}
