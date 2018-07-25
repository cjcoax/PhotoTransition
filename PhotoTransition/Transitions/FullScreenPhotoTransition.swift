//
//  FullScreenPhotoTransition.swift
//  PhotoTransition
//
//  Created by Amir Rezvani on 7/21/18.
//  Copyright © 2018 Amir Rezvani. All rights reserved.
//

import UIKit

class FullScreenPhotoTransition: NSObject, UIViewControllerAnimatedTransitioning {
    enum Action {
        case present
        case dismiss
    }
    
    private let presentDuration: TimeInterval = 0.8
    private let dismissDuration: TimeInterval = 0.8
    private var interactive = false
    
    let image: UIImage?
    let imageViewToExpand: UIImageView
    let center: CGPoint
    let imageViewSize: CGSize
    var action: Action = .present
    
    init(_ imageViewToExpand: UIImageView, _ center: CGPoint, _ imageViewSize: CGSize) {
        self.imageViewToExpand = imageViewToExpand
        self.image = imageViewToExpand.image
        self.center = center
        self.imageViewSize = imageViewSize
    }
    
    
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        switch action {
        case .present:
            return presentDuration
        default:
            return dismissDuration
        }
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch action {
        case .present:
            present(using: transitionContext)
        default:
            dismiss(using: transitionContext)
        }
    }
    
    private func present(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVc = transitionContext.viewController(forKey: .from) as? ThumbnailVC,
            let toVc = transitionContext.viewController(forKey: .to) as? DetailVC else {
                return
        }
        
        
        
        let oldFromViewColor = fromVc.view.backgroundColor
        fromVc.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        guard let fromSnapshot = fromVc.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        fromVc.view.backgroundColor = oldFromViewColor
        
        let container = transitionContext.containerView
        
        toVc.view.layoutIfNeeded()
        let tv = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tv.center = center
        tv.backgroundColor = UIColor.green
        
        container.addSubview(fromSnapshot)
        
        
        let photoImageView = UIImageView(frame: CGRect.zero)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.frame.size = imageViewSize
        photoImageView.center = center
        photoImageView.clipsToBounds = true
        photoImageView.image = image
        
        container.addSubview(photoImageView)
        //        container.addSubview(tv)
        print(photoImageView.frame.size)
        
        
        //        let finalFrame = transitionContext.finalFrame(for: toVc)
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: { //[weak self] in
                        //                        guard let `self` = self else {
                        //                            return
                        //                        }
                        
                        photoImageView.frame.size = toVc.scrollView.frame.size
                        photoImageView.center = toVc.scrollView.center
                        
        }) { [weak self] (completed) in
            guard let `self` = self else {
                return
            }
            
            fromSnapshot.removeFromSuperview()
            photoImageView.removeFromSuperview()
            container.addSubview(toVc.view)
            self.imageViewToExpand.image = nil
            self.imageViewToExpand.backgroundColor = UIColor.white
            toVc.transition = self
            transitionContext.completeTransition(completed)
        }
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromvc = transitionContext.viewController(forKey: .from) as? DetailVC,
            let tovc = transitionContext.viewController(forKey: .to) as? ThumbnailVC,
            let fromv = transitionContext.view(forKey: .from) else {
                return
        }
        
//        fromvc.view.backgroundColor = UIColor.white
        
        let container = transitionContext.containerView
        guard let tov = tovc.view else {
            return
        }
//        container.addSubview(tov)
//        tov.alpha = 0.0
        
        let replica = UIImageView(frame: CGRect.zero)
        replica.frame.size = fromvc.locationImageView.frame.size
        let locationImageViewCenter = fromv.center//fromvc.view.convert(fromvc.locationImageView.center, from: fromvc.scrollView)
        replica.center = locationImageViewCenter
        
        replica.image = fromvc.locationImageView.image
        replica.clipsToBounds = true
        replica.contentMode = fromvc.locationImageView.contentMode
        container.addSubview(replica)
        
        
        fromvc.locationImageView.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.9,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        guard let `self` = self else {
                            return
                        }
                        replica.frame.size = self.imageViewSize
                        replica.center = self.center
                        fromv.alpha = 0.0
                        tov.alpha = 1.0
                        
        }) { [weak self] (completed) in
            guard let `self` = self else {
                return
            }
            
            self.imageViewToExpand.image = self.image
            self.imageViewToExpand.backgroundColor = UIColor.clear
            fromv.removeFromSuperview()
            transitionContext.completeTransition(completed)
        }
        
    }
}



















