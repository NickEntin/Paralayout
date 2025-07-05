//
//  Copyright © 2025 Nick Entin
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

@MainActor
public protocol Layoutable {

    var layoutItem: LayoutItem { get }

}

@MainActor
public struct LayoutItem {
    // MARK: - Life Cycle

    public init(
        view: UIView,
        layoutBounds: CGRect,
        sizeThatFits: @escaping (CGSize) -> CGSize
    ) {
        self.view = view
        self.layoutBounds = layoutBounds
        self.sizeThatFits = sizeThatFits
    }

    // MARK: - Public

    public var view: UIView

    public var layoutBounds: CGRect

    public var sizeThatFits: (_ availableSize: CGSize) -> CGSize

}

// MARK: -

extension UIView: Layoutable {

    public var layoutItem: LayoutItem {
        return LayoutItem(
            view: self,
            layoutBounds: bounds,
            sizeThatFits: self.sizeThatFits(_:)
        )
    }

}

// MARK: -

public struct InsetLayoutItem: Layoutable {

    // MARK: - Life Cycle

    public init(proxiedView: UIView, insets: UIEdgeInsets) {
        self.proxiedView = proxiedView
        self.insets = insets
    }

    // MARK: - Public Properties

    public let proxiedView: UIView

    public var insets: UIEdgeInsets

    // MARK: - Layoutable

    public var layoutItem: LayoutItem {
        return LayoutItem(
            view: proxiedView,
            layoutBounds: proxiedView.bounds.inset(by: insets),
            sizeThatFits: { availableSize in
                var availableSizeForView = CGRect(origin: .zero, size: availableSize).outset(by: insets)
                proxiedView.sizeThatFits(availableSizeForView.size)
                // @NICK TODO: Returning the larger size here won't work here when we apply constraints
            }
        )
    }

}
