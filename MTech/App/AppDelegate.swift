//
//  AppDelegate.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

      var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppAppearance.setupAppearance()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: SplashViewController())
        
        SPApp.Launch.run()
                
        return true
    }
    
    func openApp() {
        if User.loggedIn() {
             goToDashBoard()
         } else {
           window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
         }
     }
    
    func goToDashBoard() {
        window?.rootViewController = MTechTabbarController()
    }



}

