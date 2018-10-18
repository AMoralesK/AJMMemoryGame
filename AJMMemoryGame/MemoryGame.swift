//
//  MemoryGame.swift
//  AJMMemoryGame
//
//  Created by Morales, Angel (MX - Mexico) on 16/10/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import Foundation
import UIKit

enum GameStatus{
    case pickOneMoreCard
    case sameCardPicked
    case cardsDontMatch
    case cardsMatch
}

protocol MemoryGameDelegate: class {
    func isUserPickingSameCard(cardOne : UIView, cardTwo : UIView) -> Bool
}

class MemoryGame<T : Flippable >{
    
    private var cardOne : T? = nil
    private var cardTwo : T? = nil
    private var lastTrackedCard : T? = nil
    var delegate : MemoryGameDelegate
    
    init(usingGameDelegate delegate : MemoryGameDelegate) {
        self.delegate = delegate
    }
    
    private func isPickingSameCard(_ card :  T) -> Bool {
        let viewOne = card as! UIView
        let viewTwo = lastTrackedCard as! UIView
        let isPickingSameCard = delegate.isUserPickingSameCard(cardOne: viewOne, cardTwo: viewTwo)
        return isPickingSameCard
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
    
    func prepare(_ card :  T, completion: ((_ status : GameStatus) -> Void)?) {
        
        if cardOne == nil {
            cardOne = card
        } else if cardTwo == nil {
            cardTwo = card
        }
        
        guard let cardOne = cardOne, let cardTwo = cardTwo else {
            lastTrackedCard = card
            completion?(GameStatus.pickOneMoreCard)
            return
        }
        
        if isPickingSameCard(card) {
            self.cardOne = nil
            self.cardTwo = nil
            self.lastTrackedCard = nil
            completion?(GameStatus.sameCardPicked)
            return
        }
        
        revealCards(temp1: cardOne, temp2: cardTwo, completion: { [unowned self](status, gameStatus) in
            self.cardOne = nil
            self.cardTwo = nil
            self.lastTrackedCard = nil
            completion?(gameStatus)
        })
        
    }
    
    
    private func revealCards(temp1 : T, temp2 : T, completion:@escaping (_ status : Bool, _ gameStatus : GameStatus) ->()) {
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
                    completion(true, GameStatus.cardsDontMatch)
                })
            } else {
                
                cardOne.isUserInteractionEnabled = false
                cardTwo.isUserInteractionEnabled = false
                
                cardOne.alpha = 0.5
                cardTwo.alpha = 0.5
                completion(true, GameStatus.cardsMatch)
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



