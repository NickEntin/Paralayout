//
//  Portions of this file are Copyright © 2025 Nick Entin
//  Portions of this file are Copyright © 2021 Square, Inc.
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

public typealias HorizontalDistribution = [HorizontalDistributionItem]

extension HorizontalDistribution {
    public init(@HorizontalDistributionBuilder _ distribution: () -> HorizontalDistribution) {
        self = distribution()
    }
}

// MARK: -

/// An element of a horizontal distribution.
@MainActor
public enum HorizontalDistributionItem: Sendable {

    /// A UIView, with adjustments to how much space it should take up.
    case view(Alignable, orthogonalAlignment: VerticalDistributionAlignment?)

    /// A constant spacer between two other elements.
    case fixed(CGFloat)

    /// A flexible spacer of a given weight. After accounting for all fixed-size elements and spacers, the remaining
    /// space is allocated among the flexible items (spacers and proxies).
    case flexible(CGFloat)

    /// A flexible layout proxy, which can be used to subsequently perform layout on a smaller portion of a view. After
    /// accounting for all fixed-size elements and spacers, the remaining space is allocated among the flexible items
    /// (spacers and proxies).
    case flexibleProxy(FlexibleDistributionProxy)

    /// A fixed layout proxy, which can be used to subsequently perform layout on a smaller portion of a view.
    case fixedProxy(FixedDistributionProxy)

    // MARK: - Public Properties

    /// Whether or not this item is flexible.
    public var isFlexible: Bool {
        switch self {
        case .view, .fixed, .fixedProxy:
            return false
        case .flexible, .flexibleProxy:
            return true
        }
    }

    // MARK: - Internal Static Methods

    /// Adds implied flexible spacers as necessary.
    ///
    /// * If no spacers (fixed or flexible) or flexible proxies are included, equal flexible spacers are inserted
    ///   between all views.
    /// * If no flexible spacers or proxies are included, two equal flexible spacers ones are added to the beginning and
    ///   end of the distribution.
    ///
    /// - precondition: All views in the `distribution` must be subviews of the `superview`.
    /// - precondition: The `distribution` must not include any given view more than once.
    ///
    /// - returns: An array of `HorizontalDistributionItem`s suitable for layout and/or measurement, and tallies of all fixed
    /// and flexible space.
    internal static func items(
        impliedIn distribution: [HorizontalDistributionItem],
        superview: UIView?
    ) -> (items: [HorizontalDistributionItem], totalFixedSpace: CGFloat, flexibleSpaceDenominator: CGFloat) {
        var distributionItems = [HorizontalDistributionItem]()
        var totalViewSize: CGFloat = 0
        var totalFixedSpace: CGFloat = 0
        var totalFlexibleSpace: CGFloat = 0
        var hasProxy: Bool = false

        var subviewsToDistribute = Set<UIView>()

        for item in distribution {
            let layoutSize = item.layoutSize()

            switch item {
            case let .view(alignable, _):
                let view = alignable.alignmentContext.view

                // Validate the view.
                guard superview == nil || view.superview === superview else {
                    fatalError("\(view) is not a subview of \(String(describing: superview))!")
                }

                guard !subviewsToDistribute.contains(view) else {
                    fatalError("\(view) is included twice in \(distribution)!")
                }

                subviewsToDistribute.insert(view)

                totalViewSize += layoutSize

            case .fixed:
                totalFixedSpace += layoutSize

            case .flexible:
                totalFlexibleSpace += layoutSize

            case .flexibleProxy:
                totalFlexibleSpace += layoutSize
                hasProxy = true

            case .fixedProxy:
                totalFixedSpace += layoutSize
                hasProxy = true
            }

            distributionItems.append(item)
        }

        // Exit early if no subviews or proxies were provided.
        guard subviewsToDistribute.count > 0 || hasProxy else {
            return ([], 0, 0)
        }

        // Insert flexible space if necessary.
        if totalFlexibleSpace == 0 {
            // Only fixed spacers: add `1.flexible` on both ends.
            distributionItems.insert(.flexible(1), at: 0)
            distributionItems.append(.flexible(1))
            totalFlexibleSpace += 2
        }

        return (distributionItems, totalFixedSpace + totalViewSize, totalFlexibleSpace)
    }

    // MARK: - Internal Methods

    /// Returns the length of the distribution item along the horizontal axis, applying the `multiplier` to the weight of flexible spacers and proxies.
    internal func layoutSize(multiplier: CGFloat = 1) -> CGFloat {
        switch self {
        case let .view(alignable, _):
            alignable.alignmentContext.alignmentBounds.width

        case let .fixed(margin):
            margin

        case let .flexible(weight):
            weight * multiplier

        case let .flexibleProxy(proxy):
            proxy.weight * multiplier

        case let .fixedProxy(proxy):
            proxy.length
        }
    }

}

// MARK: -

extension Array where Element: Alignable {
    /// Return a distribution where the `interspersedItem` is inserted between each of the items in the receiver.
    @MainActor
    public func interspersed(with interspersedItem: HorizontalDistributionItem) -> [HorizontalDistributionItem] {
        reduce([]) { partial, next in
            if partial.isEmpty {
                [.view(next, orthogonalAlignment: nil)]
            } else {
                partial + [interspersedItem, .view(next, orthogonalAlignment: nil)]
            }
        }
    }

    /// Return a distribution where the `interspersedItem` is inserted between each of the items in the receiver.
    ///
    /// For example, interspersing `16.fixed` into a distribution of
    /// ```
    /// [view1, view2, view3]
    /// ```
    /// gives a resulting distribution of
    /// ```
    /// [view1, 16.fixed, view2, 16.fixed, view3]
    /// ```
    @MainActor
    public func interspersed(with interspersedItem: FixedSpacer) -> [HorizontalDistributionItem] {
        interspersed(with: .fixed(interspersedItem.size.width))
    }

    /// Return a distribution where the `interspersedItem` is inserted between each of the items in the receiver.
    ///
    /// For example, interspersing `1.flexible` into a distribution of
    /// ```
    /// [view1, view2, view3]
    /// ```
    /// gives a resulting distribution of
    /// ```
    /// [view1, 1.flexible, view2, 1.flexible, view3]
    /// ```
    @MainActor
    public func interspersed(with interspersedItem: FlexibleSpacer) -> [HorizontalDistributionItem] {
        interspersed(with: .flexible(interspersedItem.weight))
    }
}

// MARK: -

extension Alignable {

    /// Specifies the vertical alignment to use for this item in a horizontal distribution, overriding the orthogonal alignment specified for the distribution as a whole.
    @MainActor
    public func withVerticalAlignment(_ orthogonalAlignment: VerticalDistributionAlignment) -> HorizontalDistributionItem {
        return .view(
            self,
            orthogonalAlignment: orthogonalAlignment
        )
    }

}
