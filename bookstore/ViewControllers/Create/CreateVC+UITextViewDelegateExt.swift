//
//  CreateVC+UITextviewExt.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 06/06/1403 AP.
//

import Foundation
import UIKit

// UITextViewDelegate extension
extension CreateVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}
