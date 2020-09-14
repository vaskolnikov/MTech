//
//  ResponseModel.swift
//  MTech
//
//  Created by Adem Özsayın on 12.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
    
    // MARK: - Properties
    var success: Bool
    var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "result"
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        success = (try? keyedContainer.decode(Bool.self, forKey: CodingKeys.success)) ?? false
        data = try? keyedContainer.decode(T.self, forKey: CodingKeys.data)
    }
}

struct CityResponseModel:Codable {
    
    // MARK: - Properties
    var success: Int
    var message: String
    let id: Int
    var data: [City]?
    
    private enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
        case id = "Id"
        case data = "Data"
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? keyedContainer.decode(Int.self, forKey: CodingKeys.id)) ?? 0
        success = (try? keyedContainer.decode(Int.self, forKey: CodingKeys.success)) ?? 0
        message = (try? keyedContainer.decode(String.self, forKey: CodingKeys.message)) ?? ""
        data = try? keyedContainer.decode([City].self, forKey: CodingKeys.data) ?? []
    }
}
