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

public struct FlexibleSpacer {
    // MARK: Initialization

    public init(weight: CGFloat) {
        self.weight = weight
    }

    // MARK: Public

    public let weight: CGFloat
}

// MARK: -

extension CGFloat {

    /// Use the value as a flexible (proportional) spacer in a distribution.
    public var flexible: FlexibleSpacer {
        return .init(weight: self)
    }

}

extension Double {

    /// Use the value as a flexible (proportional) spacer in a distribution.
    public var flexible: FlexibleSpacer {
        return .init(weight: CGFloat(self))
    }

}

extension Int {

    /// Use the value as a flexible (proportional) spacer in a distribution.
    public var flexible: FlexibleSpacer {
        return .init(weight: CGFloat(self))
    }

}
