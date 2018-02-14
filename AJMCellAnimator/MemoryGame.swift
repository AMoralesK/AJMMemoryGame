//
//  MemoryGame.swift
//  AJMCellAnimator
//
//  Created by Morales, Angel (MX - Mexico) on 13/02/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit
import Foundation

class MemoryGame {
    
    func revealCards(cardOne : DogCollectionViewCell, cardTwo : DogCollectionViewCell, completion:@escaping (_ status : Bool) ->()) {
       
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        
        cardOne.layer.sublayerTransform = transform
        cardTwo.layer.sublayerTransform = transform
        
        let animation = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animation.addAnimations {
            
            UIView.animateKeyframes(
                withDuration: 2.0,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                        cardOne.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        cardTwo.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                        
                        cardOne.layer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
                        cardOne.titleLabel.alpha = 1
                        cardOne.imageView.alpha = 1
                        
                        cardTwo.layer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
                        cardTwo.titleLabel.alpha = 1
                        cardTwo.imageView.alpha = 1
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                        
                    })
            },
                completion: { _ in
            })
        }
        
        animation.addCompletion { (position) in
            print(position)
            
            completion(true)
        }
        
        animation.startAnimation()
    }
    
    func reverseCards(cardOne : DogCollectionViewCell, cardTwo : DogCollectionViewCell) {
        
    }
    
}
