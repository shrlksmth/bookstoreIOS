//
//  CreateVC + Edit Ext.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 01/06/1403 AP.
//

import UIKit

extension CreateVC {

    func setupEditInitialStates(){
        bookNameTextField.text = oldBook?.bookName
        bookAuthorTextField.text = oldBook?.bookAuthor
        bookNotesTextField.text = oldBook?.bookNotes
        bookNameTextField.textColor = UIColor.lightGray
        bookAuthorTextField.textColor = UIColor.lightGray
        bookNotesTextField.textColor = UIColor.lightGray
        bookNameTextField.isEnabled = false
        bookAuthorTextField.isEnabled = false
        bookNotesTextField.isEditable = false
        userSelectedImage = bookImageView.image
        bookImageView.isHidden = true
        bookImageLoadingOverlay.isHidden = false
        
        if let imageUrl = oldBook?.bookImageUrl {
            loadImage(from: URL(string :imageUrl)!, into: bookImageView)
        }
        
        createButtonView.setTitle("Edit", for: .normal)
        chooseImageButton.isHidden = true
    }
    
    @objc func setupBeforeUpdateDatabase() {
        if createButtonView.title(for: .normal) == "Edit"  {
            createButtonView.setTitle("Done", for: .normal)
            chooseImageButton.isHidden = false
            bookNameTextField.isEnabled = true
            bookAuthorTextField.isEnabled = true
            bookNotesTextField.isEditable = true
            bookNameTextField.textColor = UIColor.black
            bookAuthorTextField.textColor = UIColor.black
            bookNotesTextField.textColor = UIColor.black
            
        } else {  //when the user click on the done button
            Task{
                blurLoadingEffect?.show()
                await BookDataProcesses()
            }
        }
    }
}
