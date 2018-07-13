//
//  APIManager.swift
//  NetworkingArchitectureExample
//
//  Created by Joel Sene on 4/4/17.
//  Copyright © 2017 Joel Sene. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

// Esta enumeração define todos os erros que a API pode retornar.
// Não devemos retornar um erro genérico, sempre um error específico.
enum APIError: Error {
    case http(Error)
    case custom(reason: String)
    case objectSerialization(reason: String)
    case noInternetConnection
}

enum APIResult<T> {
    case success(T)
    case failure(APIError)
}

protocol APIManagerProtocol {
    func requestObject<T: Mappable>(_ router: APIRouter, completion: @escaping (APIResult<T>) -> Void)
}

// Estrutura resposável por realizar a requisição
struct APIManager: APIManagerProtocol {
    
    func requestObject<T: Mappable>(_ router: APIRouter, completion: @escaping (APIResult<T>) -> Void) {
        Alamofire.request(router).validate().responseJSON { response in
            if let error = self.checkHttpError(in: response) {
                completion(.failure(error))
                return
            }
                
            guard let json = response.result.value as? [String: Any] else {
                completion(.failure(APIError.objectSerialization(reason: "Did not get valid JSON in response.")))
                return
            }
            
            if let errorResponse = Mapper<APIErrorResponse>().map(JSON: json),
                let message = errorResponse.message {
                completion(.failure(APIError.custom(reason: message)))
                return
            }
            
            guard let result = Mapper<T>().map(JSON: json) else {
                completion(.failure(APIError.objectSerialization(reason: "Could not serialize JSON into object.")))
                return
            }
            
            completion(.success(result))
        }
    }

    func requestArray<T: Mappable>(_ router: APIRouter, completion: @escaping (([T]?, APIError?) -> Void)) {
        Alamofire.request(router).responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Error: \(String(describing: response.error))")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data Parsed: \(utf8Text)")
            }
            
            if let error = response.result.error {
                completion(nil, APIError.http(error))
                return
            }
            
            if let json = response.result.value as? [String: Any] {
                if let errorResponse = Mapper<APIErrorResponse>().map(JSON: json),
                    let message = errorResponse.message {
                    completion(nil, APIError.custom(reason: message))
                    return
                }
            }
            
            guard let jsonArray = response.result.value as? [[String: Any]] else {
                completion(nil, APIError.objectSerialization(reason: "Did not get valid JSON in response."))
                return
            }
            
            guard let result = Mapper<T>().mapArray(JSONArray: jsonArray) else {
                completion(nil, APIError.objectSerialization(reason: "Could not serialized JSON into object."))
                return
            }
            
            completion(result, nil)
        }
    }
    
    private func checkHttpError(in response: DataResponse<Any>) -> APIError? {
        if let error = response.result.error {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                return APIError.noInternetConnection
            }
            return APIError.http(error)
        }
        return nil
    }
    
}
