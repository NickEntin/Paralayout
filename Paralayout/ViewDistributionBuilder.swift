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

#if swift(>=5.4)
@resultBuilder @MainActor
public struct ViewDistributionBuilder {

    // Build expressions, which are turned into partial results.

    public static func buildExpression(_ component: ViewDistributionItem) -> [ViewDistributionItem] {
        return [component]
    }
    public static func buildExpression(_ component: ViewDistributionItem?) -> [ViewDistributionItem] {
        return [component].compactMap { $0 }
    }
    public static func buildExpression(_ component: [ViewDistributionItem]) -> [ViewDistributionItem] {
        return component
    }
    public static func buildExpression(_ component: [ViewDistributionItem?]) -> [ViewDistributionItem] {
        return component.compactMap { $0 }
    }

    public static func buildExpression(_ component: Alignable) -> [ViewDistributionItem] {
        return [distributionItem(from: component)]
    }
    public static func buildExpression(_ component: Alignable?) -> [ViewDistributionItem] {
        return [component.map(distributionItem(from:))].compactMap { $0 }
    }
    public static func buildExpression(_ component: [Alignable]) -> [ViewDistributionItem] {
        return component.map(distributionItem(from:))
    }
    public static func buildExpression(_ component: [Alignable?]) -> [ViewDistributionItem] {
        return component.compactMap { $0.map(distributionItem(from:)) }
    }

    public static func buildExpression(_ component: FlexibleDistributionProxy) -> [ViewDistributionItem] {
        return [.flexibleProxy(component)]
    }
    public static func buildExpression(_ component: FlexibleDistributionProxy?) -> [ViewDistributionItem] {
        return [component].compactMap { $0.map{ .flexibleProxy($0) } }
    }
    public static func buildExpression(_ component: [FlexibleDistributionProxy]) -> [ViewDistributionItem] {
        return component.map { .flexibleProxy($0) }
    }
    public static func buildExpression(_ component: [FlexibleDistributionProxy?]) -> [ViewDistributionItem] {
        return component.compactMap { $0.map { .flexibleProxy($0) } }
    }

    public static func buildExpression(_ component: FixedDistributionProxy) -> [ViewDistributionItem] {
        return [.fixedProxy(component)]
    }
    public static func buildExpression(_ component: FixedDistributionProxy?) -> [ViewDistributionItem] {
        return component.map { [.fixedProxy($0)] } ?? []
    }
    public static func buildExpression(_ component: [FixedDistributionProxy]) -> [ViewDistributionItem] {
        return component.map { .fixedProxy($0) }
    }
    public static func buildExpression(_ component: [FixedDistributionProxy?]) -> [ViewDistributionItem] {
        return component.compactMap { $0.map { .fixedProxy($0) } }
    }

    // Build partial results, which accumulate.

    public static func buildPartialBlock(first: ViewDistributionItem) -> [ViewDistributionItem] {
        return [first]
    }
    public static func buildPartialBlock(first: [ViewDistributionItem]) -> [ViewDistributionItem] {
        return first
    }
    public static func buildPartialBlock(accumulated: ViewDistributionItem, next: ViewDistributionItem) -> [ViewDistributionItem] {
        return [accumulated, next]
    }
    public static func buildPartialBlock(accumulated: ViewDistributionItem, next: [ViewDistributionItem]) -> [ViewDistributionItem] {
        return [accumulated] + next
    }
    public static func buildPartialBlock(accumulated: [ViewDistributionItem], next: ViewDistributionItem) -> [ViewDistributionItem] {
        return accumulated + [next]
    }
    public static func buildPartialBlock(accumulated: [ViewDistributionItem], next: [ViewDistributionItem]) -> [ViewDistributionItem] {
        return accumulated + next
    }

    // Build if statements

    public static func buildOptional(_ component: [ViewDistributionItem]?) -> [ViewDistributionItem] {
        return component ?? []
    }
    public static func buildOptional(_ component: [ViewDistributionItem]) -> [ViewDistributionItem] {
        return component
    }

    // Build if-else and switch statements

    public static func buildEither(first component: [ViewDistributionItem]) -> [ViewDistributionItem] {
        return component
    }
    public static func buildEither(second component: [ViewDistributionItem]) -> [ViewDistributionItem] {
        return component
    }

    // Build for-loop statements

    public static func buildArray(_ components: [[ViewDistributionItem]]) -> [ViewDistributionItem] {
        return components.flatMap { $0 }
    }

    // Build the blocks that turn into results.

    public static func buildBlock(_ components: [ViewDistributionItem]...) -> [ViewDistributionItem] {
        return components.flatMap { $0 }
    }

    // MARK: Private

    private static func distributionItem(from alignable: Alignable) -> ViewDistributionItem {
        let context = alignable.alignmentContext
        let view = context.view
        let alignmentBounds = context.alignmentBounds
        return ViewDistributionItem.view(
            view,
            .init(
                top: alignmentBounds.minY - view.bounds.minY,
                left: alignmentBounds.minX - view.bounds.minX,
                bottom: view.bounds.maxY - alignmentBounds.maxY,
                right: view.bounds.maxX - alignmentBounds.maxX,
            ),
        )
    }
}
#endif
