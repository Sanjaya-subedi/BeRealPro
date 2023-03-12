//
//  PostViewController.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/25/23.
//

import UIKit
import PhotosUI
import ParseSwift
import CoreLocation
import Photos

class PostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var albumButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var captionField: UITextField!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    var pickedImage: UIImage?
    var locationPost: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapShare(sender: UIBarButtonItem){
         let activityIndicator = UIActivityIndicatorView(style: .medium)
         activityIndicator.startAnimating()
         navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
         
         guard let image = pickedImage,
               // Create and compress image data (jpeg) from UIImage
               let imageData = image.jpegData(compressionQuality: 0.1) else {
             return
         }
         
         // Create a Parse File by providing a name and passing in the image data
         let imageFile = ParseFile(name: "image.jpg", data: imageData)
        
        
        
        if var currUser =  User.current{
            currUser.lastPostedDate = Date()
            currUser.save { [weak self] result in
                
                // Switch to the main thread for any UI updates
                DispatchQueue.main.async {
                    switch result {
                    case .success(let post):
                        print("✅ Post Saved! \(post)")
                        
                        // Return to previous view controller
                        
                    case .failure(let error):
                        print("error", error)
                    }
                }
            }
            
            
            
        }
         
         // Create Post object
         var post = Post()
         
         // Set properties
         post.imageFile = imageFile
         post.caption = captionField.text
         post.imageLocation = self.locationPost
         
         // Set the user as the current user
         post.user = User.current
         
         // Save object in background (async)
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
    
    @IBAction func didTapAlbum(sender: UIButton){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }
        
        // Instantiate the image picker
        let imagePicker = UIImagePickerController()
        
        // Shows the camera (vs the photo library)
        imagePicker.sourceType = .camera
        
        // Allows user to edit image within image picker flow (i.e. crop, etc.)
        // If you don't want to allow editing, you can leave out this line as the default value of `allowsEditing` is false
        //        imagePicker.allowsEditing = true
        
        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        imagePicker.delegate = self
        
        // Present the image picker (camera)
        present(imagePicker, animated: true)
        
    }
    
    func presentGoToSettingsAlert() {
        let alertController = UIAlertController (
            title: "Photo Access Required",
            message: "In order to post a photo to complete a task, we need access to your photo library. You can allow access in Settings",
            preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Dismiss the image picker
        picker.dismiss(animated: true)
        
        // Get the edited image from the info dictionary (if `allowsEditing = true` for image picker config).
        // Alternatively, to get the original image, use the `.originalImage` InfoKey instead.
        guard let image = info[.originalImage] as? UIImage else {
            print("❌📷 Unable to get image")
            return
        }
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 0
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard let asset = result.firstObject else{
            return
        }
        if let location = asset.location{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            getLocationNameFromCoordinates(latitude: lat, longitude: lon) { name in
                if let name = name {
                    print("Location Name: \(name)")
                    self.locationPost = name
                } else {
                    print("Unable to retrieve location name")
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        // Set image on preview image view
        selectedImage.image = image
        
        // Set image to use when saving post
        self.pickedImage = image
    }
    
    
    
    func getLocationNameFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error reverse geocoding: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            
            let name = placemark.name ?? placemark.locality ?? placemark.country ?? "Unknown"
            completion(name)
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
    

