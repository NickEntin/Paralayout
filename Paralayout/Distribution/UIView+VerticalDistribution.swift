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

/// Orthogonal alignment options for vertical view distribution.
public enum HorizontalDistributionAlignment {

    /// Align to the leading edge, inset by the specified amount.
    ///
    /// - parameter inset: An inset from the leading edge towards the center of the distribution axis. Defaults to zero.
    case leading(inset: CGFloat = .zero)

    /// Center-align along the distribution axis.
    ///
    /// - parameter offset: An offset from the center of the distribution axis. Positive values indicate adjusting towards the
    /// trailing edge. Negative values indicate adjusting towards the leading edge. Defaults to zero.
    case centered(offset: CGFloat = .zero)

    /// Align to the trailing edge, inset by the specified amount.
    ///
    /// - parameter inset: An inset from the trailing edge towards the center of the distribution axis. Defaults to zero.
    case trailing(inset: CGFloat = .zero)

}

// MARK: -

extension UIView {

    // MARK: Public

    /// Arranges subviews along the vertical axis according to a distribution with fixed and/or flexible spacers.
    ///
    /// If there are no flexible elements, this will treat the distribution as vertically centered (i.e. with two
    /// flexible elements of equal weight at the top and bottom, respectively).
    ///
    /// **Examples:**
    ///
    /// To stack two elements with a 10 pt margin between them:
    /// ```
    /// // This is effectively the same as [ 1.flexible, icon, 10.fixed, label, 1.flexible ].
    /// applyVerticalSubviewDistribution([ icon, 10.fixed, label ])
    /// ```
    ///
    /// To evenly spread out items:
    /// ```
    /// applyVerticalSubviewDistribution([ 1.flexible, button1, 1.flexible, button2, 1.flexible, button3, 1.flexible ])
    /// ```
    ///
    /// To stack two elements with 50% more space below than above:
    /// ```
    /// applyVerticalSubviewDistribution([ 2.flexible, label, 12.fixed, textField, 3.flexible ])
    /// ```
    ///
    /// To arrange a pair of label on the top and bottom edges of a view, with another label centered between them:
    /// ```
    /// applyVerticalSubviewDistribution(
    ///     [ 8.fixed, headerLabel, 1.flexible, bodyLabel, 1.flexible, footerLabel, 8.fixed ]
    /// )
    /// ```
    ///
    /// To arrange UI in a view with an interior margin:
    /// ```
    /// applyVerticalSubviewDistribution([ icon, 10.fixed, label ], inRect: bounds.insetBy(dx: 20, dy: 40))
    /// ```
    ///
    /// To arrange UI vertically aligned by their leading edge 10 pt in from the leading edge of their superview:
    /// ```
    /// applyVerticalSubviewDistribution([ icon, 1.flexible, button ], orthogonalOffset: .leading(inset: 10))
    /// ```
    ///
    /// To arrange UI vertically without simultaneously centering it horizontally (the `icon` would need independent
    /// horizontal positioning):
    /// ```
    /// applyVerticalSubviewDistribution([ 1.flexible, icon, 2.flexible ], orthogonalOffset: nil)
    /// ```
    ///
    /// - precondition: All views in the `distribution` must be subviews of the receiver.
    /// - precondition: The `distribution` must not include any given view more than once.
    ///
    /// - parameter distribution: An array of distribution specifiers, ordered from the top edge to the bottom edge.
    /// - parameter layoutBounds: The region in the receiver in which to distribute the view in the receiver's
    /// coordinate space. Specify `nil` to use the receiver's bounds. Defaults to `nil`.
    /// - parameter orthogonalAlignment: The horizontal alignment to apply to the views. If `nil`, views are left in
    /// their horizontal position prior to the distribution. Defaults to centered with no offset.
    public func applyVerticalSubviewDistribution(
        _ distribution: VerticalDistribution,
        inRect layoutBounds: CGRect? = nil,
        orthogonalAlignment: HorizontalDistributionAlignment? = .centered(offset: 0)
    ) {
        applySubviewDistribution(distribution, inRect: layoutBounds) { frame, layoutBounds in
            guard let horizontalAlignment = orthogonalAlignment else {
                return
            }

            switch (horizontalAlignment, effectiveUserInterfaceLayoutDirection) {
            case let (.leading(inset: inset), .leftToRight):
                frame.origin.x = (layoutBounds.minX + inset).roundedToPixel(in: self)
            case let (.leading(inset: inset), .rightToLeft):
                frame.origin.x = (layoutBounds.maxX - (frame.width + inset)).roundedToPixel(in: self)
            case let (.centered(offset: offset), .leftToRight):
                frame.origin.x = (layoutBounds.midX - frame.width / 2 + offset).roundedToPixel(in: self)
            case let (.centered(offset: offset), .rightToLeft):
                frame.origin.x = (layoutBounds.midX - frame.width / 2 - offset).roundedToPixel(in: self)
            case let (.trailing(inset: inset), .leftToRight):
                frame.origin.x = (layoutBounds.maxX - (frame.width + inset)).roundedToPixel(in: self)
            case let (.trailing(inset: inset), .rightToLeft):
                frame.origin.x = (layoutBounds.minX + inset).roundedToPixel(in: self)
            @unknown default:
                fatalError("Unknown user interface layout direction")
            }
        }
    }

