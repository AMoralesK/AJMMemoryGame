//
//  ViewController.swift
//  AJMCellAnimator
//
//  Created by Morales, Angel (MX - Mexico) on 13/02/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    lazy var dogs : [String] = {
        var names : [String] = ["chihuahua", "dalmata", "labrador", "pastoraleman", "perrito"]
        return names.flatMap({ (name) -> String? in
            return "\(name).jpg"
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        print(dogs)
        
    }

}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCell", for: indexPath) as! DogCollectionViewCell
        let dog = dogs[indexPath.row]
        cell.titleLabel.text = dog
        cell.imageView.image = UIImage(named: dog)
        cell.imageView.contentMode = .scaleAspectFit
        cell.imageView.alpha = 0
        cell.titleLabel.alpha = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DogCollectionViewCell
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
       
        cell.layer.sublayerTransform = transform

        let animation = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animation.addAnimations {
            
            UIView.animateKeyframes(
                withDuration: 2.0,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                        cell.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 1.0, 0.0)
                       
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                        
                        cell.layer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
                        cell.titleLabel.alpha = 1
                        cell.imageView.alpha = 1
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                        
                    })
            },
                completion: { _ in
            })
        }
       
        animation.startAnimation()
        
    }
}

