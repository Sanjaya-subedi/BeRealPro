//
//  ViewController.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/25/23.
//

import UIKit
import ParseSwift


class ViewController: UIViewController{
    var window: UIWindow?
    var current: User?

    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    
    
    @IBAction func didTapLogin(sender: UIButton){
        guard let username = username.text,
              let password = password.text,
              !username.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }
        User.login(username: username, password: password) { [weak self] result in

            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")
                
//                let token = UUID().uuidString
//                   UserDefaults.standard.setValue(token, forKey: "session_token")
//                   UserDefaults.standard.synchronize()

                // Post a notification that the user has successfully logged in.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "FeedTableViewController") as? FeedTableViewController{
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else{
                    print("novc")
                }

            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }

        
    }
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Login", message: description ?? "You need to sign up first or you have entered wrong information!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    


}

