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
    var game : MemoryGame<DogCollectionViewCell>!
    
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
        game = MemoryGame<DogCollectionViewCell>(from: collectionView)
        
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


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DogCollectionViewCell
        game.prepare(cell, completion: { status in
          
            print(status)
            
        })
    }
}

