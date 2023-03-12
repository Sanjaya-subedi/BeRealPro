//
//  SceneDelegate.swift
//  BeReal
//
//  Created by Sanjaya Subedi on 2/25/23.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var timer: Timer?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        if User.current != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navController = storyboard.instantiateViewController(withIdentifier: "FeedNav") as! UINavigationController
            navController.viewControllers = [storyboard.instantiateViewController(withIdentifier: "FeedTableViewController")]
            self.window?.rootViewController = navController
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        timer?.invalidate()
        timer = nil
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
           
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
                    self.scheduleNotification()
                }
    }
    func scheduleNotification() {
        // Request permission to display notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                // Schedule the notification
                let content = UNMutableNotificationContent()
                content.title = "Reminder"
                content.body = "Don't forget to post today!"
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false) // set to 10 seconds for testing
                let request = UNNotificationRequest(identifier: "postReminder", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error adding notification request: \(error.localizedDescription)")
                    } else {
                        print("Notification request added successfully.")
                    }
                }
            }
        }
    }



}

