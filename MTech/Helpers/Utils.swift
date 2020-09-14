//
//  Utils.swift
//  Makas
//
//  Created by Adem Özsayın on 8.03.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation
import UIKit
enum Global {
    
    static let appColor = UIColor(red: CGFloat(47/255.0), green: CGFloat(136/255.0), blue: CGFloat(202/255.0), alpha: CGFloat(1.0))
    static let defaultFont = UIFont(name: "Montserrat", size: 13)
    static let regularFont = "Montserrat"
    static let boldFont    = "Montserrat-Bold"
    static let navBarFont  = UIFont(name: "Montserrat-Bold", size: 15)
    static let tabBarFont  = UIFont(name: "Montserrat-Regular", size: 10)
    static let tabBarFontSelected  = UIFont(name: "Montserrat-Bold", size: 10)
    static let navBarButtonFont  = UIFont(name: "Montserrat-Regular", size: 10)

    
    struct Font {
        struct Cell {
            static let title = UIFont(name: "Montserrat-SemiBold", size: 15)
            static let subtitle = UIFont(name: "Montserrat-Light", size: 15)
            static let description = UIFont(name: "Montserrat", size: 12)
            static let boldBigTitle = UIFont(name: "Montserrat-Bold", size: 24)
            static let boldTitle = UIFont(name: "Montserrat-Bold", size: 13)
            static let normalSubtitle = UIFont(name: "Montserrat", size: 13)
        }
    }
    
}


