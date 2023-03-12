//
//  FeedTableViewController.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/25/23.
//

import UIKit
import ParseSwift
import PhotosUI

class FeedTableViewController: UIViewController{
    var window: UIWindow?
    var selectedPost: Post?
    
    var comments: [String]?
    
    
    @IBOutlet weak var mainTable: UITableView!
    

    private var posts = [Post]() {
        didSet {
            // Reload table view data any time the posts variable gets updated.
            mainTable.reloadData()
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTable.rowHeight = 600;
        self.navigationItem.hidesBackButton = true
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.allowsSelection = false
        
//        self.mainTable.register(TableViewCell.self, forCellReuseIdentifier: "postCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFeed(_:)), for: .valueChanged)
        mainTable.refreshControl = refreshControl
    }
    
    
    
    
    @objc private func refreshFeed(_ sender: Any) {
        queryPosts { [weak self] success in
            self?.mainTable.refreshControl?.endRefreshing()
            if success {
                self?.mainTable.reloadData()
            } else {
                self?.showAlert(description: "Failed to refresh feed.")
            }
        }
    }

    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try User.logout()
                    
                    // Remove the session token from UserDefaults
                    UserDefaults.standard.removeObject(forKey: "session_token")
                    UserDefaults.standard.synchronize()
                    
                    // Navigate to login view controller
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    let navController = UINavigationController(rootViewController: loginVC)
                    navController.modalPresentationStyle = .fullScreen
                    present(navController, animated: true) {
                        // Clear the navigation stack so user cannot go back to feed screen
                        self.navigationController?.setViewControllers([], animated: false)
                    }
            
        } catch let error {
            print("error", error)
            showAlert(description: error.localizedDescription)
        }

    }
    
    private func queryPosts(completion: @escaping (Bool) -> Void) {
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
//            .where("createdAt" >= yesterdayDate) // <- Only include results created yesterday onwards
//                .limit(10)

        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
                completion(true)
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
                completion(false)
            }
        }
    }


        
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        queryPosts()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        queryPosts { [weak self] success in
            if success {
                self?.mainTable.reloadData()
            } else {
                self?.showAlert(description: "Failed to load feed.")
            }
        }
    }

    
    

    private func queryPosts() {
        
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        mainTable.backgroundView = activityIndicator
        activityIndicator.startAnimating()

        // Fetch objects (posts) defined in query (async)
        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                // Update local posts property with fetched posts
                self?.posts = posts
                
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
        // TODO: Pt 1 - Query Posts
// https://github.com/parse-community/Parse-Swift/blob/3d4bb13acd7496a49b259e541928ad493219d363/ParseSwift.playground/Pages/2%20-%20Finding%20Objects.xcplaygroundpage/Contents.swift#L66


    }

    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension FeedTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.position = indexPath.row
        
        let post = posts[indexPath.row]
        cell.configure(with: post)
        cell.onPostSelected = { [weak self] post in
                    guard let self = self else { return }
                    self.selectedPost = post
//                    self.performSegue(withIdentifier: "commentSegue", sender: nil)
                }
        

    
        
//        let innerTableview = cell.secondtable
//        innerTableview?.delegate = self
//        innerTableview?.dataSource = self
//        
//        if let innerCell = innerTableview?.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentsTableViewCell {
//            if let comments = post.comments {
//                innerCell.configure(with: comments)
//            }
//        } else {
//        }


        
        return cell
    }
    func tableView(_tableView: UITableView, heightforRowAt indexPath: IndexPath) -> CGFloat{
        return 550.0
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "commentSegue" {
                let destinationVC = segue.destination as! CommentViewController
                destinationVC.post = selectedPost
            }
        }
    

}

extension FeedTableViewController: UITableViewDelegate { }
