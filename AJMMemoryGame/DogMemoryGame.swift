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
        
        animation.addCompletion { [weak self](position) in
            print(position)
            if !cardOne.matches(cell: cardTwo) {
                self?.reverseCards(cardOne: cardOne, cardTwo: cardTwo, completion: { (status) in
                    completion(true)
                })
            } else {
                
                cardOne.isUserInteractionEnabled = false
                cardTwo.isUserInteractionEnabled = false
                
                cardOne.alpha = 0.5
                cardTwo.alpha = 0.5
                completion(true)
            }
            
        }
        
        animation.startAnimation()
    }
    
    func reverseCards(cardOne : DogCollectionViewCell, cardTwo : DogCollectionViewCell, completion:@escaping (_ status : Bool) ->() ) {
        
        let animation = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animation.addAnimations {
            
            UIView.animateKeyframes(
                withDuration: 2.0,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2, animations: {
                        cardOne.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        cardOne.titleLabel.alpha = 0
                        cardOne.imageView.alpha = 0
                        
                        cardTwo.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        cardTwo.titleLabel.alpha = 0
                        cardTwo.imageView.alpha = 0
                       
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                        cardOne.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0)
                        cardOne.titleLabel.alpha = 0
                        cardOne.imageView.alpha = 0
                        
                        cardTwo.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0)
                        cardTwo.titleLabel.alpha = 0
                        cardTwo.imageView.alpha = 0
      
                        
                    })


            },
                completion: { _ in
            })
        }
        
        animation.addCompletion { (position) in
           completion(true)
        }
        animation.startAnimation()
    }
    
}
