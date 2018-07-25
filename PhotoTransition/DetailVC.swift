//
//  DetailVC.swift
//  PhotoTransition
//
//  Created by Amir Rezvani on 7/20/18.
//  Copyright © 2018 Amir Rezvani. All rights reserved.
//

import UIKit
class DetailVC: UIViewController {
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let threshold: CGFloat = 0.2
    private var originalCenter: CGPoint!
    private var initialTouchPoint: CGPoint!
    
    var locationImage: UIImage?
    weak var transition: FullScreenPhotoTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationImageView.image = locationImage
        originalCenter = view.center
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        let translation = sender.translation(in: view)
        
        
        
        
        switch sender.state {
        case .began:
            initialTouchPoint  = sender.location(in: view.superview!)
        case .changed, .possible:
            self.view.frame.origin.y += translation.y
        case .ended:
            print(sender.location(in: view.superview!).y)
            print(initialTouchPoint.y)
            let percentage = (sender.location(in: view.superview!).y - initialTouchPoint.y)/view.frame.height
            print(percentage)
            
            guard percentage > threshold else {
                UIView.animate(withDuration: TimeInterval(max(abs(percentage), 0.3)),
                               delay: 0.0,
                               usingSpringWithDamping: 1.0,
                               initialSpringVelocity: 0.0,
                               options: .curveEaseOut,
                               animations: { [weak self] in
                                guard let `self` = self else {
                                    return
                                }
                                self.view.center = self.originalCenter
                },
                               completion: nil)
                return
            }
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: view)
    }
}


extension DetailVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return locationImageView
    }
}



















