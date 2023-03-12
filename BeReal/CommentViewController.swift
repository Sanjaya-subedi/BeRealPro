//
//  CommentViewController.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 3/6/23.
//

import UIKit

class CommentViewController: UIViewController {
    var post: Post?
    
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here!!!!!")
        if let post = post {
            print(post) // This will print the value of the `post` property to the console
        }else{
            print("you dont have post")
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        guard let comment = commentText.text,
              !comment.isEmpty else {
            presentEmptyFieldAlert()
            return
        }

        guard let username = User.current?.username else {
            print("Error: could not get current user's username")
            return
        }

        let newComment = "\(username): \(comment)"

        
        if var post = post {
            if var comments = post.comments {
                comments.append(newComment)
                post.comments = comments
                print("Comment appended!")
            } else {
                post.comments = [newComment]
                print("Created a new comments array and appended the comment!")
            }
            // Update the post on the server
            post.save { [weak self] result in
                
                // Switch to the main thread for any UI updates
                DispatchQueue.main.async {
                    switch result {
                    case .success(let post):
                        print("✅ Post Saved! \(post)")
                        
                        // Return to previous view controller
                        self?.navigationController?.popViewController(animated: true)
                        
                    case .failure(let error):
                        print("error", error)
                    }
                }
            }
            
        }
        
        
        
        
        func presentEmptyFieldAlert() {
            let alertController = UIAlertController(
                title: "Oops...",
                message: "Comment must be filled out",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
