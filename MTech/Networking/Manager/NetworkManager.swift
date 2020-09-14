//
//  NetworkManager1.swift
//  Makas
//
//  Created by Adem Özsayın on 23.02.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    
    static let environment : PharmacyNetworkEnvironment = .staging
    let pharmacyRouter = Router<PharmacyApi>()
    let cityRouter = Router<CityApi>()

    func sendRequest<T>(route: PharmacyApi, _ type: T.Type, _ completion: @escaping ((ResponseModel<T>?, String?) -> Void)) {
        pharmacyRouter.request(route) { (data, response, error) in
             if error != nil {
                completion(nil, error!.localizedDescription)
                self.printIfDebug("-------------")
                self.printIfDebug("error: \(error.debugDescription)")

           }

           if let response = response as? HTTPURLResponse {
               let result = self.handleNetworkResponse(response)
               switch result {
               case .success:
                   guard let responseData = data else {
                       completion(nil, NetworkResponse.noData.rawValue)
                       return
                   }
                   do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(ResponseModel<T>.self, from: responseData)
                        completion(apiResponse,nil)

                   }catch {
                        //print(error)
                        self.printIfDebug("-------------")
                        self.printIfDebug("error: \(error)")

                       completion(nil, NetworkResponse.unableToDecode.rawValue)
                   }
               case .failure(let networkFailureError):
                   completion(nil, networkFailureError)
               }
           }
        }
    }
    
    func getCities( completion: @escaping (_ city: [City]?,_ error: String?)->()){
        cityRouter.request(.getCities) { (data, response, error) in
            if error != nil {
                //completion(nil, "Please check your network connection.")
                completion(nil, error?.localizedDescription)

            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(CityResponseModel.self, from: responseData)
                        completion(apiResponse.data,nil)


                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }


    func printIfDebug(_ string: String) {
        #if DEBUG
        print(string)
        #endif
    }
    
   
  
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
