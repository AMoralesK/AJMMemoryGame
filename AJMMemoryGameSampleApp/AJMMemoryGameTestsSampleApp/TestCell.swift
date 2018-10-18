//
//  TestCell.swift
//  AJMMemoryGameTests
//
//  Created by Morales, Angel (MX - Mexico) on 17/10/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import UIKit
@testable import AJMMemoryGame

class TestCell : UICollectionViewCell, Flippable {
    
    let testLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(testLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reveal() {
        testLabel.alpha = 0
    }
    
    func unreveal() {
         testLabel.alpha = 1
    }
    
    func matches(elem: Flippable) -> Bool {
        guard let cell = elem as? TestCell else { return false }
        return testLabel.text == cell.testLabel.text
    }

    
}
