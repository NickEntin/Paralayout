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
public final class FixedDistributionProxy: VerticallyDistributable {

    // MARK: Initialization

    /// Creates a fixed distribution proxy of the specified length.
    ///
    /// When applying a distribution, this distribution proxy will be assigned a rect with the specified `length` along the axis of distribution.
    public init(length: CGFloat) {
        self.length = length
    }

    // MARK: Public

    /// The length along the axis of distribution this distribution proxy should be apportioned.
    public let length: CGFloat

    /// The resulting rect allocated to the proxy after distribution, in the coordinate space of the view in which the
    /// distribution was performed.
    ///
    /// - Warning: The value of this property is undefined until a distribution containing the proxy has been performed.
    public internal(set) var rect: CGRect = .null

    // MARK: ViewDistributionSpecifying

    public var verticalDistributionItem: VerticalDistributionItem {
        .fixedProxy(self)
    }

}
