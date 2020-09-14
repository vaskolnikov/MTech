//
//  City.swift
//  MTech
//
//  Created by Adem Özsayın on 13.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

struct City: Codable, CustomStringConvertible {
    var id: Int?
    var name: String?

    private enum CodingKeys : String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
    //
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    var description: String {
        return "\(self.id ?? 0)"+" "+"\(self.name ?? "")"
     }
}

extension City: Equatable {}

func ==(lhs: City, rhs: City) -> Bool {
    let areEqual = lhs.id == rhs.id &&
        lhs.name == rhs.name

    return areEqual
}

