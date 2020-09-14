//
//  ShopEndPoint.swift
//  Makas
//
//  Created by Adem Özsayın on 22.02.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

enum PharmacyNetworkEnvironment {
    case qa
    case production
    case staging
}

public enum PharmacyApi {
    
    case getPharmacy(city:String, district:String)
    case getDistricts(city:String)


}

extension PharmacyApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.collectapi.com/health/" //production // live
        case .qa: return "https://api.collectapi.com/health/" //Quality Assurance
        case .staging: return "https://api.collectapi.com/health/" //test
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
       
        case .getPharmacy:
            return "dutyPharmacy"
            
       case .getDistricts:
           return "districtList"

        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getPharmacy, .getDistricts:
            return .get
        default:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {

        case .getPharmacy(let city, let district):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: ["il":city, "ilce":district ],
                                                additionHeaders: self.headers)
            
        case .getDistricts(let city):
                return .requestParametersAndHeaders(bodyParameters:  nil,
                                                    bodyEncoding: .jsonEncoding,
                                                    urlParameters: ["il": city],
                                                    additionHeaders: self.headers)
                 
      
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 4dFhX6eZAQ1c9YwPipg18O:2NtiNUmevH9wbluKH2J9LT"
        ]
        switch self {
        case .getPharmacy, .getDistricts:
            return headers
            
        default:
            return nil
        }
        
    }
}


