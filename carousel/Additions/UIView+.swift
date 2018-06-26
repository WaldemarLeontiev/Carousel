//
//  UIView+.swift
//  carousel
//
//  Created by Waldemar on 25/06/2018.
//  Copyright © 2018 h7.com. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    // MARK: - Subviews
    func add(_ views: UIView...) {
        views.forEach(self.addSubview)
    }
    func addFullSizeSubview(_ subview: UIView) {
        addSubview(subview)
        subview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Constraints
    @discardableResult
    func makeSizeConstraints(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        self.snp.makeConstraints { (make) in
            if let width = width {
                make.width.equalTo(width)
            }
            if let height = height {
                make.height.equalTo(height)
            }
        }
        return self
    }
    @discardableResult
    func makeSuperviewInsetConstraints(top: CGFloat? = nil,
                                       bottom: CGFloat? = nil,
                                       left: CGFloat? = nil,
                                       right: CGFloat? = nil) -> Self {
        self.snp.makeConstraints { (make) in
            if let top = top {
                make.top.equalToSuperview().inset(top)
            }
            if let bottom = bottom {
                make.bottom.equalToSuperview().inset(bottom)
            }
            if let left = left {
                make.left.equalToSuperview().inset(left)
            }
            if let right = right {
                make.right.equalToSuperview().inset(right)
            }
        }
        return self
    }
    @discardableResult
    func makeSuperviewCenterConstraints(xOffset: CGFloat? = nil, yOffset: CGFloat? = nil) -> Self {
        self.snp.makeConstraints { (make) in
            if let xOffset = xOffset {
                make.centerX.equalToSuperview().offset(xOffset)
            }
            if let yOffset = yOffset {
                make.centerY.equalToSuperview().offset(yOffset)
            }
        }
        return self
    }
    @discardableResult
    func makeSafeAreaInsetConstraints(top: CGFloat? = nil,
                                      bottom: CGFloat? = nil,
                                      left: CGFloat? = nil,
                                      right: CGFloat? = nil,
                                      ofViewController viewController: UIViewController) -> Self {
        self.snp.makeConstraints { (make) in
            if let top = top {
                if #available(iOS 11.0, *) {
                    make.top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top).offset(top)
                } else {
                    make.top.equalTo(viewController.topLayoutGuide.snp.bottom).offset(top)
                }
            }
            if let bottom = bottom {
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(viewController.view.safeAreaLayoutGuide.snp.bottom).offset(-bottom)
                } else {
                    make.bottom.equalTo(viewController.bottomLayoutGuide.snp.top).offset(-bottom)
                }
            }
            if let left = left {
                if #available(iOS 11.0, *) {
                    make.left.equalTo(viewController.view.safeAreaLayoutGuide.snp.left).offset(left)
                } else {
                    make.left.equalTo(viewController.view).offset(left)
                }
            }
            if let right = right {
                if #available(iOS 11.0, *) {
                    make.right.equalTo(viewController.view.safeAreaLayoutGuide.snp.right).offset(-right)
                } else {
                    make.right.equalTo(viewController.view).offset(-right)
                }
            }
        }
        return self
    }
}
