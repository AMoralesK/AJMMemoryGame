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
    
    private var cardOne : T? = nil
    private var cardTwo : T? = nil
    private var lastTrackedCard : T? = nil
    
    private func isValid(_ card :  T, collectionView : UICollectionView) -> Bool {
        guard let lastTrackedCard = lastTrackedCard else { return true }
        guard let indexPathOne =  collectionView.indexPath(for: card as! UICollectionViewCell), let indexPathTwo = collectionView.indexPath(for: lastTrackedCard as! UICollectionViewCell) else { return false }
        return (indexPathOne == indexPathTwo) ? false : true
    }
    
    private func flipAndReveal(card : T, by degrees : CGFloat) {
        let tempCard = card as! UIView
        tempCard.layer.transform = CATransform3DMakeRotation(degrees, 0.0, 1.0, 0.0)
        let hasFinished = degrees == CGFloat(0)
        if hasFinished {
            card.reveal()
        }
    }
    
    
    private func flipAndUnreveal(card : T, by degrees : CGFloat) {
        let tempCard = card as! UIView
        tempCard.layer.transform = CATransform3DMakeRotation(degrees, 0.0, 1.0, 0.0)
        card.unreveal()
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
    
    
    private func revealCards(temp1 : T, temp2 : T, completion:@escaping (_ status : Bool) ->()) {
        
    
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
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: { [weak self] in
                        self?.flipAndReveal(card: temp1, by: CGFloat(Double.pi / 2))
                        self?.flipAndReveal(card: temp2, by: CGFloat(Double.pi / 2))
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: { [weak self] in
                        self?.flipAndReveal(card: temp1, by: CGFloat(0))
                        self?.flipAndReveal(card: temp2, by: CGFloat(0))
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
    
    private func reverseCards(temp1 : T, temp2 : T, completion:@escaping (_ status : Bool) ->() ) {
        
        let animation = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)
        animation.addAnimations {
            
            UIView.animateKeyframes(
                withDuration: 2.0,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2, animations: { [weak self] in
                        self?.flipAndUnreveal(card: temp1, by: -CGFloat(Double.pi / 2))
                        self?.flipAndUnreveal(card: temp2, by: -CGFloat(Double.pi / 2))
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: { [weak self] in
                        self?.flipAndUnreveal(card: temp1, by: CGFloat(0))
                        self?.flipAndUnreveal(card: temp2, by: CGFloat(0))
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



