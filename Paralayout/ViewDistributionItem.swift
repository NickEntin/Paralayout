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

/// An element of a horizontal or vertical distribution.
public enum ViewDistributionItem: ViewDistributionSpecifying, Sendable {

    /// A UIView, with adjustments to how much space it should take up.
    case view(UIView, UIEdgeInsets)

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

    public var distributionItem: ViewDistributionItem {
        return self
    }

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

    /// Maps the specifiers to their provided items and adds implied flexible spacers as necessary.
    ///
    /// * If no spacers (fixed or flexible) or flexible proxies are included, equal flexible spacers are inserted
    ///   between all views.
    /// * If no flexible spacers or proxies are included, two equal flexible spacers ones are added to the beginning and
    ///   end of the distribution.
    ///
    /// - precondition: All views in the `distribution` must be subviews of the `superview`.
    /// - precondition: The `distribution` must not include any given view more than once.
    ///
    /// - returns: An array of `ViewDistributionItem`s suitable for layout and/or measurement, and tallies of all fixed
    /// and flexible space.
    internal static func items(
        impliedIn distribution: [ViewDistributionSpecifying],
        axis: ViewDistributionAxis,
        superview: UIView?
    ) -> (items: [ViewDistributionItem], totalFixedSpace: CGFloat, flexibleSpaceDenominator: CGFloat) {
        var distributionItems = [ViewDistributionItem]()
        var totalViewSize: CGFloat = 0
        var totalFixedSpace: CGFloat = 0
        var totalFlexibleSpace: CGFloat = 0
        var hasProxy: Bool = false

        var subviewsToDistribute = Set<UIView>()

        // Map the specifiers to items, tallying up space along the way.
        for specifier in distribution {
            let item = specifier.distributionItem
            let layoutSize = item.layoutSize(along: axis)

            switch item {
            case .view(let view, _):
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
            distributionItems.insert(1.flexible, at: 0)
            distributionItems.append(1.flexible)
            totalFlexibleSpace += 2
        }

        return (distributionItems, totalFixedSpace + totalViewSize, totalFlexibleSpace)
    }

    // MARK: - Internal Methods

    /// Returns the length of the distribution item (`axis` and `multiplier` are relevant only for `.view` and
    /// flexible items).
    internal func layoutSize(along axis: ViewDistributionAxis, multiplier: CGFloat = 1) -> CGFloat {
        switch self {
        case let .view(view, insets):
            axis.size(of: view.untransformedFrame) - axis.amount(of: insets)

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

/// A means of getting a `ViewDistributionItem`.
@MainActor
public protocol ViewDistributionSpecifying {

    var distributionItem: ViewDistributionItem { get }

}

extension UIView: ViewDistributionSpecifying {

    // Adopt `ViewDistributionSpecifying`, making it possible to include UIView instances directly in distributions
    // passed to `apply{Vertical,Horizontal}SubviewDistribution()`.
    public var distributionItem: ViewDistributionItem {
        return .view(self, .zero)
    }

}

// MARK: -

extension CGFloat {

    /// Use the value as a fixed spacer in a distribution.
    public var fixed: ViewDistributionItem {
        return .fixed(self)
    }

    /// Use the value as a flexible (proportional) spacer in a distribution.
    public var flexible: ViewDistributionItem {
        return .flexible(self)
    }

}

extension Double {

    /// Use the value as a fixed spacer in a distribution.
    public var fixed: ViewDistributionItem {
        return .fixed(CGFloat(self))
    }

    /// Use the value as a flexible (proportional) spacer in a distribution.
    public var flexible: ViewDistributionItem {
        return .flexible(CGFloat(self))
    }

}

extension Int {

    /// Use the value as a fixed spacer in a distribution.
    public var fixed: ViewDistributionItem {
        return .fixed(CGFloat(self))
    }

    /// Use the value as a flexible (proportional) spacer in a distribution.
    public var flexible: ViewDistributionItem {
        return .flexible(CGFloat(self))
    }

}

// MARK: -

extension Array where Element: ViewDistributionSpecifying {
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
    public func interspersed(with interspersedItem: ViewDistributionItem) -> [ViewDistributionItem] {
        reduce([]) { partial, next in
            if partial.isEmpty {
                [next.distributionItem]
            } else {
                partial + [interspersedItem, next.distributionItem]
            }
        }
    }
}
