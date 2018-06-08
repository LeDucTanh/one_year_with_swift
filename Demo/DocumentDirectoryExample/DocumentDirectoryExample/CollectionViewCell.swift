//
//  CollectionViewCell.swift
//  DocumentDirectoryExample
//
//  Created by MBA0202 on 5/27/18.
//  Copyright © 2018 MBA0202. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func config(image: UIImage?) {
        imageView.image = image
        tickImageView.isHidden = true
    }
    
    func select() {
        tickImageView.isHidden = false
        tickImageView.image = #imageLiteral(resourceName: "img_tick")
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 5
    }
}
