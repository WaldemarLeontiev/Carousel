//
//  ViewController.swift
//  carousel
//
//  Created by Waldemar on 25/06/2018.
//  Copyright © 2018 h7.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var carouselViewController = CarouselViewController(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.add(self.carouselViewController)
        carouselViewController.view.makeSuperviewInsetConstraints(top: 64, bottom: 64, left: 0, right: 0)
    }
}

extension ViewController: CarouselViewControllerDelegate {
    var carouselViewWidth: CGFloat {
        return 200
    }
    
    var carouselViewDistance: CGFloat {
        return 16
    }
    
    var carouselViewDecreaseRatio: CGFloat {
        return 0.5
    }
    
    var carouselViewsCount: Int {
        return 5
    }
    
    func getCarouselView(at index: Int) -> UIView {
        let view = UIView()
        switch index {
        case 0:
            view.backgroundColor = .yellow
        case 1:
            view.backgroundColor = .blue
        case 2:
            view.backgroundColor = .red
        case 3:
            view.backgroundColor = .green
        case 4:
            view.backgroundColor = .gray
        default:
            break
        }
        return view
    }
    
}
