//
//  CityEndpoints.swift
//  MTech
//
//  Created by Adem Özsayın on 13.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

enum CityNetworkEnvironment {
    case qa
    case production
    case staging
}

public enum CityApi {
    
    case getCities
}

extension CityApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://fiable.app/api/"
        case .qa: return "https://fiable.app/api/"
        case .staging: return "https://fiable.app/api/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
       
        case .getCities:
            return "Shop/GetCities"
     
     

        }
    }
    
    var httpMethod: HTTPMethod {
         return .post
    }
    
    var task: HTTPTask {
        switch self {

        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


