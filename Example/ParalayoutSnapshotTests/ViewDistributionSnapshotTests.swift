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

import Paralayout
import SnapshotTesting
import UIKit

final class ViewDistributionSnapshotTests: SnapshotTestCase {

    @MainActor
    func testDistribution() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        containerView.backgroundColor = .white

        let secondView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        secondView.backgroundColor = .blue
        containerView.addSubview(secondView)

        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        firstView.backgroundColor = .red
        containerView.addSubview(firstView)

        let thirdView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
        thirdView.backgroundColor = .green
        containerView.addSubview(thirdView)

        containerView.applyVerticalSubviewDistribution(
            [
                1.flexible,
                firstView,
                1.flexible,
                secondView,
                1.flexible,
                thirdView,
                1.flexible,
            ]
        )
        assertSnapshot(matching: containerView, as: .image, named: nameForSnapshot(with: ["vertical"]))
    }

    @MainActor
    func testDistributionIgnoresTransform() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        containerView.backgroundColor = .white

        let secondView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        secondView.backgroundColor = .blue
        secondView.transform = CGAffineTransform(scaleX: 3, y: 3).rotated(by: .pi / 3)
        containerView.addSubview(secondView)

        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        firstView.backgroundColor = .red
        containerView.addSubview(firstView)

        let thirdView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
        thirdView.backgroundColor = .green
        containerView.addSubview(thirdView)

        containerView.applyVerticalSubviewDistribution(
            [
                1.flexible,
                firstView,
                1.flexible,
                secondView,
                1.flexible,
                thirdView,
                1.flexible,
            ]
        )
        assertSnapshot(matching: containerView, as: .image, named: nameForSnapshot(with: []))
    }

    @MainActor
    func testDistributionUsingCapInsets() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        containerView.backgroundColor = .white

        let topView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        topView.backgroundColor = .red
        containerView.addSubview(topView)

        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        bottomView.backgroundColor = .green
        containerView.addSubview(bottomView)

        let label = UILabel()
        label.text = "HÉLLÖ Worldy"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.sizeToFit()
        containerView.addSubview(label)

        containerView.applyVerticalSubviewDistribution(
            [
                1.flexible,
                topView,
                label.distributionItemUsingCapInsets,
                bottomView,
                1.flexible,
            ]
        )

        assertSnapshot(matching: containerView, as: .image, named: nameForSnapshot(with: []))
    }

    @MainActor
    func testHorizontalDistributionFollowsLayoutDirection() {
        let view = HorizontalDistributionView(frame: CGRect(x: 0, y: 0, width: 160, height: 60))

        assertSnapshot(
            matching: view,
            as: .image,
            named: nameForSnapshot(with: ["LTR"])
        )
        assertSnapshot(
            matching: view,
            as: .image(traits: .init(layoutDirection: .rightToLeft)),
            named: nameForSnapshot(with: ["RTL"])
        )
    }

    @MainActor
    func testHorizontalDistributionAlongBaseline() {
        final class TestView: UIView {

            // MARK: Initialization

            override init(frame: CGRect) {
                super.init(frame: frame)

                referenceView.backgroundColor = .black.withAlphaComponent(0.1)
                addSubview(referenceView)

                label1.font = .systemFont(ofSize: 12)
                label1.text = "Hello worldy"
                label1.textColor = .black
                addSubview(label1)

                label2.font = .systemFont(ofSize: 16)
                label2.text = "Hello worldy"
                label2.textColor = .black
                addSubview(label2)

                label3.font = .boldSystemFont(ofSize: 14)
                label3.text = "Hello worldy"
                label3.textColor = .black
                addSubview(label3)

                backgroundColor = .white
            }

            @available(*, unavailable)
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            // MARK: Private

            private let label1: UILabel = .init()

            private let label2: UILabel = .init()

            private let label3: UILabel = .init()

            private let referenceView: UIView = .init()

            // MARK: UIView

            override func layoutSubviews() {
                label1.sizeToFit()
                label2.sizeToFit()
                label3.sizeToFit()

                applyHorizontalSubviewDistribution(
                    [
                        1.flexible,
                        label1.distributionItemUsingCapInsets,
                        1.flexible,
                        label2.distributionItemUsingCapInsets,
                        1.flexible,
                        label3.distributionItemUsingCapInsets,
                        1.flexible,
                    ],
                    inRect: bounds.insetBy(bottom: 8),
                    orthogonalAlignment: .bottom(inset: 0)
                )

                referenceView.untransformedFrame = bounds.slice(from: .maxYEdge, amount: 8).slice
            }

        }

        assertSnapshot(
            matching: TestView(frame: .init(x: 0, y: 0, width: 400, height: 64)),
            as: .image,
            named: nameForSnapshot(with: [])
        )
    }

    @MainActor
    func testFlexibleDistributionProxy() {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        containerView.backgroundColor = .white

        let firstView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        firstView.backgroundColor = .blue.withAlphaComponent(0.5)
        containerView.addSubview(firstView)

        let secondView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        secondView.backgroundColor = .blue.withAlphaComponent(0.5)
        containerView.addSubview(secondView)

        let firstProxy = FlexibleDistributionProxy(weight: 1)
        let firstProxyView = UIView(frame: .zero)
        firstProxyView.backgroundColor = .red.withAlphaComponent(0.5)
        containerView.addSubview(firstProxyView)

        let secondProxy = FlexibleDistributionProxy(weight: 2)
        let secondProxyView = UIView(frame: .zero)
        secondProxyView.backgroundColor = .green.withAlphaComponent(0.5)
        containerView.addSubview(secondProxyView)

        containerView.semanticContentAttribute = .forceLeftToRight
        containerView.applyHorizontalSubviewDistribution(inRect: containerView.bounds.insetBy(left: 10, top: 20, right: 30, bottom: 40)) {
            firstView
            firstProxy
            secondView
            secondProxy
        }
        firstProxyView.frame = firstProxy.rect
        secondProxyView.frame = secondProxy.rect
        assertSnapshot(of: containerView, as: .image, named: nameForSnapshot(with: ["horizontal", "LTR"]))

        containerView.semanticContentAttribute = .forceRightToLeft
        containerView.applyHorizontalSubviewDistribution(inRect: containerView.bounds.insetBy(left: 10, top: 20, right: 30, bottom: 40)) {
            firstView
            firstProxy
            secondView
            secondProxy
        }
        firstProxyView.frame = firstProxy.rect
        secondProxyView.frame = secondProxy.rect
        assertSnapshot(of: containerView, as: .image, named: nameForSnapshot(with: ["horizontal", "RTL"]))

        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 400)
        containerView.applyVerticalSubviewDistribution(inRect: containerView.bounds.insetBy(left: 10, top: 20, right: 30, bottom: 40)) {
            firstView
            firstProxy
            secondView
            secondProxy
        }
        firstProxyView.frame = firstProxy.rect
        secondProxyView.frame = secondProxy.rect
        assertSnapshot(of: containerView, as: .image, named: nameForSnapshot(with: ["vertical"]))
    }

}

