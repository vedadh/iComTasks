//
//  PeopleRouter.swift
//  Task3
//
//  Created by Vedad Hasanagic on 11/15/16.
//  Copyright © 2016 Vedad H. All rights reserved.
//

import Foundation
import Alamofire

enum PeopleRouter: URLRequestConvertible {
    static let baseURLString = "https://gist.githubusercontent.com"
    
    case Get
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .Get:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .Get:
                return (nil)
            }
        }()
        
        let url:URL = {
            let relativePath:String?
            switch self {
            case .Get:
                relativePath = "brianw/19896c50afa89ad4dec3/raw/6c11047887a03483c50017c1d451667fd62a53ca/gistfile1.txt"
            }
            
            var newUrl = URL(string: PeopleRouter.baseURLString)!
            if let relativePath = relativePath {
                newUrl = newUrl.appendingPathComponent(relativePath)
            }
            return newUrl as URL
        }()
        
        let request = URLRequest(url: url)
        
        let encoding = Alamofire.JSONEncoding()
        var encodedRequest = try encoding.encode(request, with: params)
        
        encodedRequest.httpMethod = method.rawValue
        
        return encodedRequest
    }
}
