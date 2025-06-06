//
//  Copyright © 2017 Square, Inc.
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

/// A value type representing the ratio between a width and a height.
public struct AspectRatio: Comparable, CustomDebugStringConvertible, Sendable {

    // MARK: - Public Static Properties

    /// The aspect ratio of a square (1:1).
    public static let square = AspectRatio(width: 1, height: 1)

    /// The golden ratio (~1.618:1).
    public static let golden = AspectRatio(width: (1 + sqrt(5)) / 2, height: 1)

    /// The aspect ratio of HD video, typical for device displays and video (16:9).
    public static let widescreen = AspectRatio(width: 16, height: 9)

    // MARK: - Private Properties

    private let ratioWidth: CGFloat
    private let ratioHeight: CGFloat

    // MARK: - Public Properties

    /// An inverted representation of the AspectRatio.
    public var inverted: AspectRatio {
        AspectRatio(width: ratioHeight, height: ratioWidth)
    }

    // MARK: - Life Cycle

    /// Creates an AspectRatio with a given `width` and `height`.
    ///
    /// - precondition: Both the `width` and `height` must be greater than zero.
    public init(width: CGFloat, height: CGFloat) {
        precondition(
            width > 0 && height > 0,
            "AspectRatios must be created with a width and height both greater than zero"
        )

        ratioWidth = width
        ratioHeight = height
    }

    /// Creates an AspectRatio matching a given `size`.
    ///
    /// - precondition: Both the `width` and `height` of the `size` must be greater than zero.
    public init(size: CGSize) {
        self.init(width: size.width, height: size.height)
    }

    /// Creates an AspectRatio matching a given `rect`.
    ///
    /// - precondition: Both the `width` and `height` of the `rect` must be greater than zero.
    public init(rect: CGRect) {
        self.init(width: rect.width, height: rect.height)
    }

    // MARK: - Comparable

    public static func == (lhs: AspectRatio, rhs: AspectRatio) -> Bool {
        (lhs.ratioWidth * rhs.ratioHeight == lhs.ratioHeight * rhs.ratioWidth)
    }

    public static func < (lhs: AspectRatio, rhs: AspectRatio) -> Bool {
        (lhs.ratioWidth * rhs.ratioHeight < lhs.ratioHeight * rhs.ratioWidth)
    }

    public static func <= (lhs: AspectRatio, rhs: AspectRatio) -> Bool {
        (lhs.ratioWidth * rhs.ratioHeight <= lhs.ratioHeight * rhs.ratioWidth)
    }

    public static func >= (lhs: AspectRatio, rhs: AspectRatio) -> Bool {
        (lhs.ratioWidth * rhs.ratioHeight >= lhs.ratioHeight * rhs.ratioWidth)
    }

    public static func > (lhs: AspectRatio, rhs: AspectRatio) -> Bool {
        (lhs.ratioWidth * rhs.ratioHeight > lhs.ratioHeight * rhs.ratioWidth)
    }

    // MARK: - DebugStringConvertible

    public var debugDescription: String {
        ("AspectRatio<\(ratioWidth):\(ratioHeight)>")
    }

    // MARK: - Public Methods

    /// Returns the height of the aspect ratio for a given `width` rounded to the nearest pixel.
    ///
    /// - parameter width: The desired width.
    /// - parameter scaleFactor: The view/window/screen to use for pixel rounding.
    @MainActor
    public func height(forWidth width: CGFloat, in scaleFactor: ScaleFactorProviding) -> CGFloat {
        self.height(forWidth: width, in: scaleFactor.pixelsPerPoint)
    }

    /// Returns the height of the aspect ratio for a given `width` rounded to the nearest pixel.
    ///
    /// - parameter width: The desired width.
    /// - parameter scale: The number of pixels per point.
    public func height(forWidth width: CGFloat, in scale: CGFloat) -> CGFloat {
        (ratioHeight * width / ratioWidth).roundedToPixel(in: scale)
    }

    /// Returns the width of the aspect ratio for a given `height` rounded to the nearest pixel.
    ///
    /// - parameter height: The desired height.
    /// - parameter scaleFactor: The view/window/screen to use for pixel rounding.
    @MainActor
    public func width(forHeight height: CGFloat, in scaleFactor: ScaleFactorProviding) -> CGFloat {
        self.width(forHeight: height, in: scaleFactor.pixelsPerPoint)
    }

    /// Returns the width of the aspect ratio for a given `height` rounded to the nearest pixel.
    ///
    /// - parameter height: The desired height.
    /// - parameter scale: The number of pixels per point.
    public func width(forHeight height: CGFloat, in scale: CGFloat) -> CGFloat {
        (ratioWidth * height / ratioHeight).roundedToPixel(in: scale)
    }

    /// Returns a size of the aspect ratio with the specified `width`. The size's `height` will be rounded to the
    /// nearest pixel.
    ///
    /// - parameter width: The desired width.
    /// - parameter scaleFactor: The view/window/screen to use for pixel rounding.
    @MainActor
    public func size(forWidth width: CGFloat, in scaleFactor: ScaleFactorProviding) -> CGSize {
        self.size(forWidth: width, in: scaleFactor.pixelsPerPoint)
    }

