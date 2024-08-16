//
//  TestViewController.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 29/05/1403 AP.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var createNewBookButton: UIBarButtonItem!
    private var blurLoadingView : BlurLoadingView?
    var booksArray : [BookModel] = []
    var DatabaseReference = Database.database().reference().child("Users")
    var userId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurLoadingView = BlurLoadingView(viewController: self)

        let backButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        //register custom tableview cell into the tableview
        let nib = UINib.init(nibName: "BookCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BookCell")
        
        //start loading book data from database
        loadDataFromFirebase()
    }
    
    //prepare to transfer the existing book data into the create page if user pressed on the table cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCreate" {
            if let destinationVC = segue.destination as? CreateVC {
                if let selectedBook = sender as? BookModel {
                    destinationVC.oldBook = selectedBook
                    destinationVC.isEdit = true
                }
            }
        }
    }
    
    @objc func logoutButtonTapped() {
        
        // Perform logout functionality
        showConfirmationDialog(on: self, title: "Log Out", message: "Are you sure want to log out?")
    }
    
    func showConfirmationDialog(on viewController: UIViewController, title: String, message: String) {
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add the cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
           // Do nothing
        }
        alertController.addAction(cancelAction)
        
        // Add the confirm action
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            // Go back to login page
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(confirmAction)
        
        // Present the alert controller
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func createNewBookButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "ToCreate", sender: nil)
    }

}





