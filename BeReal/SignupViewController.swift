//
//  SignupViewController.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/25/23.
//

import UIKit
import ParseSwift
import PhotosUI

class SignupViewController: UIViewController{
    

    @IBOutlet weak var setSignup: UIButton!
    @IBOutlet weak var setPassword: UITextField!
    @IBOutlet weak var setEmail: UITextField!
    @IBOutlet weak var setUsername: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        // Do any additional setup after loading the view.
    }
    
   

    
    
    
    @IBAction func didTapSignup(sender: UIButton){
        
        guard let username = setUsername.text,
              let email = setEmail.text,
              let password = setPassword.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }
        

   
        
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password
        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
            }
        }

    }

    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