    /// Returns a size of the aspect ratio with the specified `width`. The size's `height` will be rounded to the
    /// nearest pixel.
    ///
    /// - parameter width: The desired width.
    /// - parameter scale: The number of pixels per point.
    public func size(forWidth width: CGFloat, in scale: CGFloat) -> CGSize {
        CGSize(
            width: width,
            height: height(forWidth: width, in: scale)
        )
    }

    /// Returns a size of the aspect ratio with the specified `height`. The size's `width` will be rounded to the
    /// nearest pixel.
    ///
    /// - parameter height: The desired height.
    /// - parameter scaleFactor: The view/window/screen to use for pixel rounding.
    @MainActor
    public func size(forHeight height: CGFloat, in scaleFactor: ScaleFactorProviding) -> CGSize {
        self.size(forHeight: height, in: scaleFactor.pixelsPerPoint)
    }

    /// Returns a size of the aspect ratio with the specified `height`. The size's `width` will be rounded to the
    /// nearest pixel.
    ///
    /// - parameter height: The desired height.
    /// - parameter scale: The number of pixels per point.
    public func size(forHeight height: CGFloat, in scale: CGFloat) -> CGSize {
        CGSize(
            width: width(forHeight: height, in: scale),
            height: height
        )
    }

    /// An "aspect-fit" function that determines the largest size of the receiver's aspect ratio that fits within a
    /// size.
    ///
    /// - parameter size: The bounding size.
    /// - parameter scaleFactor: The view/window/screen to use for pixel alignment.
    /// - returns: A size with the receiver's aspect ratio, no larger than the bounding size.
    @MainActor
    public func size(toFit size: CGSize, in scaleFactor: ScaleFactorProviding) -> CGSize {
        self.size(toFit: size, in: scaleFactor.pixelsPerPoint)
    }

    /// An "aspect-fit" function that determines the largest size of the receiver's aspect ratio that fits within a
    /// size.
    ///
    /// - parameter size: The bounding size.
    /// - parameter scale: The number of pixels per point.
    /// - returns: A size with the receiver's aspect ratio, no larger than the bounding size.
    public func size(toFit size: CGSize, in scale: CGFloat) -> CGSize {
        if size.aspectRatio <= self {
            // Match width, narrow the height.
            CGSize(
                width: size.width,
                height: min(size.height, height(forWidth: size.width, in: scale))
            )

        } else {
            // Match height, narrow the width.
            CGSize(
                width: min(size.width, width(forHeight: size.height, in: scale)),
                height: size.height
            )
        }
    }

    /// An "aspect-fit" function that determines the largest rect of the receiver's aspect ratio that fits within a
    /// rect.
    ///
    /// - parameter rect: The bounding rect.
    /// - parameter position: The location within the bounding rect for the new rect, determining where margin(s) will
    /// be if the aspect ratios do not match perfectly.
    /// - parameter context: The view/window/screen that provides the scale factor and effective layout direction in
    /// which the rect should be positioned.
    /// - returns: A rect with the receiver's aspect ratio, strictly within the bounding rect.
    @MainActor
    public func rect(
        toFit rect: CGRect,
        at position: Position,
        in context: (ScaleFactorProviding & LayoutDirectionProviding)
    ) -> CGRect {
        self.rect(
            toFit: rect,
            at: position,
            in: context.pixelsPerPoint,
            layoutDirection: context.effectiveUserInterfaceLayoutDirection
        )
    }

    /// An "aspect-fit" function that determines the largest rect of the receiver's aspect ratio that fits within a
    /// rect.
    ///
    /// - parameter rect: The bounding rect.
    /// - parameter position: The location within the bounding rect for the new rect, determining where margin(s) will
    /// be if the aspect ratios do not match perfectly.
    /// - parameter scale: The number of pixels per point.
    /// - parameter layoutDirection: The effective layout direction of the view in which the `rect` is defined.
    /// - returns: A rect with the receiver's aspect ratio, strictly within the bounding rect.
    public func rect(
        toFit rect: CGRect,
        at position: Position,
        in scale: CGFloat,
        layoutDirection: UIUserInterfaceLayoutDirection
    ) -> CGRect {
        CGRect(
            size: size(toFit: rect.size, in: scale),
            at: position,
            of: rect,
            in: scale,
            layoutDirection: layoutDirection
        )
    }

    /// An "aspect-fill" function that determines the smallest size of the receiver's aspect ratio that fits a size
    /// within it.
    ///
    /// - parameter size: The bounding size.
    /// - parameter scaleFactor: The view/window/screen to use for pixel alignment.
    /// - returns: A size with the receiver's aspect ratio, at least as large as the bounding size.
    @MainActor
    public func size(toFill size: CGSize, in scaleFactor: ScaleFactorProviding) -> CGSize {
        self.size(toFill: size, in: scaleFactor.pixelsPerPoint)
    }

