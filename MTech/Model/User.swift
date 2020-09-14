//
//  User.swift
//  MTech
//
//  Created by Adem Özsayın on 13.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable {
    
    var username: String?
    var lastName: String?
    var password: String?
    var email: String?
    var image:UIImage?


    private enum CodingKeys : String, CodingKey {
        
        case username = "Username"
        case email = "Email"
        case lastName
        case password
        case image


    }
//
    init( username: String?, email: String?, lastName: String?, password: String?) {
        self.username = username
        self.email = email
        
        self.lastName = lastName
        self.password = password



    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decodeIfPresent(String.self, forKey: .email)  ?? ""

        
        lastName = try container.decode(String.self, forKey: .lastName)
        password = try container.decode(String.self, forKey: .password)


    }
    

    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
       
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        
        try container.encode(lastName, forKey: .lastName)
        try container.encode(password, forKey: .password)

                
    }

}



extension User {
   
    private static let currentUserKey = "CurrentUser"
    
    static func currentUser() -> User? {

        guard let userData = UserDefaults.standard.data(forKey: currentUserKey) else { return nil }
        return User.from(data: userData)

    }
 
    static func loggedIn() -> Bool {
        return currentUser() != nil
    }


    static func saveUser(user: User) {

        let userDefaults = UserDefaults.standard
        do {
            //let jsonData = try JSONEncoder().encode(user)
           try userDefaults.setObject(user, forKey: currentUserKey)
        } catch {
           print((error as! ObjectSavableError).localizedDescription)
        }
    }

    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
        UserDefaults.standard.synchronize()
    }
    
    
}


extension UserDefaults {
    func imageForKey(key: String) -> UIImage? {
        //var image: UIImage?
        var image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: Global.appColor, size: CGSize(width: 30, height: 30))
        if let imageData = data(forKey: key) {
            image = (NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage)!
        }
        return image
    }
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
}
