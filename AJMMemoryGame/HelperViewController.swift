//
//  HelperViewController.swift
//  AJMMemoryGame
//
//  Created by Morales, Angel (MX - Mexico) on 18/10/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit

class HelperView : UIView, Flippable {
 
    func reveal() {
    }
    
    func unreveal() {
    }
    
    func matches(elem: Flippable) -> Bool {
        guard let otherView = elem as? HelperView, let color = otherView.backgroundColor else { return false }
        return color == self.backgroundColor!
    }
}

class HelperViewController: UIViewController, MemoryGameDelegate {

    var memoryGame : MemoryGame<HelperView>!
    
    @IBOutlet weak var viewOne: HelperView! {
        didSet {
            prepareTapGesture(viewOne)
        }
    }
    @IBOutlet weak var viewTwo: HelperView! {
        didSet {
            prepareTapGesture(viewTwo)
        }
    }
    @IBOutlet weak var viewThree: HelperView! {
        didSet {
            prepareTapGesture(viewThree)
        }
    }
    @IBOutlet weak var viewFour: HelperView! {
        didSet {
            prepareTapGesture(viewFour)
        }
    }
    
    @objc func tap(sender : UITapGestureRecognizer) {
        guard let helperView = sender.view as? HelperView else { return  }
        memoryGame.prepare(helperView) { (status) in
            print(status)
        }
        
    }
    
    func prepareTapGesture(_ sender : HelperView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        sender.addGestureRecognizer(tap)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoryGame = MemoryGame(usingGameDelegate: self)
    }
    
    
    func isUserPickingSameCard(cardOne: UIView, cardTwo: UIView) -> Bool {
      return cardOne.tag == cardTwo.tag
    }

    
    
}

