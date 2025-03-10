//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-11-18.
//

import Foundation.NSBundle
import Foundation.NSData
import Foundation.NSJSONSerialization

public extension JSONDecoder {
    /// Decodes an instance of the indicated type.
    ///
    /// - Parameters:
    ///   - type: The type to decode.
    ///   - string: The string representation of the JSON object.
    func decode<T: Decodable>(_ type: T.Type, from string: String) throws -> T {
        guard let data = string.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Could not encode data from string."
                )
            )
        }

        return try decode(type, from: data)
    }
}

public extension JSONDecoder {
    /// Decodes an instance of the indicated type.
    /// 
    /// - Parameters:
    ///   - type: The type to decode.
    ///   - name: The name of the embedded resource.
    ///   - ext: The extension of the resource file.
    ///   - bundle: The bundle of the embedded resource.
    func decode<T>(
        _ type: T.Type,
        forResource name: String,
        inBundle bundle: Bundle
    ) throws -> T where T: Decodable {
        let path = URL(fileURLWithPath: name)
        let file = path.deletingPathExtension().lastPathComponent
        let ext = path.pathExtension

        guard let url = bundle.url(forResource: file, withExtension: ext) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Could not find the resource."
                )
            )
        }

        return try decode(type, from: Data(contentsOf: url, options: .mappedIfSafe))
    }
}
