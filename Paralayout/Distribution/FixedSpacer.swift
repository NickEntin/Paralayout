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

public struct FixedSpacer {
    // MARK: Initialization

    public init(length: CGFloat) {
        self.length = length
    }

    // MARK: Public

    public let length: CGFloat // @NICK TODO: Should this be a CGSize
}

// MARK: -

extension CGFloat {

    /// Use the value as a fixed spacer in a distribution.
    public var fixed: FixedSpacer {
        return .init(length: self)
    }

}

extension Double {

    /// Use the value as a fixed spacer in a distribution.
    public var fixed: FixedSpacer {
        return .init(length: CGFloat(self))
    }

}

extension Int {

    /// Use the value as a fixed spacer in a distribution.
    public var fixed: FixedSpacer {
        return .init(length: CGFloat(self))
    }

}
