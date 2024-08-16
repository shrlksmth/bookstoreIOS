//
//  CreateVC+FirebaseExt.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 02/06/1403 AP.
//

import UIKit
import FirebaseStorage
import FirebaseDatabaseInternal

extension CreateVC{
    
    func setupImage() async -> Data?{
        //generate new image name = current timestamp
        generatedImageName = String("\(Int(Date().timeIntervalSince1970 * 1000)).jpg")
        userSelectedImage = bookImageView.image
        
        // Check if the image is available
        guard let image = userSelectedImage else {
            DispatchQueue.main.async {
                self.blurLoadingEffect?.hide()
                self.showAlert(on: self, title: "Error", message: "No image selected")
            }
            return nil
        }
        
        // Convert the UIImage to image data
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            DispatchQueue.main.async {
                self.blurLoadingEffect?.hide()
                self.showAlert(on: self, title: "Error", message: "Cannot convert the image to data")
            }
            return nil
        }
        
        return imageData
    }
    
    func putImage(into ref: StorageReference, value imageData : Data) async -> Bool {
        do {
            // Upload the image data
            _ = try await ref.putDataAsync(imageData)
            
            // Retrieve the download URL
            let downloadURL = try await ref.downloadURL()
            
            self.userInputbookImageUrl = downloadURL.absoluteString
            
            print("Successfully save book image")
            return true
            
        } catch {
            // Handle errors
            DispatchQueue.main.async {
                self.blurLoadingEffect?.hide()
                self.showAlert(on: self, title: "Error", message: "Cannot Upload Your Image!: \(error.localizedDescription)")
            }
            return false
        }
    }
    
    func deleteImage(from ref: StorageReference) async throws{
        return try await withCheckedThrowingContinuation { continuation in
            ref.delete {error in
                if let err = error{
                    print("Fail delete image")
                    continuation.resume(throwing: err)
                }
                continuation.resume()
                print("Successfully update image")
            }
        }
    }
    
    func processBookDataToFirebaseDatabase(imgURL: String, imgName: String) async -> Bool {
        let newBook = generateBookObject()
        
        guard let bookDictionary = convertToDictionary(object: newBook) else {
            print("Failed to convert book to dictionary")
            return false
        }
        
        let bookRef = DBref.child("SS").child("book").child(newBook.bookID)
        
        do {
            if isEdit! {
                try await updateBook(into: bookRef, withValues: bookDictionary)
            } else {
                try await setBook(into: bookRef, withValues: bookDictionary)
            }
            
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func generateBookObject() -> BookModel{
        userInputBookName = bookNameTextField.text!
        userInputBookAuthor = bookAuthorTextField.text!
        userInputBookNotes = bookNotesTextField.text!
        
        // Create a Date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        bookDate = dateFormatter.string(from: currentDate)
        
        //Create the book id
        if isEdit == false {
            bookId = UUID().uuidString
        } else{
            bookId = oldBook?.bookID
        }
        
        //Create the timestamp
        bookTimeStamp = Int(Date().timeIntervalSince1970 * 1000)
        
        let book : BookModel = BookModel(bookAuthor: userInputBookAuthor!, bookDate: bookDate!, bookID: bookId!, bookName: userInputBookName!, bookNotes: userInputBookNotes!, bookImageUrl: userInputbookImageUrl!, imgName: generatedImageName!, timeStamp: bookTimeStamp!)
        
        return book
    }
    
    func updateBook(into ref: DatabaseReference, withValues values: [String: Any]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            ref.updateChildValues(values) { error, _ in
                if let err = error {
                    continuation.resume(throwing: err)
                } else {
                    print("Successfully update book data")
                    continuation.resume()
                }
            }
        }
    }
    
    private func setBook(into ref: DatabaseReference, withValues values: [String: Any]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            ref.setValue(values) { error, _ in
                if let err = error {
                    continuation.resume(throwing: err)
                } else {
                    print("Successfully save book data")
                    continuation.resume()
                }
            }
        }
    }
    
    func navigateToHomeVC() async {
        await MainActor.run {
            self.blurLoadingEffect?.hide()
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController is HomeVC {
                        self.navigationController?.popToViewController(viewController, animated: true)
                        return
                    }
                }
            }
        }
    }
    
}
