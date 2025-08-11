// Created by Nick Entin on 7/17/25.

import UIKit

@MainActor
public protocol VerticallyDistributable {

    var verticalDistributionItem: VerticalDistributionItem { get }

}

public enum VerticalDistributionItem: VerticallyDistributable {

    case view(UIView, alignmentBounds: CGRect, orthogonalAlignment: HorizontalDistributionAlignment? = nil)
//    case view(Alignable, orthogonalAlignment: HorizontalDistributionAlignment? = nil)

    case fixed(CGFloat)

    case flexible(CGFloat)

    case flexibleProxy(FlexibleDistributionProxy)

    case fixedProxy(FixedDistributionProxy)

    // MARK: Public

    public var verticalDistributionItem: VerticalDistributionItem {
        return self
    }

    // MARK: Internal

    func layoutSize(flexibleMultiplier: CGFloat) -> CGFloat {
        switch self {
        case let .view(_, alignmentBounds, _):
            alignmentBounds.height
        case let .fixed(length):
            length
        case let .flexible(weight):
            weight * flexibleMultiplier
        case let .flexibleProxy(proxy):
            proxy.weight * flexibleMultiplier
        case let .fixedProxy(proxy):
            proxy.length
        }
    }
}

extension Alignable {

    @MainActor
    public func withHorizontalAlignment(_ orthogonalAlignment: HorizontalDistributionAlignment) -> VerticalDistributionItem {
        let alignmentContext = alignmentContext
        return .view(
            alignmentContext.view,
            alignmentBounds: alignmentContext.alignmentBounds,
            orthogonalAlignment: orthogonalAlignment,
        )
    }

}

// MARK: -

extension Array where Element: VerticallyDistributable {
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
    public func interspersed(with interspersedItem: VerticallyDistributable) -> [VerticallyDistributable] {
        reduce([]) { partial, next in
            if partial.isEmpty {
                [next.verticalDistributionItem]
            } else {
                partial + [interspersedItem, next.verticalDistributionItem]
            }
        }
    }
}
