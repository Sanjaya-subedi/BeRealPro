//
//  ProfileViewController.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 3/2/23.
//

import UIKit
import PhotosUI
import ParseSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var ppButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func didTapAlbum(sender: UIButton){
        var config = PHPickerConfiguration()

        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images

        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current

        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker
        present(picker, animated: true)
        
        
    }
    
    @IBAction func didTapShare(sender: UIButton){
       
        

        if var currentUser = User.current {
            // The current user is logged in
            print("Current user's username: \(currentUser.username ?? "")")
            guard let image = pickedImage,
                          // Create and compress image data (jpeg) from UIImage
                          let imageData = image.jpegData(compressionQuality: 0.1) else {
                        return
                    }
            
                    // Create a Parse File by providing a name and passing in the image data
                    let imageFile = ParseFile(name: "image.jpg", data: imageData)
            
            currentUser.profilePhoto = imageFile
                    // Save object in background (async)
                    currentUser.save { [weak self] result in
            
                        // Switch to the main thread for any UI updates
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let post):
                                print("✅ Post Saved! \(post)")
            
                                // Return to previous view controller
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        
                                        // Get the view controller using its storyboard ID
                                        guard let nextVC = storyboard.instantiateViewController(withIdentifier: "FeedTableViewController") as? FeedTableViewController else {
                                            return
                                        }
                                        
                                        // Set any properties on the next view controller here
                                        
                                        // Navigate to the next view controller
                                        self?.navigationController?.pushViewController(nextVC, animated: true)
            
                            case .failure(let error):
                                print("error", error)
                            }
                        }
                    }
            
            
            
            
            
        } else {
            // No user is logged in
            print("No user is logged in")
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

}
extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
           // Make sure the provider can load a UIImage
           provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

           // Make sure we can cast the returned object to a UIImage
           guard let image = object as? UIImage else {

              // ❌ Unable to cast to UIImage
//              self?.showAlert()
              return
           }

           // Check for and handle any errors
           if let error = error {
              print("error", error)
              return
           } else {

              // UI updates (like setting image on image view) should be done on main thread
              DispatchQueue.main.async {

                 // Set image on preview image view
                 self?.profileImage.image = image

                 // Set image to use when saving post
                 self?.pickedImage = image
              }
           }
        }
    }
    

}

