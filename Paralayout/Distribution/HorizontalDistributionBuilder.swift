//
//  Copyright © 2025 Nick Entin
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

#if swift(>=5.4)
@resultBuilder @MainActor
public struct HorizontalDistributionBuilder {

    // Build expressions, which are turned into partial results.

    public static func buildExpression(_ component: HorizontalDistributionItem) -> [HorizontalDistributionItem] {
        return [component]
    }
    public static func buildExpression(_ component: HorizontalDistributionItem?) -> [HorizontalDistributionItem] {
        return [component].compactMap { $0 }
    }
    public static func buildExpression(_ component: [HorizontalDistributionItem]) -> [HorizontalDistributionItem] {
        return component
    }
    public static func buildExpression(_ component: [HorizontalDistributionItem?]) -> [HorizontalDistributionItem] {
        return component.compactMap { $0 }
    }

    public static func buildExpression(_ component: Alignable) -> [HorizontalDistributionItem] {
        return [distributionItem(from: component)]
    }
    public static func buildExpression(_ component: Alignable?) -> [HorizontalDistributionItem] {
        return [component.map(distributionItem(from:))].compactMap { $0 }
    }
    public static func buildExpression(_ component: [Alignable]) -> [HorizontalDistributionItem] {
        return component.map(distributionItem(from:))
    }
    public static func buildExpression(_ component: [Alignable?]) -> [HorizontalDistributionItem] {
        return component.compactMap { $0.map(distributionItem(from:)) }
    }

    public static func buildExpression(_ component: FlexibleSpacer) -> [HorizontalDistributionItem] {
        return [.flexible(component.weight)]
    }
    public static func buildExpression(_ component: FlexibleSpacer?) -> [HorizontalDistributionItem] {
        return [component].compactMap { $0.map{ .flexible($0.weight) } }
    }
    public static func buildExpression(_ component: [FlexibleSpacer]) -> [HorizontalDistributionItem] {
        return component.map { .flexible($0.weight) }
    }
    public static func buildExpression(_ component: [FlexibleSpacer?]) -> [HorizontalDistributionItem] {
        return component.compactMap { $0.map { .flexible($0.weight) } }
    }

    public static func buildExpression(_ component: FixedSpacer) -> [HorizontalDistributionItem] {
        return [.fixed(component.length)]
    }
    public static func buildExpression(_ component: FixedSpacer?) -> [HorizontalDistributionItem] {
        return [component].compactMap { $0.map{ .fixed($0.length) } }
    }
    public static func buildExpression(_ component: [FixedSpacer]) -> [HorizontalDistributionItem] {
        return component.map { .fixed($0.length) }
    }
    public static func buildExpression(_ component: [FixedSpacer?]) -> [HorizontalDistributionItem] {
        return component.compactMap { $0.map { .fixed($0.length) } }
    }

    public static func buildExpression(_ component: FlexibleDistributionProxy) -> [HorizontalDistributionItem] {
        return [.flexibleProxy(component)]
    }
    public static func buildExpression(_ component: FlexibleDistributionProxy?) -> [HorizontalDistributionItem] {
        return [component].compactMap { $0.map{ .flexibleProxy($0) } }
    }
    public static func buildExpression(_ component: [FlexibleDistributionProxy]) -> [HorizontalDistributionItem] {
        return component.map { .flexibleProxy($0) }
    }
    public static func buildExpression(_ component: [FlexibleDistributionProxy?]) -> [HorizontalDistributionItem] {
        return component.compactMap { $0.map { .flexibleProxy($0) } }
    }

    public static func buildExpression(_ component: FixedDistributionProxy) -> [HorizontalDistributionItem] {
        return [.fixedProxy(component)]
    }
    public static func buildExpression(_ component: FixedDistributionProxy?) -> [HorizontalDistributionItem] {
        return component.map { [.fixedProxy($0)] } ?? []
    }
    public static func buildExpression(_ component: [FixedDistributionProxy]) -> [HorizontalDistributionItem] {
        return component.map { .fixedProxy($0) }
    }
    public static func buildExpression(_ component: [FixedDistributionProxy?]) -> [HorizontalDistributionItem] {
        return component.compactMap { $0.map { .fixedProxy($0) } }
    }

    // Build partial results, which accumulate.

    public static func buildPartialBlock(first: HorizontalDistributionItem) -> [HorizontalDistributionItem] {
        return [first]
    }
    public static func buildPartialBlock(first: [HorizontalDistributionItem]) -> [HorizontalDistributionItem] {
        return first
    }
    public static func buildPartialBlock(accumulated: HorizontalDistributionItem, next: HorizontalDistributionItem) -> [HorizontalDistributionItem] {
        return [accumulated, next]
    }
    public static func buildPartialBlock(accumulated: HorizontalDistributionItem, next: [HorizontalDistributionItem]) -> [HorizontalDistributionItem] {
        return [accumulated] + next
    }
    public static func buildPartialBlock(accumulated: [HorizontalDistributionItem], next: HorizontalDistributionItem) -> [HorizontalDistributionItem] {
        return accumulated + [next]
    }
    public static func buildPartialBlock(accumulated: [HorizontalDistributionItem], next: [HorizontalDistributionItem]) -> [HorizontalDistributionItem] {
        return accumulated + next
    }

    // Build if statements

    public static func buildOptional(_ component: [HorizontalDistributionItem]?) -> [HorizontalDistributionItem] {
        return component ?? []
    }
    public static func buildOptional(_ component: [HorizontalDistributionItem]) -> [HorizontalDistributionItem] {
        return component
    }

    // Build if-else and switch statements

    public static func buildEither(first component: [HorizontalDistributionItem]) -> [HorizontalDistributionItem] {
        return component
    }
    public static func buildEither(second component: [HorizontalDistributionItem]) -> [HorizontalDistributionItem] {
        return component
    }

    // Build for-loop statements

    public static func buildArray(_ components: [[HorizontalDistributionItem]]) -> [HorizontalDistributionItem] {
        return components.flatMap { $0 }
    }

    // Build the blocks that turn into results.

    public static func buildBlock(_ components: [HorizontalDistributionItem]...) -> [HorizontalDistributionItem] {
        return components.flatMap { $0 }
    }

    // MARK: Private

    private static func distributionItem(from alignable: Alignable) -> HorizontalDistributionItem {
        return HorizontalDistributionItem.view(alignable)
    }
}
#endif
