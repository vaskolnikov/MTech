//
//  Pharmacy.swift
//  MTech
//
//  Created by Adem Özsayın on 12.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation


struct Pharmacy {
    
    let name: String?
    let district: String?
    let address: String?
    let phone:String?
    let location:String?

}

extension Pharmacy: Codable {
    
    enum PharmacyCodingKeys: String, CodingKey {
        case name = "name"
        case district = "dist"
        case address = "address"
        case phone = "phone"
        case location = "loc"
    }
    
    init(from decoder: Decoder) throws {
        
        let shopContainer = try decoder.container(keyedBy: PharmacyCodingKeys.self)
        
        name = try shopContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
        district = try shopContainer.decodeIfPresent(String.self, forKey: .district) ?? ""
        address = try shopContainer.decodeIfPresent(String.self, forKey: .address) ?? ""
        phone = try shopContainer.decodeIfPresent(String.self, forKey: .phone) ?? ""
        location = try shopContainer.decodeIfPresent(String.self, forKey: .location) ?? ""

    }

}

