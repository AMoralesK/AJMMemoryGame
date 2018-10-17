//
//  MemoryGame.swift
//  AJMCellAnimator
//
//  Created by Morales, Angel (MX - Mexico) on 13/02/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit
import Foundation

class DogMemoryGame : MemoryGame {

    func reverseCards(cardOne: DogCollectionViewCell, cardTwo: DogCollectionViewCell, completion: @escaping (Bool) -> ()) {
        reverseCards(cardOne: cardOne, cardTwo: cardTwo, completion: completion)
    }

    func revealCards(cardOne: DogCollectionViewCell, cardTwo: DogCollectionViewCell, completion: @escaping (Bool) -> ()) {
        revealCards(cardOne: cardOne, cardTwo: cardTwo, completion: completion)

    }
    
}
