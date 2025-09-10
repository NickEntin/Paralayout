// Created by Nick Entin on 7/20/25.

import UIKit

@MainActor
public protocol HorizontallyDistributable {

//    var horizontalDistributionItem: HorizontalDistributionItem { get }

}

//@MainActor
//public struct HorizontalDistributionItem {
//
//    public var distributionItem: ViewDistributionItem
//
//    public var orthogonalAlignment: VerticalDistributionAlignment?
//
//}
//
//extension ViewDistributionItem: HorizontallyDistributable {
//
//    @MainActor
//    public var horizontalDistributionItem: HorizontalDistributionItem {
//        .init(distributionItem: self, orthogonalAlignment: nil)
//    }
//
//    @MainActor
//    public func withVerticalAlignment(_ orthogonalAlignment: VerticalDistributionAlignment) -> HorizontalDistributionItem {
//        .init(distributionItem: self, orthogonalAlignment: orthogonalAlignment)
//    }
//
//}
