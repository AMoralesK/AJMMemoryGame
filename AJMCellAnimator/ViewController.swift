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
    lazy var dogs : [String] = {
        var names : [String] = ["chihuahua", "dalmata", "labrador", "pastoraleman", "perrito"]
        return names.flatMap({ (name) -> String? in
            return "\(name).jpg"
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        print(dogs)
        
    }

}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogCell", for: indexPath) as! DogCollectionViewCell
        let dog = dogs[indexPath.row]
        cell.titleLabel.text = dog
        cell.imageView.image = UIImage(named: dog)
        cell.imageView.contentMode = .scaleAspectFit
        return cell
    }
}

