//
//  NetworkTests.swift
//  ZamzamCoreTests
//
//  Created by Basem Emara on 2020-03-02.
//  Copyright © 2021 Zamzam Inc. All rights reserved.
//

import XCTest
@testable import ZamzamCore

final class DecodingStrategyTests: XCTestCase {}

extension DecodingStrategyTests {
    func testSnakeCase() throws {
        // Given
        struct Example: SnakeCaseKeyDecodable {
            let abcDef: String
            let baseUrl: URL
            let onceUponATime: String
            let xyz: Int
        }

        let json = try XCTUnwrap(
            """
             {
                "abc_def": "hij",
                "base_url": "https://example.com",
                "once_upon_a_tiMe": "the fox jumped over the hill",
                "xyz": 5
             }
             """.data(using: .utf8)
        )

        // When
        let decoder = JSONDecoder.make(for: Example.self)
        let object = try decoder.decode(Example.self, from: json)

        // Then
        XCTAssertEqual(object.abcDef, "hij")
        XCTAssertEqual(object.baseUrl.absoluteString, "https://example.com")
        XCTAssertEqual(object.onceUponATime, "the fox jumped over the hill")
        XCTAssertEqual(object.xyz, 5)
    }
}

extension DecodingStrategyTests {
    func testISO8601Date() throws {
        // Given
        struct Example: ISO8601DateDecodable {
            let date: Date
        }

        let json = try XCTUnwrap(
            #"{"date": "2021-02-25T05:34:47.4747+00:00"}"#.data(using: .utf8)
        )

        // When
        let decoder = JSONDecoder.make(for: Example.self)
        let object = try decoder.decode(Example.self, from: json)

        // Then
        XCTAssertEqual(object.date.timeIntervalSince1970, 1614231287.474)
    }
}

extension DecodingStrategyTests {
    func testZuluDate() throws {
        // Given
        struct Example: ZuluDateDecodable {
            let date: Date
        }

        let json = try XCTUnwrap(
            #"{"date": "2021-02-03T20:19:55.317Z"}"#.data(using: .utf8)
        )

        // When
        let decoder = JSONDecoder.make(for: Example.self)
        let object = try decoder.decode(Example.self, from: json)

        // Then
        XCTAssertEqual(object.date.timeIntervalSince1970, 1612383595.317)
    }
}

extension DecodingStrategyTests {
    func testSnakeCaseAndISO8601Date() throws {
        // Given
        struct Example: SnakeCaseKeyDecodable, ISO8601DateDecodable {
            let abcDef: String
            let date: Date
        }

        let json = try XCTUnwrap(
            """
             {
                "abc_def": "hij",
                "date": "2021-02-25T05:34:47.4747+00:00"
             }
             """.data(using: .utf8)
        )

        // When
        let decoder = JSONDecoder.make(for: Example.self)
        let object = try decoder.decode(Example.self, from: json)

        // Then
        XCTAssertEqual(object.abcDef, "hij")
        XCTAssertEqual(object.date.timeIntervalSince1970, 1614231287.474)
    }
}
