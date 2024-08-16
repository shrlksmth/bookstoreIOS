//
//  HomeVC+FirebaseExt.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 05/06/1403 AP.
//

import Foundation
import FirebaseDatabaseInternal
import FirebaseStorage

extension HomeVC {
    
    func loadDataFromFirebase () {
        let booksDataRef = DatabaseReference.child(userId!).child("book")
        booksDataRef.observe(.value, with: {
            
            snapshot in
            
            self.booksArray.removeAll()
            
            if (snapshot.exists()){
                for child in snapshot.children{
                    if let snapshot = child as? DataSnapshot,
                       let bookDictFromFirebase = snapshot.value as? [String : Any]{
                        let book = BookModel(
                            bookAuthor: bookDictFromFirebase["bookAuthor"] as? String ?? "-",
                            bookDate: bookDictFromFirebase["bookDate"] as? String ?? "-",
                            bookID: bookDictFromFirebase["bookID"] as? String ?? "-",
                            bookName: bookDictFromFirebase["bookName"] as? String ?? "-",
                            bookNotes: bookDictFromFirebase["bookNotes"] as? String ?? "-",
                            bookImageUrl: bookDictFromFirebase["bookImageUrl"] as? String ?? "-",
                            imgName: bookDictFromFirebase["imgName"] as? String ?? "-",
                            timeStamp: bookDictFromFirebase["timeStamp"] as? Int ?? 0
                        )
                        self.booksArray.append(book)
                    }
                }
                
                //reload the tableView once finish insert all book data into array
                self.tableView.reloadData()
            }
            else {
                print("No data exists at the snapshot")
            }
            
        }) { error in
            self.showAlert(on: self, title: "Error", message: "Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func deleteDataFromFirebaseDB(book: BookModel, completion: @escaping (Bool) -> Void) {
        let bookDataRef = DatabaseReference.child("SS/book/\(book.bookID)")

        bookDataRef.removeValue {
            error, _ in
            
            if error != nil {
                completion(false)
                print("Error removing child node: \(error!.localizedDescription)")
            } else {
                completion(true)
                print("Child node deleted successfully.")
            }
        }
    }
    
 
    
    func deleteImage(from ref: StorageReference) async throws{
        return try await withCheckedThrowingContinuation { continuation in
            ref.delete {error in
                if let err = error{
                    print("fail delete book image")
                    continuation.resume(throwing: err)
                }else{
                    continuation.resume()
                    print("Successfully deleted book image")
                }
            }
        }
    }
}
