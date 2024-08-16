//
//  HomeVC+TableViewExt.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 03/06/1403 AP.
//

import Foundation
import UIKit
import FirebaseStorage

extension HomeVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell
        let data = booksArray[indexPath.row]
        
        cell?.setCellValues(name: data.bookName, author: data.bookAuthor, date: data.bookDate, imgUrl: data.bookImageUrl)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = booksArray[indexPath.row]
        performSegue(withIdentifier: "ToCreate", sender: data)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if (editingStyle == .delete){
            
            
            let bookImageRef = Storage.storage().reference().child(self.booksArray[indexPath.row].imgName)
            
            Task{
                do {
                    try await self.deleteImage(from: bookImageRef)
                } catch{
                    print(error)
                }
                
                deleteDataFromFirebaseDB(book: booksArray[indexPath.row]) { isDeleted in
                        if(isDeleted){
                            tableView.reloadData()
                        } else {
                            print ("error deleting data from firebase")
                       }
                    }
            }
            
   
        }
    }
}
