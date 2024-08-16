//
//  BookCell.swift
//  bookstore
//
//  Created by Mohamad Shahrul  on 05/06/1403 AP.
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loadingOverlay: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bookImageView.layer.cornerRadius = 25
        self.loadingOverlay.layer.cornerRadius = 25
        self.bookImageView.clipsToBounds = true
        bookImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Set value from db into cell
    func setCellValues(name : String, author : String, date : String, imgUrl : String){
        bookNameLabel.text = name
        authorNameLabel.text = "By: " + author
        dateLabel.text = date
        if let imageUrl = URL(string: imgUrl) {
            loadImage(from: imageUrl, into: bookImageView)
        }
    }
    
    private func loadImage(from url: URL, into imageView : UIImageView) {
        // Show loading indicator
        loadingOverlay.isHidden = false
        
        // Load image asynchronously
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                    // Hide loading indicator
                    self.loadingOverlay.isHidden = true
                    self.bookImageView.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    // Hide loading indicator
                    self.loadingOverlay.isHidden = true
                    
                    let alert = UIAlertController(title: "Error", message: "Some error occured while loading image", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                }
            }
        }
    }
    
}
