// Created by Nick Entin on 10/3/25.

import Foundation
import UIKit

extension Alignable {

    public func align(
        _ position: Position,
        with otherView: Alignable,
        _ otherPosition: Position,
        alignmentBehavior: TargetAlignmentBehavior = .automatic,
        translatedBy distance: CGFloat,
        along angle: Angle,
        offsetBy additionalOffset: UIOffset = .zero,
    ) {
        let offset = angle.point(atDistance: distance, from: .zero)
        align(
            position,
            with: otherView,
            otherPosition,
            alignmentBehavior: alignmentBehavior,
            horizontalOffset: offset.x + additionalOffset.horizontal,
            verticalOffset: offset.y + additionalOffset.vertical,
        )
    }

}
