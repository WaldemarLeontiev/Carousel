//
//  UIViewController+.swift
//  carousel
//
//  Created by Waldemar on 25/06/2018.
//  Copyright © 2018 h7.com. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        self.add(child, toView: self.view)
    }
    
    func add(_ child: UIViewController, toView parentView: UIView) {
        self.addChildViewController(child)
        parentView.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func add(_ children: UIViewController...) {
        children.forEach(self.add)
    }
    
    func add(_ children: UIViewController..., toView parentView: UIView) {
        children.forEach({
            self.add($0, toView: parentView)
        })
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
