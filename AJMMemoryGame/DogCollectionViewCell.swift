//
//  DogCollectionViewCell.swift
//  AJMCellAnimator
//
//  Created by Morales, Angel (MX - Mexico) on 13/02/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit


class DogCollectionViewCell: UICollectionViewCell, Flippable {
   
    func reveal() {
        titleLabel.alpha = 1
        imageView.alpha = 1
    }
    
    func unreveal() {
       titleLabel.alpha = 0
       imageView.alpha = 0
    }
    
    func matches(elem : Flippable) -> Bool {
         guard let isDogCell = elem as? DogCollectionViewCell else { return false }
         return dog == isDogCell.dog
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var dog : String! {
        didSet {
            titleLabel.text = dog
            imageView.image = UIImage(named: dog)
            imageView.contentMode = .scaleAspectFit
            imageView.alpha = 0
            titleLabel.alpha = 0
            layer.cornerRadius = CGFloat(10.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
