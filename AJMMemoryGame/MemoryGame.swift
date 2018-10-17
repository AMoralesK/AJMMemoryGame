//
//  MemoryGame.swift
//  AJMMemoryGame
//
//  Created by Morales, Angel (MX - Mexico) on 16/10/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import Foundation
import UIKit

protocol MemoryGame {
    
    func revealCards(cardOne : Flippable, cardTwo : Flippable, completion:@escaping (_ status : Bool) ->())
    func reverseCards(cardOne : Flippable, cardTwo : Flippable, completion:@escaping (_ status : Bool) ->())
}

extension MemoryGame {
    
    func revealCards(cardOne : Flippable, cardTwo : Flippable, completion:@escaping (_ status : Bool) ->()) {
        
        var cardOne = cardOne
        var cardTwo = cardTwo

        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        
        cardOne.flippableLayer.sublayerTransform = transform
        cardTwo.flippableLayer.sublayerTransform = transform
        
        let animation = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animation.addAnimations {
            
            UIView.animateKeyframes(
                withDuration: 2.0,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                        cardOne.flippableLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        cardTwo.flippableLayer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                        
                        cardOne.flippableLayer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
                        cardOne.reveal()
                        //cardOne.titleLabel.alpha = 1
                        //cardOne.imageView.alpha = 1
                        
                        cardTwo.flippableLayer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
                        cardTwo.reveal()
                       // cardTwo.titleLabel.alpha = 1
                       // cardTwo.imageView.alpha = 1
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                        
                    })
            },
                completion: { _ in
            })
        }
        
        animation.addCompletion { (position) in
            print(position)
            if !cardOne.matches(cell: cardTwo) {
                self.reverseCards(cardOne: cardOne, cardTwo: cardTwo, completion: { (status) in
                    completion(true)
                })
            } else {
                
                cardOne.isUserInteractionEnabled = false
                cardTwo.isUserInteractionEnabled = false
                
                cardOne.flippableAlpha = 0.5
                cardTwo.flippableAlpha = 0.5
                completion(true)
            }
            
        }
        
        animation.startAnimation()
    }
    
    func reverseCards(cardOne : Flippable, cardTwo : Flippable, completion:@escaping (_ status : Bool) ->() ) {
        
        let animation = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animation.addAnimations {
            
            UIView.animateKeyframes(
                withDuration: 2.0,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2, animations: {
                        cardOne.flippableLayer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        cardOne.unreveal()
                       // cardOne.titleLabel.alpha = 0
                       // cardOne.imageView.alpha = 0
                        
                        cardTwo.flippableLayer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        cardTwo.unreveal()
                        //  cardTwo.titleLabel.alpha = 0
                      //  cardTwo.imageView.alpha = 0
                        
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                        cardOne.flippableLayer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0)
                        cardOne.unreveal()
                      //  cardOne.titleLabel.alpha = 0
                      //  cardOne.imageView.alpha = 0
                        
                        cardTwo.flippableLayer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0)
                        cardTwo.unreveal()
                     //   cardTwo.titleLabel.alpha = 0
                     //   cardTwo.imageView.alpha = 0
                        
                        
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


protocol Flippable {
    func reveal()
    func unreveal()
    func matches(cell : Flippable) -> Bool
    var flippableLayer : CALayer { set get }
    var flippableAlpha : CGFloat { set get }
    var isUserInteractionEnabled : Bool { set get }
}
