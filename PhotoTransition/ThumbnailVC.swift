//
//  ViewController.swift
//  PhotoTransition
//
//  Created by Amir Rezvani on 7/19/18.
//  Copyright © 2018 Amir Rezvani. All rights reserved.
//

import UIKit

class ThumbnailVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let datasource: [UIImage] = [#imageLiteral(resourceName: "h1"),#imageLiteral(resourceName: "h2"),#imageLiteral(resourceName: "h3"),#imageLiteral(resourceName: "h4"),#imageLiteral(resourceName: "h5"),#imageLiteral(resourceName: "h6"),#imageLiteral(resourceName: "h7"),#imageLiteral(resourceName: "h8"),#imageLiteral(resourceName: "h9")]
    fileprivate var selectedCenter: CGPoint?
    fileprivate var cellSize: CGSize?
    fileprivate var transition: FullScreenPhotoTransition?
    fileprivate var imageViewToExpand: UIImageView?
//    fileprivate let interactor = FullScreenInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func presentDetailVc(selectedIndexPath: IndexPath) {
        guard let tovc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailVc") as? DetailVC else {
            return
        }
        
        let locationImage = datasource[selectedIndexPath.item]
        tovc.modalPresentationStyle = UIModalPresentationStyle.custom
        tovc.transitioningDelegate = self
        tovc.locationImage = locationImage
        present(tovc, animated: true, completion: nil)
    }
}



extension ThumbnailVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        cell.locationPhoto = datasource[indexPath.item]
        return cell
    }
}


extension ThumbnailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width/2.0 - 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        let newPoint = CGPoint(x: cell.center.x,
                               y: cell.center.y)
        
        
        let newPointInCurrentViewCoord = collectionView.convert(newPoint, to: view)
        let tView = UIView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: 10,
                                         height: 10))
        
        tView.center = newPointInCurrentViewCoord
        tView.backgroundColor = UIColor.red
        
        view.addSubview(tView)
        
        DispatchQueue.main.asyncAfter(deadline: .now()  + 1.0) {
            tView.removeFromSuperview()
        }
        
        selectedCenter = newPointInCurrentViewCoord
        cellSize = cell.frame.size
        imageViewToExpand = (cell as? ImageCell)?.photoView
        
        presentDetailVc(selectedIndexPath: indexPath)
    }
}

extension ThumbnailVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let indexPaths = collectionView.indexPathsForSelectedItems,
            indexPaths.count == 1,
            let imageViewToExpand = self.imageViewToExpand,
            let selectedCenter = self.selectedCenter,
            let cellSize = self.cellSize else {
                return nil
        }
        
        transition = FullScreenPhotoTransition(imageViewToExpand, selectedCenter,cellSize)
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition?.action = .dismiss
        return transition
    }
}







