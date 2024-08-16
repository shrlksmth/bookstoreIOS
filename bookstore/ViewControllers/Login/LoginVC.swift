//
//  ViewController.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 26/05/1403 AP.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class LoginVC: UIViewController {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var userPasswordTextField: UITextField!
    @IBOutlet var infoLabel: UILabel!
    var blurLoadingEffect : BlurLoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurLoadingEffect = BlurLoadingView(viewController: self)
        
        infoLabel.text = ""
        
        loginButton.layer.cornerRadius = 8
        
        userIdTextField.layer.borderColor = UIColor.black.cgColor
        userIdTextField.layer.borderWidth = 0.7
        userIdTextField.layer.cornerRadius = 5
        
        userPasswordTextField.layer.borderColor = UIColor.black.cgColor
        userPasswordTextField.layer.borderWidth = 0.7
        userPasswordTextField.layer.cornerRadius = 5
    }
    
    //prepare for sending the userId string to home page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToHome" {
            if let destinationVC = segue.destination as? HomeVC,
               let userId = sender as? String {
                destinationVC.userId = userId
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        blurLoadingEffect?.show()
        
        guard let userId = userIdTextField.text, !userId.isEmpty else {
            infoLabel.text = "User ID is empty"
            blurLoadingEffect?.hide()
            return
        }
        
        let dbRef = Database.database().reference().child("Users").child(userId)
        
        checkUserCredential(from: dbRef, withId : userId)
    }
    
    private func checkUserCredential(from ref : DatabaseReference, withId userId : String){
        ref.observeSingleEvent(of: .value){
            snapshot in
            
            if snapshot.exists(){
                if let data = snapshot.value as? [String: Any]{
                    
                    if let password = data["password"] as? String{
                        let userInputPass = self.userPasswordTextField.text ?? ""
                        if userInputPass == password{
                            self.blurLoadingEffect?.hide()
                            self.performSegue(withIdentifier: "ToHome", sender: userId)
                        } else{
                            self.blurLoadingEffect?.hide()

                            self.infoLabel.text = "Password are wrong!"
                        }
                    } else{
                        self.blurLoadingEffect?.hide()
                        self.infoLabel.text = "Password cannot be found!"
                    }
                } else {
                    self.blurLoadingEffect?.hide()
                    self.infoLabel.text = "Data cannot be found!"
                }
            } else{
                self.blurLoadingEffect?.hide()
                self.infoLabel.text = "UserId Doesn't exist!"
            }
        }
    }
}

