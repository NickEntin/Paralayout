//
//  Portions of this file are Copyright © 2025 Nick Entin
//  Portions of this file are Copyright © 2024 Square, Inc.
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

import UIKit

@resultBuilder @MainActor
public struct VerticalDistributionBuilder {

    // Build expressions, which are turned into partial results.

    public static func buildExpression(_ component: VerticalDistributionItem) -> [VerticalDistributionItem] {
        return [component]
    }
    public static func buildExpression(_ component: VerticalDistributionItem?) -> [VerticalDistributionItem] {
        return [component].compactMap { $0 }
    }
    public static func buildExpression(_ component: [VerticalDistributionItem]) -> [VerticalDistributionItem] {
        return component
    }
    public static func buildExpression(_ component: [VerticalDistributionItem?]) -> [VerticalDistributionItem] {
        return component.compactMap { $0 }
    }

    public static func buildExpression(_ component: Alignable) -> [VerticalDistributionItem] {
        return [distributionItem(from: component)]
    }
    public static func buildExpression(_ component: Alignable?) -> [VerticalDistributionItem] {
        return [component.map(distributionItem(from:))].compactMap { $0 }
    }
    public static func buildExpression(_ component: [Alignable]) -> [VerticalDistributionItem] {
        return component.map(distributionItem(from:))
    }
    public static func buildExpression(_ component: [Alignable?]) -> [VerticalDistributionItem] {
        return component.compactMap { $0.map(distributionItem(from:)) }
    }

    public static func buildExpression(_ component: FlexibleSpacer) -> [VerticalDistributionItem] {
        return [.flexible(component.weight)]
    }
    public static func buildExpression(_ component: FlexibleSpacer?) -> [VerticalDistributionItem] {
        return [component].compactMap { $0.map{ .flexible($0.weight) } }
    }
    public static func buildExpression(_ component: [FlexibleSpacer]) -> [VerticalDistributionItem] {
        return component.map { .flexible($0.weight) }
    }
    public static func buildExpression(_ component: [FlexibleSpacer?]) -> [VerticalDistributionItem] {
        return component.compactMap { $0.map { .flexible($0.weight) } }
    }

    public static func buildExpression(_ component: FixedSpacer) -> [VerticalDistributionItem] {
        return [.fixed(component.length)]
    }
    public static func buildExpression(_ component: FixedSpacer?) -> [VerticalDistributionItem] {
        return [component].compactMap { $0.map{ .fixed($0.length) } }
    }
    public static func buildExpression(_ component: [FixedSpacer]) -> [VerticalDistributionItem] {
        return component.map { .fixed($0.length) }
    }
    public static func buildExpression(_ component: [FixedSpacer?]) -> [VerticalDistributionItem] {
        return component.compactMap { $0.map { .fixed($0.length) } }
    }

    public static func buildExpression(_ component: FlexibleDistributionProxy) -> [VerticalDistributionItem] {
        return [.flexibleProxy(component)]
    }
    public static func buildExpression(_ component: FlexibleDistributionProxy?) -> [VerticalDistributionItem] {
        return [component].compactMap { $0.map{ .flexibleProxy($0) } }
    }
    public static func buildExpression(_ component: [FlexibleDistributionProxy]) -> [VerticalDistributionItem] {
        return component.map { .flexibleProxy($0) }
    }
    public static func buildExpression(_ component: [FlexibleDistributionProxy?]) -> [VerticalDistributionItem] {
        return component.compactMap { $0.map { .flexibleProxy($0) } }
    }

    public static func buildExpression(_ component: FixedDistributionProxy) -> [VerticalDistributionItem] {
        return [.fixedProxy(component)]
    }
    public static func buildExpression(_ component: FixedDistributionProxy?) -> [VerticalDistributionItem] {
        return component.map { [.fixedProxy($0)] } ?? []
    }
    public static func buildExpression(_ component: [FixedDistributionProxy]) -> [VerticalDistributionItem] {
        return component.map { .fixedProxy($0) }
    }
    public static func buildExpression(_ component: [FixedDistributionProxy?]) -> [VerticalDistributionItem] {
        return component.compactMap { $0.map { .fixedProxy($0) } }
    }

    // Build partial results, which accumulate.

    public static func buildPartialBlock(first: VerticalDistributionItem) -> [VerticalDistributionItem] {
        return [first]
    }
    public static func buildPartialBlock(first: [VerticalDistributionItem]) -> [VerticalDistributionItem] {
        return first
    }
    public static func buildPartialBlock(accumulated: VerticalDistributionItem, next: VerticalDistributionItem) -> [VerticalDistributionItem] {
        return [accumulated, next]
    }
    public static func buildPartialBlock(accumulated: VerticalDistributionItem, next: [VerticalDistributionItem]) -> [VerticalDistributionItem] {
        return [accumulated] + next
    }
    public static func buildPartialBlock(accumulated: [VerticalDistributionItem], next: VerticalDistributionItem) -> [VerticalDistributionItem] {
        return accumulated + [next]
    }
    public static func buildPartialBlock(accumulated: [VerticalDistributionItem], next: [VerticalDistributionItem]) -> [VerticalDistributionItem] {
        return accumulated + next
    }

    // Build if statements

    public static func buildOptional(_ component: [VerticalDistributionItem]?) -> [VerticalDistributionItem] {
        return component ?? []
    }
    public static func buildOptional(_ component: [VerticalDistributionItem]) -> [VerticalDistributionItem] {
        return component
    }

    // Build if-else and switch statements

    public static func buildEither(first component: [VerticalDistributionItem]) -> [VerticalDistributionItem] {
        return component
    }
    public static func buildEither(second component: [VerticalDistributionItem]) -> [VerticalDistributionItem] {
        return component
    }

    // Build for-loop statements

    public static func buildArray(_ components: [[VerticalDistributionItem]]) -> [VerticalDistributionItem] {
        return components.flatMap { $0 }
    }

    // Build the blocks that turn into results.

    public static func buildBlock(_ components: [VerticalDistributionItem]...) -> [VerticalDistributionItem] {
        return components.flatMap { $0 }
    }

    // MARK: Private

    private static func distributionItem(from alignable: Alignable) -> VerticalDistributionItem {
        return VerticalDistributionItem.view(alignable, orthogonalAlignment: nil)
    }
}
