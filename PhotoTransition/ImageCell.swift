//
//  ImageCell.swift
//  PhotoTransition
//
//  Created by Amir Rezvani on 7/20/18.
//  Copyright © 2018 Amir Rezvani. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var photoView: UIImageView!
    
    var locationPhoto: UIImage? {
        didSet {
            photoView.image = locationPhoto
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
    
    
}
