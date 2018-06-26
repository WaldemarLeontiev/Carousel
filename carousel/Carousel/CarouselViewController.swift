//
//  CarouselViewController.swift
//  carousel
//
//  Created by Waldemar on 25/06/2018.
//  Copyright © 2018 h7.com. All rights reserved.
//

import UIKit

protocol CarouselViewControllerDelegate: class {
    var carouselViewWidth: CGFloat {get}
    var carouselViewDistance: CGFloat {get}
    var carouselViewDecreaseRatio: CGFloat {get}
    var carouselViewsCount: Int {get}
    func getCarouselView(at index: Int) -> UIView
}

class CarouselViewController: UIViewController {
    
    weak var delegate: CarouselViewControllerDelegate?
    
    // MARK: - UI objects
    private(set) lazy var scrollView = self.makeScrollView()
    
    // MARK: - Variables
    private(set) lazy var allViews = self.getAllViews()
    private var sideInset: CGFloat = 0
    
    // MARK: - Init
    init(delegate: CarouselViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateScrollViewInsets()
    }
}

// MARK: - Data & Calculations
extension CarouselViewController {
    private func getAllViews() -> [UIView] {
        guard let delegate = self.delegate else {
            return []
        }
        var allViews: [UIView] = []
        for index in 0..<delegate.carouselViewsCount {
            allViews.append(delegate.getCarouselView(at: index))
        }
        return allViews
    }
    private func getCurrentDistance(for index: Int) -> CGFloat {
        guard let delegate = self.delegate else {
            return 0
        }
        let cellWidth = delegate.carouselViewWidth + self.correctedSpacing
        let currentX = self.scrollView.contentOffset.x + self.sideInset
        let cellDistance = cellWidth * CGFloat(index)
        return (cellDistance - currentX) / cellWidth
    }
    private var correctedSpacing: CGFloat {
        guard let delegate = self.delegate else {
            return 0
        }
        return delegate.carouselViewDistance - delegate.carouselViewWidth * (1 - delegate.carouselViewDecreaseRatio) / 2
    }
}

// MARK: - UI updates
extension CarouselViewController {
    private func updateScrollViewInsets() {
        guard let delegate = self.delegate else {
            return
        }
        self.sideInset = (self.scrollView.bounds.width - delegate.carouselViewWidth) / 2
        let currentInset = self.scrollView.contentInset
        self.scrollView.contentInset = UIEdgeInsets(top: currentInset.top,
                                                    left: self.sideInset,
                                                    bottom: currentInset.bottom,
                                                    right: self.sideInset)
    }
}

// MARK: - UI
extension CarouselViewController {
    private func setupUI() {
        guard let delegate = self.delegate else {
            return
        }
        self.view.add(self.scrollView)
        self.scrollView.makeSuperviewInsetConstraints(top: 0, bottom: 0, left: 0, right: 0)
        for (index, view) in self.allViews.enumerated() {
            self.scrollView.add(view)
            view.snp.makeConstraints { (make) in
                make.width.equalTo(delegate.carouselViewWidth)
                make.height.centerY.equalToSuperview()
                if index == 0 {
                    make.left.equalToSuperview()
                } else {
                    make.left.equalTo(self.allViews[index - 1].snp.right).offset(self.correctedSpacing)
                }
                if index == self.allViews.count - 1 {
                    make.right.equalToSuperview()
                }
            }
        }
    }
    
    // MARK: Constructors
    private func makeScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        return scrollView
    }
}

// MARK: - UIScrollViewDelegate
extension CarouselViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let delegate = self.delegate else {
            return
        }
        let targetX = targetContentOffset.pointee.x
        let cellWidth = delegate.carouselViewWidth + self.correctedSpacing
        let targetIndex = round((targetX + self.sideInset) / cellWidth)
        targetContentOffset.pointee.x = targetIndex * cellWidth - self.sideInset
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = self.delegate else {
            return
        }
        for (index, view) in self.allViews.enumerated() {
            let relativeDistance = self.getCurrentDistance(for: index)
            let absDistance = min(abs(relativeDistance), 1)
            let scale = 1 + (delegate.carouselViewDecreaseRatio - 1) * absDistance
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
