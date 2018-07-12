//
//  APIRouter.swift
//  NetworkingArchitectureExample
//
//  Created by Joel Sene on 4/4/17.
//  Copyright © 2017 Joel Sene. All rights reserved.
//

import Foundation
import Alamofire
import p2_OAuth2

enum APIRouter {
    
    // Aqui vai a URL base das chamadas à API
    static let baseURL = "https://api.github.com/"

	static var loader: OAuth2DataLoader?

    // Aqui são todas as rotas, podem ser passados parâmetros, como: ID, tokens p/ paginação entre outras coisas.
	case gist(gistID: String)
}

extension APIRouter: URLRequestConvertible {
    
    // Esta função constroe a requisição para cada rota
    func asURLRequest() throws -> URLRequest {
        
        // Aqui são definidos o método http para cada rota.
        var method: HTTPMethod {
            switch self {
            case .gist:
                return .post
            }
        }
        
        // Aqui são os parâmetros para cada rota, caso não tenha parâmetro retorne nil.
        var params: [String: Any]? {
            switch self {
            case .gist:
                return nil
            }
        }
        
        // Aqui é a URL para cada rota.
        var url: URL {
            var relativePath: String
            
            switch self {
            case let .gist(gistID):
                relativePath = "gists/\(gistID)"
            }
            
            var url = URL(string: APIRouter.baseURL)!
            url.appendPathComponent(relativePath)
            return url
        }
        
        // Aqui é o token de autenticação da API, caso a rota não precise de autenticação, retorne nil.
        var authToken: String? {
            switch self {
            default:
                return "Basic T0FQUkRfT0FQUkRfTU9CSUxFX0FOT05ZTU9VU19BUFBJRDp5bjY3dHN5YnVwX2xQaA=="
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("vnd.github.VERSION.base64", forHTTPHeaderField: "Content-Type")
        
        if let authToken = authToken {
            urlRequest.addValue(authToken, forHTTPHeaderField: "Authorization")
        }
        
        // O encoding define como os parâmetros serão enviados.
        // JSONEncoding = Enviados no Body da requisição como JSON
        // URLEncoding = Enviados como parâmetros de URL.
        var encoding: ParameterEncoding {
            switch self {
            case .gist:
                return JSONEncoding.default
            }
        }
        return try encoding.encode(urlRequest, with: params)
    }
    
}
