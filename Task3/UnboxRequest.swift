//
//  UnboxRequest.swift
//  Task3
//
//  Created by Vedad Hasanagic on 11/15/16.
//  Copyright © 2016 Vedad H. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

extension DataRequest {
    
    @discardableResult
    public func responseObject<T: Unboxable>(queue: DispatchQueue? = nil, keyPath: String? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.UnboxObjectSerializer(options, keyPath: keyPath), completionHandler: completionHandler)
    }

    @discardableResult
    public func responseArray<T: Unboxable>(queue: DispatchQueue? = nil, keyPath: String? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.UnboxArraySerializer(options, keyPath: keyPath), completionHandler: completionHandler)
    }
}

private extension Request {
    
    static func UnboxObjectSerializer<T: Unboxable>(_ options: JSONSerialization.ReadingOptions, keyPath: String?) -> DataResponseSerializer<T>  {
        return DataResponseSerializer { request, response, data, error in
            if let error = error {
                return .failure(error)
            }
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            
            let convertedData = LineToJsonConverter.convert(data: data!)
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, convertedData, error)
            
            let jsonCandidate: Any?
            if let keyPath = keyPath , !keyPath.isEmpty {
                jsonCandidate = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
            } else {
                jsonCandidate = result.value
            }
            
            guard let json = jsonCandidate as? UnboxableDictionary else {
                return .failure(NetworkSerializationError(description: "Bad data."))
            }
            
            do {
                return .success(try unbox(dictionary: json))
            } catch let unboxError as UnboxError {
                return .failure(NetworkSerializationError(description: unboxError.description))
            } catch let error as NSError {
                return .failure(error)
            }
        }
    }
    
    static func UnboxArraySerializer<T: Unboxable>(_ options: JSONSerialization.ReadingOptions, keyPath: String?) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            if let error = error {
                return .failure(error)
            }
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            
            let convertedData = LineToJsonConverter.convert(data: data!)
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, convertedData, error)
            
            let jsonCandidate: Any?
            if let keyPath = keyPath , !keyPath.isEmpty {
                jsonCandidate = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
            } else {
                jsonCandidate = result.value
            }
            
            guard let json = jsonCandidate as? [UnboxableDictionary] else {
                return .failure(NetworkSerializationError(description: "Bad data."))
            }
            
            do {
                return .success(try map(json))
            } catch let unboxError as UnboxError {
                return .failure(NetworkSerializationError(description: unboxError.description))
            } catch let error as NSError {
                return .failure(error)
            }
        }
    }
}

public struct NetworkSerializationError: Error, CustomStringConvertible {
    
    public let description: String
}

private func map<T: Unboxable>(_ objects: [UnboxableDictionary]) throws -> [T] {
    
    return try objects.reduce([T]()) { container, rawValue in
        let value = try unbox(dictionary: rawValue) as T
        return container + [value]
    }
}
