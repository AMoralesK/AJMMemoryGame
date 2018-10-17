//
//  MemoryGame.swift
//  AJMMemoryGame
//
//  Created by Morales, Angel (MX - Mexico) on 16/10/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import Foundation
import UIKit

class MemoryGame<T : Flippable>{
    
    private var cardOne : T?
    private var cardTwo : T?
    private var lastTrackedCard : T?

    init(cardOne : T? = nil, cardTwo : T? = nil) { }
    
    func isValid(_ card :  T, collectionView : UICollectionView) -> Bool {
        guard let lastTrackedCard = lastTrackedCard else { return true }
        guard let indexPathOne =  collectionView.indexPath(for: card as! UICollectionViewCell), let indexPathTwo = collectionView.indexPath(for: lastTrackedCard as! UICollectionViewCell) else { return false }
        return (indexPathOne == indexPathTwo) ? false : true
    }
    
    
    func prepare(_ card :  T, fromCollection collection: UICollectionView) {
        
        if !isValid(card, collectionView: collection) {
            lastTrackedCard = card
            return
        }
        
        if cardOne == nil {
            cardOne = card
        } else if cardTwo == nil {
            cardTwo = card
        }
        
        guard let cardOne = cardOne, let cardTwo = cardTwo else {
            lastTrackedCard = card
            return
        }
        
        revealCards(temp1: cardOne, temp2: cardTwo, completion: { [unowned self](status) in
            self.cardOne = nil
            self.cardTwo = nil
            self.lastTrackedCard = nil
        })
        
       
    }
    
    
    func revealCards(temp1 : T, temp2 : T, completion:@escaping (_ status : Bool) ->()) {
        
    
        let cardOne : UIView = temp1 as! UIView
        let cardTwo : UIView  = temp2 as! UIView

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
                        
                        temp1.reveal()
                        //cardOne.titleLabel.alpha = 1
                        //cardOne.imageView.alpha = 1
                        
                        cardTwo.layer.transform = CATransform3DMakeRotation(CGFloat(0), 0.0, 1.0, 0.0)
                        temp2.reveal()
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
            if !temp1.matches(elem: temp2) {
                self.reverseCards(temp1: temp1, temp2: temp2, completion: { (status) in
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
    
    func reverseCards(temp1 : T, temp2 : T, completion:@escaping (_ status : Bool) ->() ) {
        
        let cardOne : UIView = temp1 as! UIView
        let cardTwo : UIView  = temp2 as! UIView
        
        let animation = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animation.addAnimations {
            
            UIView.animateKeyframes(
                withDuration: 2.0,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2, animations: {
                        cardOne.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        temp1.unreveal()
                       // cardOne.titleLabel.alpha = 0
                       // cardOne.imageView.alpha = 0
                        
                        cardTwo.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi / 2), 0.0, 1.0, 0.0)
                        temp2.unreveal()
                        //  cardTwo.titleLabel.alpha = 0
                      //  cardTwo.imageView.alpha = 0
                        
                        
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                        cardOne.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0)
                        temp1.unreveal()
                      //  cardOne.titleLabel.alpha = 0
                      //  cardOne.imageView.alpha = 0
                        
                        cardTwo.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0.0)
                        temp2.unreveal()
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


protocol Flippable   {
    func reveal()
    func unreveal()
    func matches(elem : Flippable) -> Bool

   // func matches(cell : Flippable) -> Bool
 //   var flippableLayer : CALayer { set get }
 //   var isUserInteractionEnabled : Bool { set get }
}



