//
//  CreateVC.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 30/05/1403 AP.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class CreateVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var bookNameTextField: UITextField!
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var chooseImageButton: UIButton!
    @IBOutlet var bookAuthorTextField: UITextField!
    @IBOutlet var bookImageLoadingOverlay: UIActivityIndicatorView!
    @IBOutlet var createButtonView: UIButton!
    @IBOutlet var bookNotesTextField: UITextView!
    
    
    var blurLoadingEffect : BlurLoadingView?
    let FireBaseStorageRef = Storage.storage().reference()
    var userSelectedImage : UIImage?
    var DBref = Database.database().reference().child("Users")
    var oldBook: BookModel?
    var userInputBookName : String?
    var userInputBookAuthor : String?
    var userInputBookNotes : String?
    var generatedImageName : String?
    var bookTimeStamp : Int?
    var bookDate : String?
    var bookId : String?
    var userInputbookImageUrl : String?
    var isEdit : Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageLoadingOverlay.isHidden = true
        bookNotesTextField.layer.cornerRadius = 5
        bookNotesTextField.delegate = self
        bookNotesTextField.textColor = UIColor.lightGray
        
        if isEdit == true{
            setupEditInitialStates()
        }
        setupKeyboardLayout()
        
        blurLoadingEffect = BlurLoadingView(viewController: self)
    }
    
    @IBAction func chooseImageButtonAction(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func createButtonAction(_ sender: Any) {
        if(isEdit == true){
            setupBeforeUpdateDatabase()
        } else{
            Task{
                blurLoadingEffect?.show()
                await BookDataProcesses()
            }
        }
    }
    
    func BookDataProcesses() async{
        let isInputsNotEmpty = await checkInputsEmpty()
        
        if(isInputsNotEmpty){
            let imageData : Data = await setupImage()!
            let newImageRef = FireBaseStorageRef.child(generatedImageName!)
            let oldImageRef = FireBaseStorageRef.child(oldBook?.imgName ?? "")
            let isSucceedImage = await putImage(into: newImageRef, value: imageData)
            
            if isSucceedImage {
                let isSucceedData = await self.processBookDataToFirebaseDatabase(imgURL: self.userInputbookImageUrl!, imgName: self.generatedImageName!)
                
                if isSucceedData {
                    if isEdit == true{
                        do{
                            try await deleteImage(from: oldImageRef)
                            await navigateToHomeVC()
                        } catch{
                            print("Error: \(error.localizedDescription)")
                        }
                    } else{
                        await navigateToHomeVC()
                    }
                }
            }
        }else{
            blurLoadingEffect?.hide()
        }
    }
    
    func checkInputsEmpty() async -> Bool  {
        userSelectedImage = bookImageView.image
        if let image = userSelectedImage {
            //do nothing
        } else {
            showAlert(on: self, title: "Error", message: "Book Image is empty!")
            return false
        }
        
        if let name = bookNameTextField.text, name.isEmpty{
            showAlert(on: self, title: "Error", message: "Book Name is empty!")
            return false
        }
        
        if let author = bookAuthorTextField.text, author.isEmpty{
            showAlert(on: self, title: "Error", message: "Book Author is empty!")
            return false
        }
        
        if let notes = bookNotesTextField.text, notes.isEmpty{
            showAlert(on: self, title: "Error", message: "Book Notes is empty!")
            return false
        }
        
        return true
    }
    
    func convertToDictionary<T: Codable>(object: T) -> [String: Any]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Error converting object to dictionary: \(error.localizedDescription)")
        }
        return nil
    }
}




