//
//  Copyright © 2025 Block, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Paralayout
import XCTest

@MainActor
final class ViewSlicingTests: XCTestCase {
    func testSimpleSlicing() throws {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)

        let (slice1, remainder1) = rect.slice(from: .minXEdge, amount: 40)
        XCTAssertEqual(slice1, CGRect(x: 0, y: 0, width: 40, height: 100))
        XCTAssertEqual(remainder1, CGRect(x: 40, y: 0, width: 60, height: 100))

        let (slice2, remainder2) = rect.slice(from: .maxXEdge, amount: 40)
        XCTAssertEqual(slice2, CGRect(x: 60, y: 0, width: 40, height: 100))
        XCTAssertEqual(remainder2, CGRect(x: 0, y: 0, width: 60, height: 100))

        let (slice3, remainder3) = rect.slice(from: .minYEdge, amount: 40)
        XCTAssertEqual(slice3, CGRect(x: 0, y: 0, width: 100, height: 40))
        XCTAssertEqual(remainder3, CGRect(x: 0, y: 40, width: 100, height: 60))

        let (slice4, remainder4) = rect.slice(from: .maxYEdge, amount: 40)
        XCTAssertEqual(slice4, CGRect(x: 0, y: 60, width: 100, height: 40))
        XCTAssertEqual(remainder4, CGRect(x: 0, y: 0, width: 100, height: 60))
    }

    func testSliceWithInvalidAmount() throws {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)

        let (slice1, remainder1) = rect.slice(from: .minXEdge, amount: 120)
        XCTAssertEqual(slice1, CGRect(x: 0, y: 0, width: 120, height: 100))
        XCTAssertEqual(remainder1, CGRect(x: 120, y: 0, width: 0, height: 100))

        let (slice2, remainder2) = rect.slice(from: .maxXEdge, amount: 120)
        XCTAssertEqual(slice2, CGRect(x: -20, y: 0, width: 120, height: 100))
        XCTAssertEqual(remainder2, CGRect(x: -20, y: 0, width: 0, height: 100))

        let (slice3, remainder3) = rect.slice(from: .minYEdge, amount: 120)
        XCTAssertEqual(slice3, CGRect(x: 0, y: 0, width: 100, height: 120))
        XCTAssertEqual(remainder3, CGRect(x: 0, y: 120, width: 100, height: 0))

        let (slice4, remainder4) = rect.slice(from: .maxYEdge, amount: 120)
        XCTAssertEqual(slice4, CGRect(x: 0, y: -20, width: 100, height: 120))
        XCTAssertEqual(remainder4, CGRect(x: 0, y: -20, width: 100, height: 0))
    }
}