    /// An "aspect-fill" function that determines the smallest size of the receiver's aspect ratio that fits a size
    /// within it.
    ///
    /// - parameter size: The bounding size.
    /// - parameter scale: The number of pixels per point.
    /// - returns: A size with the receiver's aspect ratio, at least as large as the bounding size.
    public func size(toFill size: CGSize, in scale: CGFloat) -> CGSize {
        if size.aspectRatio <= self {
            // Match height, expand the width.
            CGSize(
                width: width(forHeight: size.height, in: scale),
                height: size.height
            )

        } else {
            // Match width, expand the height.
            CGSize(
                width: size.width,
                height: height(forWidth: size.width, in: scale)
            )
        }
    }

    /// An "aspect-fill" function that determines the smallest rect of the receiver's aspect ratio that fits a rect
    /// within it.
    ///
    /// - parameter rect: The bounding rect.
    /// - parameter position: The location within the bounding rect for the new rect, determining where margin(s) will
    /// be if the aspect ratios do not match perfectly.
    /// - parameter context: The view/window/screen that provides the scale factor and effective layout direction in
    /// which the rect should be positioned.
    /// - returns: A rect with the receiver's aspect ratio, strictly containing the bounding rect.
    @MainActor
    public func rect(
        toFill rect: CGRect,
        at position: Position,
        in context: (ScaleFactorProviding & LayoutDirectionProviding)
    ) -> CGRect {
        self.rect(
            toFill: rect,
            at: position,
            in: context.pixelsPerPoint,
            layoutDirection: context.effectiveUserInterfaceLayoutDirection
        )
    }

    /// An "aspect-fill" function that determines the smallest rect of the receiver's aspect ratio that fits a rect
    /// within it.
    ///
    /// - parameter rect: The bounding rect.
    /// - parameter position: The location within the bounding rect for the new rect, determining where margin(s) will
    /// be if the aspect ratios do not match perfectly.
    /// - parameter scale: The number of pixels per point.
    /// - parameter layoutDirection: The effective layout direction of the view in which the `rect` is defined.
    /// - returns: A rect with the receiver's aspect ratio, strictly containing the bounding rect.
    public func rect(
        toFill rect: CGRect,
        at position: Position,
        in scale: CGFloat,
        layoutDirection: UIUserInterfaceLayoutDirection
    ) -> CGRect {
        CGRect(
            size: size(toFill: rect.size, in: scale),
            at: position,
            of: rect,
            in: scale,
            layoutDirection: layoutDirection
        )
    }

}

// MARK: -

extension CGSize {

    /// The aspect ratio of this size.
    public var aspectRatio: AspectRatio {
        AspectRatio(size: self)
    }

}

extension CGRect {

    // MARK: - Public Properties

    /// The aspect ratio of this rect's size.
    public var aspectRatio: AspectRatio {
        AspectRatio(size: size)
    }

    // MARK: - Life Cycle

    @MainActor
    fileprivate init(
        size newSize: CGSize,
        at position: Position,
        of alignmentRect: CGRect,
        in scaleFactor: ScaleFactorProviding,
        layoutDirection: UIUserInterfaceLayoutDirection
    ) {
        self.init(
            size: newSize,
            at: position,
            of: alignmentRect,
            in: scaleFactor.pixelsPerPoint,
            layoutDirection: layoutDirection
        )
    }

    fileprivate init(
        size newSize: CGSize,
        at position: Position,
        of alignmentRect: CGRect,
        in scale: CGFloat,
        layoutDirection: UIUserInterfaceLayoutDirection
    ) {
        let newOrigin: CGPoint

        if newSize.width == alignmentRect.width {
            // The width matches; position vertically.
            let newMinY: CGFloat
            switch ResolvedPosition(resolving: position, with: layoutDirection) {
            case .topLeft, .topCenter, .topRight:
                newMinY = alignmentRect.minY
            case .leftCenter, .center, .rightCenter:
                newMinY = (alignmentRect.midY - newSize.height / 2).roundedToPixel(in: scale)
            case .bottomLeft, .bottomCenter, .bottomRight:
                newMinY = alignmentRect.maxY - newSize.height
            }

            newOrigin = CGPoint(x: alignmentRect.minX, y: newMinY)

        } else {
            // The height matches; position horizontally.
            let newMinX: CGFloat
            switch ResolvedPosition(resolving: position, with: layoutDirection) {
            case .topLeft, .leftCenter, .bottomLeft:
                newMinX = alignmentRect.minX
            case .topCenter, .center, .bottomCenter:
                newMinX = (alignmentRect.midX - newSize.width / 2).roundedToPixel(in: scale)
            case .topRight, .rightCenter, .bottomRight:
                newMinX = alignmentRect.maxX - newSize.width
            }

            newOrigin = CGPoint(x: newMinX, y: alignmentRect.minY)
        }

        self.init(origin: newOrigin, size: newSize)
    }

}
