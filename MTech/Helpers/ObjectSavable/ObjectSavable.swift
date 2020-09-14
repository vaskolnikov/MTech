//
//  ObjectSavable.swift
//  Makas
//
//  Created by Adem Özsayın on 16.04.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}
