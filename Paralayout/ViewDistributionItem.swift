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

/*

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

*/
