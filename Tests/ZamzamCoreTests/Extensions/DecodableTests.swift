//
//  DecodableTests.swift
//  ZamzamCore
//
//  Created by Basem Emara on 2019-05-13.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import XCTest
import ZamzamCore

final class DecodableTests: XCTestCase {
    private let jsonDecoder = JSONDecoder()
}

extension DecodableTests {
    func testFromString() throws {
        // Given
        struct TestModel: Decodable {
            let string: String
            let integer: Int
        }

        let jsonString = """
        {
            "string": "Abc",
            "integer": 123,
        }
        """

        // When
        let model = try jsonDecoder.decode(TestModel.self, from: jsonString)

        // Then
        XCTAssertEqual(model.string, "Abc")
        XCTAssertEqual(model.integer, 123)
    }
}

extension DecodableTests {
    func testInBundle() throws {
        // Given
        struct TestModel: Decodable {
            let string: String
            let integer: Int
        }

        // When
        let model = try jsonDecoder.decode(
            TestModel.self,
            forResource: "TestModel.json",
            inBundle: .module
        )

        // Then
        XCTAssertEqual(model.string, "Abc")
        XCTAssertEqual(model.integer, 123)
    }
}

extension DecodableTests {
    func testAnyDecodable() throws {
        // Given
        let jsonString = """
        {
            "code": "post_does_not_exist",
            "message": "The post you are looking for does not exist.",
            "data": {
                "boolean": true,
                "integer": 1,
                "double": 3.14159265358979323846,
                "string": "string",
                "date": "2019-06-01T12:31:58+00:00",
                "array": [1, 2, 3],
                "nested": {
                    "a": "alpha",
                    "b": "bravo",
                    "c": "charlie"
                }
            }
        }
        """

        guard let data = jsonString.data(using: .utf8) else {
            return XCTFail("Bad JSON format")
        }

        // Type used for decoding the server payload
        struct ServerResponse: Decodable {
            let code: String
            let message: String
            let data: [String: AnyDecodable]?
        }

        let decoder = JSONDecoder().apply {
            $0.dateDecodingStrategy = .formatted(.init(iso8601Format: "yyyy-MM-dd'T'HH:mm:ssZ"))
        }

        // When
        let payload = try decoder.decode(ServerResponse.self, from: data)

        // Then
        XCTAssertEqual(try XCTUnwrap((payload.data?["boolean"])?.value as? Bool), true)
        XCTAssertEqual(try XCTUnwrap((payload.data?["integer"])?.value as? Int), 1)
        XCTAssertEqual(try XCTUnwrap((payload.data?["double"])?.value as? Double), 3.14159265358979323846, accuracy: 0.001)
        XCTAssertEqual(try XCTUnwrap((payload.data?["string"])?.value as? String), "string")
        XCTAssertEqual(try XCTUnwrap((payload.data?["date"])?.value as? Date), Date(timeIntervalSince1970: 1559392318))
        XCTAssertEqual(try XCTUnwrap((payload.data?["array"])?.value as? [Int]), [1, 2, 3])
        XCTAssertEqual(
            try XCTUnwrap((payload.data?["nested"])?.value as? [String: String]),
            ["a": "alpha", "b": "bravo", "c": "charlie"]
        )
    }
}
