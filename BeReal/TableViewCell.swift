//
//  TableViewCell.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/25/23.
//

import UIKit

import Alamofire

import AlamofireImage
import CoreLocation
import ImageIO
import Foundation

class TableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    var myPostObject: Post?
    var indexPost: Int?
    var onPostSelected: ((Post) -> Void)?
    
    var selectedIndexPath: Int?
    
    var inputtts = [String]()
    
    var position: Int?
    
    var curDate: Date?
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var secondtable: UITableView!
    @IBOutlet weak var postRound: UIImageView!
    
    @IBOutlet private weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postLocation: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    
    private var posts = [Post]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            secondtable.reloadData()
            
        }
    }
    
    
    @IBAction func didTapComment(_ sender: UIButton) {
        if let post = myPostObject {
                    onPostSelected?(post)
                }
        
        
        
    }
    
    
    func configure(with post: Post) {
        // TODO: Pt 1 - Configure Post Cell
        self.myPostObject = post
//        print("!!!")
        
//        if let innerCell = secondtable?.dequeueReusableCell(withIdentifier: "commentCell") as? CommentsTableViewCell {
//                    if let comments = post.comments {
////                        print(comments)
//                        innerCell.configure(with: comments)
//                    }
//
//                }
       
//        if let comment = post.comments{
//            for c in comment{
//                self.inputtts.append(c)
//            }
//        }
//
//        print("iiinnnpppuuutts",self.inputtts)
        
        if let user = post.user {
            profileName.text = user.username
            if let imageFile = user.profilePhoto,
               let imageUrl = imageFile.url {
                
                // Use AlamofireImage helper to fetch remote image from URL
                imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                    switch response.result {
                    case .success(let image):
                        // Set image view image with fetched image
                        self?.postRound.image = image
    //                    print("You have image!!!!")
                    case .failure(let error):
                        print("❌ Error fetching image: \(error.localizedDescription)")
                        break
                    }
                }
            }else{
                self.postRound.image = UIImage(systemName: "person.circle")
                
            }
            
            
        }
        self.postRound.layer.cornerRadius = (self.postRound.frame.height ) / 2
        self.postRound.layer.masksToBounds = true
        
     
        
        
        
        
       

        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImage.image = image
//                    print("You have image!!!!")
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }

        // Caption
        postDescription.text = post.caption
        if let location = post.imageLocation {
            postLocation.text = location + ", "
        }


        // Date
        if let date = post.createdAt {
            postTime.text =  DateFormatter.timeAgoSinceDate(date)
        }
        
        
//        if let postCreatedDate = post.createdAt {
//            let currentDate = Date()
//            let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: currentDate).hour
//            if let unwrappedDiffHours = diffHours {
//                blurView.isHidden = abs(unwrappedDiffHours) < 24
//            } else {
//                blurView.isHidden = false
//            }
//        } else {
//            blurView.isHidden = false
//        }
        
        if let currentUser = User.current,

            // Get the date the user last shared a post (cast to Date).
           let lastPostedDate = currentUser.lastPostedDate,

            // Get the date the given post was created.
           let postCreatedDate = post.createdAt,

            // Get the difference in hours between when the given post was created and the current user last posted.
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {

            // Hide the blur view if the given post was created within 24 hours of the current user's last post. (before or after)
            blurView.isHidden = abs(diffHours) < 24
        } else {

            // Default to blur if we can't get or compute the date's above for some reason.
            blurView.isHidden = false
        }

        

    }
    
   

    override func prepareForReuse() {
        super.prepareForReuse()
        // TODO: P1 - Cancel image download
        // Reset image view image.
        postImage.image = nil
        postRound.image = nil

        // Cancel image request.
        imageDataRequest?.cancel()

    }
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           // Set the delegate and data source for the inner table view
           secondtable.delegate = self
           secondtable.dataSource = self
        
        
//            self.secondtable.register(CommentsTableViewCell.self, forCellReuseIdentifier: "commentCell")
       }

       // Implement the UITableViewDelegate method to set the row height for the inner table view
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40.0 // Set the row height for the inner table view
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           guard let post = self.myPostObject, let comments = post.comments else{
               return 0
           }
           return comments.count

       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentsTableViewCell else {
            return UITableViewCell()
        }
        print("indexrow of Posts", self.position)
        if let comm = myPostObject?.comments {
//                print(comm)
            cell.configure(with: comm, at: indexPath.row)

        }
//        print("inputs",self.inputtts)
        
        print("you are configuring again")
        return cell
    }
    
   
    
    
}

extension DateFormatter {
    static let postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    static func timeAgoSinceDate(_ date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        
        let now = Date()
        let interval = now.timeIntervalSince(date)
        guard let string = formatter.string(from: interval) else {
            return ""
        }
        
        if let range = string.range(of: ",") {
            let index = string.index(range.lowerBound, offsetBy: -2)
            return String(string[..<index]) + " ago"
        } else {
            return string + " ago"
        }
    }
}


