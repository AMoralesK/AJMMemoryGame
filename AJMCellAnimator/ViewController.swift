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
    
    var cardOne : DogCollectionViewCell?
    var cardTwo : DogCollectionViewCell?
    
    let game = MemoryGame()
    
    lazy var dogs : [String] = {
        var names : [String] = ["chihuahua", "dalmata", "labrador", "pastoraleman", "perrito"]
        names = names + names
        print("El arreglo \(names)")
        let shuffled = shuffleArray(items: names)
        print("El arreglo SHUFFLED \(shuffled)")
        return shuffled.flatMap({ (name) -> String? in
            return "\(name).jpg"
        })
    }()
    
    var lastTrackedCard : DogCollectionViewCell?
    
    
    func shuffleArray(items: [String]) -> [String] {
        var items = items
        var shuffled = [String]()
        for i in 0..<items.count
        {
            let rand = Int(arc4random_uniform(UInt32(items.count)))
            shuffled.append(items[rand])
            items.remove(at: rand)
        }
        return shuffled
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        
    }

}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCell", for: indexPath) as! DogCollectionViewCell
        let dog = dogs[indexPath.row]
        cell.dog = dog
        return cell
    }
    
    func isValid(_ card :  DogCollectionViewCell) -> Bool {
        guard let lastTrackedCard = lastTrackedCard else { return true }
        guard let indexPathOne =  collectionView.indexPath(for: card), let indexPathTwo = collectionView.indexPath(for: lastTrackedCard) else { return false }
        return (indexPathOne == indexPathTwo) ? false : true
    }
    func prepare(_ card :  DogCollectionViewCell) {
       
        if !isValid(card) {
            return
        }
        
        if cardOne == nil {
            cardOne = card
        } else if cardTwo == nil {
            cardTwo = card
        }
        
        guard let cardOne = cardOne, let cardTwo = cardTwo else { return }
        game.revealCards(cardOne: cardOne, cardTwo: cardTwo, completion: { [unowned self](status) in
            self.cardOne = nil
            self.cardTwo = nil
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DogCollectionViewCell
        prepare(cell)
        
        lastTrackedCard = cell

    }
}

