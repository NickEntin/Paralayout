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

public struct InsetAlignmentProxy: Alignable {
    // MARK: Initialization

    public init(alignable: Alignable, insets: UIEdgeInsets) {
        self.alignable = alignable
        self.insets = insets
    }

    public init(proxiedView: UIView, insets: UIEdgeInsets) {
        self.alignable = proxiedView
        self.insets = insets
    }

    // MARK: Public

    public let alignable: Alignable

    public var proxiedView: UIView {
        return alignable.alignmentContext.view
    }

    public var insets: UIEdgeInsets

    // MARK: Alignable

    public var alignmentContext: AlignmentContext {
        return AlignmentContext(
            view: alignable.alignmentContext.view,
            alignmentBounds: alignable.alignmentContext.alignmentBounds.inset(by: insets)
        )
    }

    public func distributionSizeThatFits(_ size: CGSize) -> CGSize {
        let sizeToFit = CGSize(width: size.width - insets.horizontalAmount, height: size.height - insets.verticalAmount)
        let sizeThatFits = alignable.distributionSizeThatFits(sizeToFit)
        return CGSize(width: sizeThatFits.width + insets.horizontalAmount, height: sizeThatFits.height + insets.verticalAmount)
    }

}

// MARK: -

extension Alignable {

    public func alignmentProxy(insetBy insets: UIEdgeInsets) -> Alignable {
        return InsetAlignmentProxy(alignable: self, insets: insets)
    }

    public func alignmentProxyInsetBy(vertical: CGFloat = 0, horizontal: CGFloat = 0) -> Alignable {
        return alignmentProxy(insetBy: UIEdgeInsets(vertical: vertical, horizontal: horizontal))
    }

    public func alignmentProxyInsetBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Alignable {
        return alignmentProxy(insetBy: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    public func alignmentProxyInsetBy(uniform inset: CGFloat) -> Alignable {
        return alignmentProxy(insetBy: UIEdgeInsets(uniform: inset))
    }

}

// MARK: -

extension UIView {

    /// An alignment proxy that supports the view participating in alignment using the rect inset from its `bounds` by its `layoutMargins`.
    ///
    /// - Note: The proxy provided by this property is based on the receiver's current `layoutMargins` and will not automatically update if the value of `layoutMargins` changes.
    public var layoutMarginsAlignmentProxy: Alignable {
        return InsetAlignmentProxy(alignable: self, insets: layoutMargins)
    }

    /// An alignment proxy that supports the view participating in alignment using the rect inset from its `bounds` by its `safeAreaInsets`.
    ///
    /// - Note: The proxy provided by this property is based on the receiver's current `safeAreaInsets` and will not automatically update if the value of `safeAreaInsets` changes.
    public var safeAreaAlignmentProxy: Alignable {
        return InsetAlignmentProxy(alignable: self, insets: safeAreaInsets)
    }

}
