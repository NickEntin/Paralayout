//
//  Portions of this file are Copyright © 2025 Nick Entin
//  Portions of this file are Copyright © 2017 Square, Inc.
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

/// Orthogonal alignment options for horizontal view distribution.
public enum VerticalDistributionAlignment {

    /// Align to the top edge, inset by the specified amount.
    ///
    /// - parameter inset: An inset from the top edge towards the center of the distribution axis. Defaults to zero.
    case top(inset: CGFloat = .zero)

    /// Center-align along the distribution axis.
    ///
    /// - parameter offset: An offset from the center of the distribution axis. Positive values indicate adjusting towards the
    /// top edge. Negative values indicate adjusting towards the bottom edge. Defaults to zero.
    case centered(offset: CGFloat = .zero)

    /// Align to the bottom edge, inset by the specified amount.
    ///
    /// - parameter inset: An inset from the bottom edge towards the center of the distribution axis. Defaults to zero.
    case bottom(inset: CGFloat = .zero)

}

// MARK: -

extension UIView {

    // MARK: - Public Methods

    /// Arranges subviews along the horizontal axis according to a distribution with fixed and/or flexible spacers.
    ///
    /// If there are no flexible elements, this will treat the distribution as horizontally centered (i.e. with two
    /// flexible elements of equal weight at the leading and trailing edges, respectively).
    ///
    /// **Examples:**
    ///
    /// To stack two elements with a 10 pt margin between them:
    /// ```swift
    /// // This is effectively the same as [ 1.flexible, icon, 10.fixed, label, 1.flexible ].
    /// applyHorizontalSubviewDistribution {
    ///     icon
    ///     10.fixed
    ///     label
    /// }
    /// ```
    ///
    /// To evenly spread out items:
    /// ```swift
    /// applyHorizontalSubviewDistribution {
    ///     1.flexible
    ///     button1
    ///     1.flexible
    ///     button2
    ///     1.flexible
    ///     button3
    ///     1.flexible
    /// }
    /// ```
    ///
    /// To stack two elements with 50% more space after than before:
    /// ```swift
    /// applyHorizontalSubviewDistribution {
    ///     2.flexible
    ///     label
    ///     12.fixed
    ///     textField
    ///     3.flexible
    /// }
    /// ```
    ///
    /// To arrange a pair of buttons on the left and right edges of a view, with a label centered between them:
    /// ```swift
    /// applyHorizontalSubviewDistribution {
    ///     8.fixed
    ///     backButton
    ///     1.flexible
    ///     titleLabel
    ///     1.flexible
    ///     nextButton
    ///     8.fixed
    /// }
    /// ```
    ///
    /// To arrange UI in a view with an interior margin:
    /// ```swift
    /// applyHorizontalSubviewDistribution(inRect: bounds.insetBy(dx: 20, dy: 40)) {
    ///     icon
    ///     10.fixed
    ///     label
    /// }
    /// ```
    ///
    /// To arrange UI horizontally aligned by their top edge 10 pt in from the top edge of their superview:
    /// ```swift
    /// applyHorizontalSubviewDistribution(orthogonalOffset: .top(inset: 10)) {
    ///     icon
    ///     1.flexible
    ///     button
    /// }
    /// ```
    ///
    /// To arrange UI horizontally without simultaneously centering it vertically (the `icon` would need independent
    /// vertical positioning):
    /// ```swift
    /// applyHorizontalSubviewDistribution(orthogonalOffset: nil) {
    ///     1.flexible
    ///     icon
    ///     2.flexible
    /// }
    /// ```
    ///
    /// - precondition: All views in the `distribution` must be subviews of the receiver.
    /// - precondition: The `distribution` must not include any given view more than once.
    ///
    /// - parameter layoutBounds: The region in the receiver in which to distribute the view in the receiver's
    /// coordinate space. Specify `nil` to use the receiver's bounds. Defaults to `nil`.
    /// - parameter orthogonalAlignment: The vertical alignment to apply to the views. If `nil`, views are left in
    /// their vertical position prior to the distribution. Defaults to centered with no offset.
    /// - parameter distribution: An array of distribution specifiers, ordered from the leading edge to the trailing
    /// edge.
    public func applyHorizontalSubviewDistribution(
        inRect layoutBounds: CGRect? = nil,
        orthogonalAlignment: VerticalDistributionAlignment? = .centered(offset: 0),
        @HorizontalDistributionBuilder _ distribution: () -> [HorizontalDistributionItem]
    ) {
        applyHorizontalSubviewDistribution(
            distribution(),
            inRect: layoutBounds,
            orthogonalAlignment: orthogonalAlignment
        )
    }

