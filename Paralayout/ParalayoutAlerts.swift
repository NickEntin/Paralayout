//
//  Copyright © 2025 Block, Inc.
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

import Foundation
import os

private let ParalayoutLog = OSLog(subsystem: "com.squareup.Paralayout", category: "layout")

/// Triggered when an alignment method is called that uses mismatched position types, i.e. aligning a view's leading or
/// trailing edge to another view's left or right edge, or vice versa. This type of mismatch is likely to look correct
/// under certain circumstance, but may look incorrect when using a different user interface layout direction.
func ParalayoutAlertForMismatchedAlignmentPositionTypes() {
    os_log(
        "%@",
        log: ParalayoutLog,
        type: .default,
        """
        Paralayout detected an alignment with mismatched position types. Set a symbolic breakpoint for \
        \"ParalayoutAlertForMismatchedAlignmentPositions\" to debug. Call stack:
        \(Thread.callStackSymbols.dropFirst(2).joined(separator: "\n"))
        """
    )
}

/// Triggered when an alignment method is called that involves two views that are not installed in the same view
/// hierarchy. The behavior of aligning two views not in the same view hierarchy is undefined.
func ParalayoutAlertForInvalidViewHierarchy() {
    os_log(
        "%@",
        log: ParalayoutLog,
        type: .default,
        """
        Paralayout detected an alignment with an invalid view hierarchy. The views involved in alignment calls must \
        be in the same view hierarchy. Set a symbolic breakpoint for \"ParalayoutAlertForInvalidViewHierarchy\" to \
        debug. Call stack:
        \(Thread.callStackSymbols.dropFirst(1).joined(separator: "\n"))
        """
    )
}

/// Triggered when a slice method is called that involves slicing a rect by an amount larger than the rect's size in that dimension.
func ParalayoutAlertForInvalidSliceAmount() {
    os_log(
        "%@",
        log: ParalayoutLog,
        type: .default,
        """
        Paralayout detected a slice where the amount exceeded the available space in the given dimension. Set a \
        symbolic breakpoint for \"ParalayoutAlertForInvalidSliceAmount\" to debug. Call stack:
        \(Thread.callStackSymbols.joined(separator: "\n"))
        """
    )
}