    /// Arranges subviews along the vertical axis according to a distribution with fixed and/or flexible spacers.
    ///
    /// If there are no flexible elements, this will treat the distribution as vertically centered (i.e. with two
    /// flexible elements of equal weight at the top and bottom, respectively).
    ///
    /// **Examples:**
    ///
    /// To stack two elements with a 10 pt margin between them:
    /// ```swift
    /// // This is effectively the same as [ 1.flexible, icon, 10.fixed, label, 1.flexible ].
    /// applyVerticalSubviewDistribution {
    ///     icon
    ///     10.fixed
    ///     label
    /// }
    /// ```
    ///
    /// To evenly spread out items:
    /// ```swift
    /// applyVerticalSubviewDistribution {
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
    /// To stack two elements with 50% more space below than above:
    /// ```swift
    /// applyVerticalSubviewDistribution {
    ///     2.flexible
    ///     label
    ///     12.fixed
    ///     textField
    ///     3.flexible
    /// }
    /// ```
    ///
    /// To arrange a pair of label on the top and bottom edges of a view, with another label centered between them:
    /// ```swift
    /// applyVerticalSubviewDistribution {
    ///     8.fixed
    ///     headerLabel
    ///     1.flexible
    ///     bodyLabel
    ///     1.flexible
    ///     footerLabel
    ///     8.fixed
    /// }
    /// ```
    ///
    /// To arrange UI in a view with an interior margin:
    /// ```swift
    /// applyVerticalSubviewDistribution(inRect: bounds.insetBy(dx: 20, dy: 40)) {
    ///     icon
    ///     10.fixed
    ///     label
    /// }
    /// ```
    ///
    /// To arrange UI vertically aligned by their leading edge 10 pt in from the leading edge of their superview:
    /// ```swift
    /// applyVerticalSubviewDistribution(orthogonalOffset: .leading(inset: 10)) {
    ///     icon
    ///     1.flexible
    ///     button
    /// }
    /// ```
    ///
    /// To arrange UI vertically without simultaneously centering it horizontally (the `icon` would need independent
    /// horizontal positioning):
    /// ```swift
    /// applyVerticalSubviewDistribution(orthogonalOffset: nil) {
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
    /// - parameter orthogonalAlignment: The horizontal alignment to apply to the views. If `nil`, views are left in
    /// their horizontal position prior to the distribution. Defaults to centered with no offset.
    /// - parameter distribution: An array of distribution specifiers, ordered from the top edge to the bottom edge.
    public func applyVerticalSubviewDistribution(
        inRect layoutBounds: CGRect? = nil,
        orthogonalAlignment: HorizontalDistributionAlignment? = .centered(offset: 0),
        @VerticalDistributionBuilder _ distribution: () -> VerticalDistribution
    ) {
        applyVerticalSubviewDistribution(
            distribution(),
            inRect: layoutBounds,
            orthogonalAlignment: orthogonalAlignment
        )
    }

    // MARK: - Private

    private func applySubviewDistribution(
        _ distribution: [VerticalDistributionItem],
        inRect layoutBounds: CGRect?,
        applyOrthogonalAlignment: (_ subviewFrame: inout CGRect, _ layoutBounds: CGRect) -> Void
    ) {
        let axis = ViewDistributionAxis.vertical

        // Process and validate the distribution.
        let (items, totalFixedSpace, flexibleSpaceDenominator) = VerticalDistributionItem.items(
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

        // Okay, ready to go!
        var leadingEdgePosition = axis.leadingEdge(of: layoutBounds, layoutDirection: receiverLayoutDirection)
        for item in items {
            switch item {
            case let .view(alignable):
                var frame = alignable.alignmentContext.alignmentBounds
                frame.origin.y = leadingEdgePosition.roundedToPixel(in: self)
                applyOrthogonalAlignment(&frame, layoutBounds)

                // @NICK TODO: Probably need to specify alignment behavior here
                alignable.align(.topLeft, withSuperviewPoint: frame.origin)

            case let .flexibleProxy(proxy):
                let size = switch axis {
                case .horizontal:
                    CGSize(width: flexibleSpaceMultiplier * proxy.weight, height: layoutBounds.height)
                case .vertical:
                    CGSize(width: layoutBounds.width, height: flexibleSpaceMultiplier * proxy.weight)
                }

                proxy.rect = CGRect(
                    x: layoutBounds.minX,
                    y: leadingEdgePosition,
                    width: size.width,
                    height: size.height
                )

            case let .fixedProxy(proxy):
                let size = switch axis {
                case .horizontal:
                    CGSize(width: proxy.length, height: layoutBounds.height)
                case .vertical:
                    CGSize(width: layoutBounds.width, height: proxy.length)
                }

                proxy.rect = CGRect(
                    x: layoutBounds.minX,
                    y: leadingEdgePosition,
                    width: size.width,
                    height: size.height
                )

            case .fixed, .flexible:
                break
            }

            // Note that we don't apply pixel rounding here, but rather when setting the position of each subview
            // individually, so that rounding error is not accumulated.
            leadingEdgePosition += item.layoutSize(multiplier: flexibleSpaceMultiplier)
        }
    }

}
