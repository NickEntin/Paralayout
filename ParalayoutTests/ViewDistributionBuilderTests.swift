//
//  Copyright © 2024 Square, Inc.
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

#if swift(>=5.4)
final class ViewDistributionBuilderTests: XCTestCase {

    // MARK: - Tests

    @MainActor
    func testSimpleResultBuilder() throws {
        let view = UIView()
        XCTAssertEqual(
            viewDistribution({
                ViewDistributionItem.fixed(8)
                ViewDistributionItem.view(view, .zero)
                ViewDistributionItem.flexible(1)
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(8),
                ViewDistributionItem.view(view, .zero),
                ViewDistributionItem.flexible(1),
            ].map { $0.distributionItem }
        )
    }

    @MainActor
    func testIfTrueResultBuilder() throws {
        let view = UIView()
        let condition = true
        XCTAssertEqual(
            viewDistribution({
                ViewDistributionItem.fixed(8)
                if condition {
                    ViewDistributionItem.view(view, .zero)
                }
                ViewDistributionItem.flexible(1)
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(8),
                ViewDistributionItem.view(view, .zero),
                ViewDistributionItem.flexible(1),
            ].map { $0.distributionItem }
        )
    }

    @MainActor
    func testIfFalseResultBuilder() throws {
        let view = UIView()
        let condition = false
        XCTAssertEqual(
            viewDistribution({
                ViewDistributionItem.fixed(8)
                if condition {
                    ViewDistributionItem.view(view, .zero)
                }
                ViewDistributionItem.flexible(1)
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(8),
                ViewDistributionItem.flexible(1),
            ].map { $0.distributionItem }
        )
    }

    @MainActor
    func testIfElseFirstBranchResultBuilder() throws {
        let view = UIView()
        view.tag = 1
        let otherView = UIView()
        otherView.tag = 2
        let condition = true
        XCTAssertEqual(
            viewDistribution({
                ViewDistributionItem.fixed(8)
                if condition {
                    ViewDistributionItem.view(view, .zero)
                } else {
                    ViewDistributionItem.view(otherView, .zero)
                }
                ViewDistributionItem.flexible(1)
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(8),
                ViewDistributionItem.view(view, .zero),
                ViewDistributionItem.flexible(1),
            ].map { $0.distributionItem }
        )
    }

    @MainActor
    func testIfElseSecondBranchResultBuilder() throws {
        let view = UIView()
        view.tag = 1
        let otherView = UIView()
        otherView.tag = 2
        let condition = false
        XCTAssertEqual(
            viewDistribution({
                ViewDistributionItem.fixed(8)
                if condition {
                    ViewDistributionItem.view(view, .zero)
                } else {
                    ViewDistributionItem.view(otherView, .zero)
                }
                ViewDistributionItem.flexible(1)
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(8),
                ViewDistributionItem.view(otherView, .zero),
                ViewDistributionItem.flexible(1),
            ].map { $0.distributionItem }
        )
    }

    @MainActor
    func testSwitchCaseResultBuilder() throws {
        let view = UIView()
        let value = 1
        XCTAssertEqual(
            viewDistribution({
                ViewDistributionItem.fixed(8)
                switch value {
                case 1:
                    view
                default:
                    nil
                }
                ViewDistributionItem.flexible(1)
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(8),
                ViewDistributionItem.view(view, .zero),
                ViewDistributionItem.flexible(1),
            ].map { $0.distributionItem }
        )
    }

    @MainActor
    func testSwitchDefaultResultBuilder() throws {
        let view = UIView()
        let value = 2
        XCTAssertEqual(
            viewDistribution({
                ViewDistributionItem.fixed(8)
                switch value {
                case 1:
                    view
                default:
                    nil
                }
                ViewDistributionItem.flexible(1)
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(8),
                ViewDistributionItem.flexible(1),
            ].map { $0.distributionItem }
        )
    }

    @MainActor
    func testForLoopResultBuilder() throws {
        XCTAssertEqual(
            viewDistribution({
                for fixed in 1...5 {
                    ViewDistributionItem.fixed(CGFloat(fixed))
                }
            }).map { $0.distributionItem },
            [
                ViewDistributionItem.fixed(1),
                ViewDistributionItem.fixed(2),
                ViewDistributionItem.fixed(3),
                ViewDistributionItem.fixed(4),
                ViewDistributionItem.fixed(5),
            ].map { $0.distributionItem }
        )
    }

    // MARK: - Private Methods

    @MainActor
    private func viewDistribution(@ViewDistributionBuilder _ builder: () -> [ViewDistributionSpecifying]) -> [ViewDistributionSpecifying] {
        builder()
    }
}
#endif

extension ViewDistributionItem: Swift.Equatable { // TODO: `@retroactive Equatable` once we drop Xcode 15 support.
    nonisolated
    public static func == (lhs: ViewDistributionItem, rhs: ViewDistributionItem) -> Bool {
        switch (lhs, rhs) {
        case let (.view(lhsView, lhsEdgeInsets), .view(rhsView, rhsEdgeInsets)):
            lhsView === rhsView
            && lhsEdgeInsets == rhsEdgeInsets
        case let (.fixed(lhsFixed), .fixed(rhsFixed)):
            lhsFixed == rhsFixed
        case let (.flexible(lhsFlexible), .flexible(rhsFlexible)):
            lhsFlexible == rhsFlexible
        case let (.flexibleProxy(lhsProxy), .flexibleProxy(rhsProxy)):
            lhsProxy === rhsProxy
        case (.view, _),
            (.fixed, _),
            (.flexible, _),
            (.flexibleProxy, _):
            false
        }
    }
}
