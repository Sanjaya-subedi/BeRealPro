//
//  AppDelegate.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/25/23.
//

import UIKit
import ParseSwift



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var current: User?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ParseSwift.initialize(applicationId: "vcQZqStcuJann0zXFaxUdIYm8WH81UeHxLOn1vLM",
                              clientKey: "iagIo6AHNZhY3edUmaIEO711gEqwxfDcsHxAIT0E",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)
        
        if let currentUser = User.current {
                   // User is logged in, set feed view as initial view controller
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let exampleViewController: FeedTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "FeedTableViewController") as! FeedTableViewController
            

                self.window?.rootViewController = exampleViewController

                self.window?.makeKeyAndVisible()
            print("user is logged in", currentUser)

                return true
               }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let exampleViewController: ViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        

            self.window?.rootViewController = exampleViewController

            self.window?.makeKeyAndVisible()
        print("user is not logged in")

            return true
    }
}