    /// Arranges subviews along the horizontal axis according to a distribution with fixed and/or flexible spacers.
    ///
    /// If there are no flexible elements, this will treat the distribution as horizontally centered (i.e. with two
    /// flexible elements of equal weight at the leading and trailing edges, respectively).
    ///
    /// **Examples:**
    ///
    /// To stack two elements with a 10 pt margin between them:
    /// ```
    /// // This is effectively the same as [ 1.flexible, icon, 10.fixed, label, 1.flexible ].
    /// applyHorizontalSubviewDistribution([ icon, 10.fixed, label ])
    /// ```
    ///
    /// To evenly spread out items:
    /// ```
    /// applyHorizontalSubviewDistribution([ 1.flexible, button1, 1.flexible, button2, 1.flexible, button3 ])
    /// ```
    ///
    /// To stack two elements with 50% more space after than before:
    /// ```
    /// applyHorizontalSubviewDistribution([ 2.flexible, label, 12.fixed, textField, 3.flexible ])
    /// ```
    ///
    /// To arrange a pair of buttons on the left and right edges of a view, with a label centered between them:
    /// ```
    /// applyHorizontalSubviewDistribution(
    ///     [ 8.fixed, backButton, 1.flexible, titleLabel, 1.flexible, nextButton, 8.fixed ]
    /// )
    /// ```
    ///
    /// To arrange UI in a view with an interior margin:
    /// ```
    /// applyHorizontalSubviewDistribution([ icon, 10.fixed, label ], inRect: bounds.insetBy(dx: 20, dy: 40))
    /// ```
    ///
    /// To arrange UI horizontally aligned by their top edge 10 pt in from the top edge of their superview:
    /// ```
    /// applyHorizontalSubviewDistribution([ icon, 1.flexible, button ], orthogonalOffset: .top(inset: 10))
    /// ```
    ///
    /// To arrange UI horizontally without simultaneously centering it vertically (the `icon` would need independent
    /// vertical positioning):
    /// ```
    /// applyHorizontalSubviewDistribution([ 1.flexible, icon, 2.flexible ], orthogonalOffset: nil)
    /// ```
    ///
    /// - precondition: All views in the `distribution` must be subviews of the receiver.
    /// - precondition: The `distribution` must not include any given view more than once.
    ///
    /// - parameter distribution: An array of distribution specifiers, ordered from the leading edge to the trailing
    /// edge.
    /// - parameter layoutBounds: The region in the receiver in which to distribute the view in the receiver's
    /// coordinate space. Specify `nil` to use the receiver's bounds. Defaults to `nil`.
    /// - parameter orthogonalAlignment: The vertical alignment to apply to the views. If `nil`, views are left in
    /// their vertical position prior to the distribution. Defaults to centered with no offset.
    public func applyHorizontalSubviewDistribution(
        _ distribution: [HorizontalDistributionItem],
        inRect layoutBounds: CGRect? = nil,
        orthogonalAlignment: VerticalDistributionAlignment? = .centered(offset: 0)
    ) {
        let axis = ViewDistributionAxis.horizontal

        let (items, totalFixedSpace, flexibleSpaceDenominator) = HorizontalDistributionItem.items(
            impliedIn: distribution,
            superview: self
        )

        guard items.count > 0 else {
            return
        }

        // Determine the layout parameters based on the space the distribution is going into.
        let layoutBounds = layoutBounds ?? bounds
        let flexibleSpaceMultiplier = (axis.size(of: layoutBounds) - totalFixedSpace) / flexibleSpaceDenominator
        let receiverLayoutDirection = effectiveUserInterfaceLayoutDirection

        var leadingEdgePosition = axis.leadingEdge(of: layoutBounds, layoutDirection: receiverLayoutDirection)
        for item in items {
            switch item {
            case let .view(alignable, itemOrthogonalAlignment):
                var frame = alignable.alignmentContext.alignmentBounds

                switch receiverLayoutDirection {
                case .leftToRight:
                    frame.origin.x = leadingEdgePosition.roundedToPixel(in: self)
                case .rightToLeft:
                    frame.origin.x = (leadingEdgePosition - frame.width).roundedToPixel(in: self)
                @unknown default:
                    fatalError("Unknown user interface layout direction")
                }

                if let verticalAlignment = itemOrthogonalAlignment ?? orthogonalAlignment {
                    switch verticalAlignment {
                    case .top(inset: let inset):
                        frame.origin.y = (layoutBounds.minY + inset).roundedToPixel(in: self)
                    case .centered(offset: let offset):
                        frame.origin.y = (layoutBounds.midY - frame.height / 2 + offset).roundedToPixel(in: self)
                    case .bottom(inset: let inset):
                        frame.origin.y = (layoutBounds.maxY - (frame.height + inset)).roundedToPixel(in: self)
                    }
                }

                // @NICK TODO: Probably need to specify alignment behavior here
                alignable.align(.topLeft, withSuperviewPoint: frame.origin)

            case let .flexibleProxy(proxy):
                let size = CGSize(width: flexibleSpaceMultiplier * proxy.weight, height: layoutBounds.height)
                switch receiverLayoutDirection {
                case .leftToRight:
                    proxy.rect = CGRect(
                        x: leadingEdgePosition,
                        y: layoutBounds.minY,
                        width: size.width,
                        height: size.height
                    )
                case .rightToLeft:
                    proxy.rect = CGRect(
                        x: leadingEdgePosition - size.width,
                        y: layoutBounds.minY,
                        width: size.width,
                        height: size.height
                    )
                @unknown default:
                    fatalError("Unknown user interface layout direction")
                }

            case let .fixedProxy(proxy):
                let size = CGSize(width: proxy.length, height: layoutBounds.height)
                switch receiverLayoutDirection {
                case .leftToRight:
                    proxy.rect = CGRect(
                        x: leadingEdgePosition,
                        y: layoutBounds.minY,
                        width: size.width,
                        height: size.height
                    )
                case .rightToLeft:
                    proxy.rect = CGRect(
                        x: leadingEdgePosition - size.width,
                        y: layoutBounds.minY,
                        width: size.width,
                        height: size.height
                    )
                @unknown default:
                    fatalError("Unknown user interface layout direction")
                }

            case .fixed, .flexible:
                break
            }

            // Note that we don't apply pixel rounding here, but rather when setting the position of each subview
            // individually, so rounding error is not accumulated.
            switch receiverLayoutDirection {
            case .leftToRight:
                leadingEdgePosition += item.layoutSize(multiplier: flexibleSpaceMultiplier)
            case .rightToLeft:
                leadingEdgePosition -= item.layoutSize(multiplier: flexibleSpaceMultiplier)
            @unknown default:
                fatalError("Unknown user interface layout direction")
            }
        }
    }

}
