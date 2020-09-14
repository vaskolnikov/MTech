//
//  AppAppearance.swift
//  MTech
//
//  Created by Adem Özsayın on 11.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation
import UIKit

final class AppAppearance {
    
    static func setupAppearance() {
        //navbar appearence
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 14)!]
        navBarAppearance.barTintColor = Global.appColor
        navBarAppearance.tintColor = SPNativeColors.white
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SPNativeColors.white,NSAttributedString.Key.font: Global.navBarFont!]
        navBarAppearance.isTranslucent = false
        
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:SPNativeColors.white,
                                                                        NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 30)! ]

        
         //tabBarAppearance
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = Global.appColor

        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([NSAttributedString.Key.font: Global.tabBarFont!], for: .normal)
        tabBarItemAppearance.setTitleTextAttributes([NSAttributedString.Key.font: Global.tabBarFontSelected!], for: .selected)
         

        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 14)!], for: UIControl.State.normal)


    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
