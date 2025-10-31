// Created by Nick Entin on 10/7/25.

import UIKit

public struct OffsetAlignmentProxy: Alignable {
    // MARK: Initialization

    public init(alignable: Alignable, offset: UIOffset) {
        self.alignable = alignable
        self.offset = offset
    }

    // MARK: Public

    public let alignable: Alignable

    public var proxiedView: UIView {
        return alignable.alignmentContext.view
    }

    public let offset: UIOffset

    // MARK: Alignable

    public var alignmentContext: AlignmentContext {
        return AlignmentContext(
            view: proxiedView,
            alignmentBounds: alignable.alignmentContext.alignmentBounds.offset(by: offset),
        )
    }

    public func distributionSizeThatFits(_ size: CGSize) -> CGSize {
        return alignable.distributionSizeThatFits(size)
    }
}

// MARK: -

extension Alignable {

    public func alignmentProxy(offsetBy offset: UIOffset) -> Alignable {
        return OffsetAlignmentProxy(alignable: self, offset: offset)
    }

    public func alignmentProxyOffsetBy(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> Alignable {
        return alignmentProxy(offsetBy: .init(horizontal: horizontal, vertical: vertical))
    }

}
