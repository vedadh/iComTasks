//
//  LineToJsonConverter.swift
//  Task3
//
//  Created by Vedad Hasanagic on 11/12/16.
//  Copyright © 2016 Vedad H. All rights reserved.
//

import Foundation

public struct LineToJsonConverter {
    
    public static func convert(data: Data) -> Data? {
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        return self.convert(string: string)
    }
    
    public static func convert(string: String) -> Data? {
        if string.characters.count == 0  { return "{ }".data(using: .utf8) }
        
        var jsonBuffer = "["
        string.enumerateLines { (line, done) in
            jsonBuffer.append("\(line),")
        }
        if let comma = jsonBuffer.characters.last {
            if [","].contains(comma) {
                jsonBuffer.characters.removeLast()
            }
        }
        jsonBuffer.append("]")
        return jsonBuffer.data(using: .utf8)
    }
    
}
