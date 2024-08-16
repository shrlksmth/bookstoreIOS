//
//  BookDataModel.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 29/05/1403 AP.
//

import Foundation

struct BookModel : Codable{
    let bookAuthor: String
    let bookDate: String
    let bookID: String
    let bookName: String
    let bookNotes: String
    let bookImageUrl: String
    let imgName: String
    let timeStamp: Int
}
