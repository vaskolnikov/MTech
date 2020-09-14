//
//  ObjectSavableError.swift
//  Makas
//
//  Created by Adem Özsayın on 16.04.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

enum ObjectSavableError: String, Error {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var localizedDescription: String {
        rawValue
    }
}