// MARK: -

extension UISemanticContentAttribute {

    static func attributeToForce(_ layoutDirection: UIUserInterfaceLayoutDirection) -> UISemanticContentAttribute {
        switch layoutDirection {
        case .leftToRight:
            return .forceLeftToRight
        case .rightToLeft:
            return .forceRightToLeft
        @unknown default:
            fatalError("Unknown layout direction")
        }
    }

}

extension UIUserInterfaceLayoutDirection {

    var testDescription: String {
        switch self {
        case .leftToRight:
            return "LTR"
        case .rightToLeft:
            return "RTL"
        @unknown default:
            fatalError("Unknown layout direction")
        }
    }

}

// MARK: -

final class HorizontalDistributionView: UIView {

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        firstView.bounds.size = .init(width: 40, height: 40)
        firstView.backgroundColor = .red
        addSubview(firstView)

        secondView.bounds.size = .init(width: 40, height: 40)
        secondView.backgroundColor = .green
        addSubview(secondView)

        thirdView.bounds.size = .init(width: 40, height: 40)
        thirdView.backgroundColor = .blue
        addSubview(thirdView)

        // Set arbitrary semantic content attributes to ensure the layout relies on the _receiver's_ effective layout
        // direction, not that of the distributed views.
        firstView.semanticContentAttribute = .forceLeftToRight
        secondView.semanticContentAttribute = .forceRightToLeft

        backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let firstView: UIView = .init()

    private let secondView: UIView = .init()

    private let thirdView: UIView = .init()

    // MARK: - UIView

    override func layoutSubviews() {
        applyHorizontalSubviewDistribution(
            [
                1.flexible,
                firstView,
                1.flexible,
                secondView,
                1.flexible,
                thirdView,
                1.flexible,
            ]
        )
    }

}
