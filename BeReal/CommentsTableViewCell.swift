//
//  CommentsTableViewCell.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 3/6/23.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
//    
//    var position: Int?
    @IBOutlet weak var commentLabel: UILabel!
    
    
    func configure(with post: [String], at position: Int) {
//                print("YAYYY")
                print(post)
                    
        commentLabel.text = post[position]

    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
