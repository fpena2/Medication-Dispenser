/*
**********************************************************
*   Statement of Compliance with the Stated Honor Code   *
**********************************************************
I hereby declare on my honor that:
 
 (1) All work is completely my own in this Assignment.
 (2) I did NOT receive any help about how to develop the assignment app.
 (3) I did NOT give any help to anyone about how to develop the assignment app.
 (4) I did NOT ask questions to Dr. Balci, GTA or UTA about how to develop the assignment app.
 
I am hereby writing my name as my signature to declare that the above statements are true:
   
      Boyan Tian
 
**********************************************************
 */

//
//  AppDelegate.swift
//  MyPIM
//
//  Created by Boyan Tian on 10/20/20.
//

import UIKit
import Amplify
import AWSS3StoragePlugin
import AWSCognitoAuthPlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        
        readMoviesDataFiles()
        readToDoListDataFiles()
        createSortedLists()
        do {
                    try Amplify.add(plugin: AWSCognitoAuthPlugin())
                    try Amplify.add(plugin: AWSS3StoragePlugin())
                    try Amplify.configure()
                    print("Amplify configured with storage plugin")
                } catch {
                    print("Failed to initialize Amplify with \(error)")
                }
        initializeS3()
        downloadJson()
        downloadAioutputJson()
        readDevicesDataFiles()
        checkPastDate()
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

