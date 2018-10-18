//
//  Flippable.swift
//  AJMMemoryGame
//
//  Created by Morales, Angel (MX - Mexico) on 17/10/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import Foundation


protocol Flippable {
    func reveal()
    func unreveal()
    func matches(elem : Flippable) -> Bool
}

protocol MemoryContainer {
    
}
