// Created by Nick Entin on 7/20/25.

import Foundation

@MainActor
public struct FixedDistributionSpacer: VerticallyDistributable, HorizontallyDistributable {

    public init(length: CGFloat) {
        self.length = length
    }

    public var length: CGFloat

    public var verticalDistributionItem: VerticalDistributionItem {
        .fixed(length)
    }

}

// MARK: -

@MainActor
public struct FlexibleDistributionSpacer: VerticallyDistributable, HorizontallyDistributable {

    public init(weight: CGFloat) {
        self.weight = weight
    }

    public var weight: CGFloat

    public var verticalDistributionItem: VerticalDistributionItem {
        .flexible(weight)
    }

}

// MARK: -

extension CGFloat {

    /// Use the value as a fixed spacer in a distribution.
    @MainActor
    public var fixed: (VerticallyDistributable & HorizontallyDistributable) {
        return FixedDistributionSpacer(length: self)
    }

    /// Use the value as a flexible (proportional) spacer in a distribution.
    @MainActor
    public var flexible: (VerticallyDistributable & HorizontallyDistributable) {
        return FlexibleDistributionSpacer(weight: self)
    }

}

extension Double {

    /// Use the value as a fixed spacer in a distribution.
    @MainActor
    public var fixed: (VerticallyDistributable & HorizontallyDistributable) {
        return FixedDistributionSpacer(length: CGFloat(self))
    }

    /// Use the value as a flexible (proportional) spacer in a distribution.
    @MainActor
    public var flexible: (VerticallyDistributable & HorizontallyDistributable) {
        return FlexibleDistributionSpacer(weight: CGFloat(self))
    }

}

extension Int {

    /// Use the value as a fixed spacer in a distribution.
    @MainActor
    public var fixed: (VerticallyDistributable & HorizontallyDistributable) {
        return FixedDistributionSpacer(length: CGFloat(self))
    }

    /// Use the value as a flexible (proportional) spacer in a distribution.
    @MainActor
    public var flexible: (VerticallyDistributable & HorizontallyDistributable) {
        return FlexibleDistributionSpacer(weight: CGFloat(self))
    }

}
