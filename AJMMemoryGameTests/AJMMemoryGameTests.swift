//
//  AJMMemoryGameTests.swift
//  AJMMemoryGameTests
//
//  Created by Morales, Angel (MX - Mexico) on 17/10/18.
//  Copyright © 2018 TheKairuz. All rights reserved.
//

import XCTest
@testable import AJMMemoryGame


class AJMMemoryGameTests: XCTestCase {

    var collectionView : UICollectionView!
    
    class HelperVC : MemoryGameDelegate {
        func isUserPickingSameCard(cardOne: UIView, cardTwo: UIView) -> Bool {
            guard let cellOne = cardOne as? TestCell else { return true }
            guard let cellTwo = cardTwo as? TestCell else { return true }
            return cellOne.tag == cellTwo.tag
        }
    }
    
    override func setUp() {
        collectionView = UICollectionView(frame: CGRect.init(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
        XCTAssertNotNil(collectionView)

    }

    override func tearDown() { }

    func testSamePickedGame() {
        
        XCTAssertNotNil(collectionView)
        let cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: IndexPath(row: 0, section: 0)) as! TestCell
        XCTAssertNotNil(cellOne.testLabel)
        cellOne.testLabel.text = "Loro"
        cellOne.tag = 1
        
        let promise  = expectation(description: "Flipping time")
        
        let helper = HelperVC()
        let memoryGame = MemoryGame<TestCell>(usingGameDelegate: helper)
        
        memoryGame.prepare(cellOne, completion: { status in
            XCTAssert(status == GameStatus.pickOneMoreCard)
            memoryGame.prepare(cellOne, completion: { twoStatus in
                XCTAssert(twoStatus == GameStatus.sameCardPicked)
                promise.fulfill()
            })
        })
        
        waitForExpectations(timeout: 60, handler: nil)
        
    }
    
    func testCardsDontMatch() {
        XCTAssertNotNil(collectionView)
        let cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: IndexPath(row: 0, section: 0)) as! TestCell
        XCTAssertNotNil(cellOne.testLabel)
        cellOne.testLabel.text = "Loro"
        cellOne.tag = 1
        
        XCTAssertNotNil(collectionView)
        let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: IndexPath(row: 0, section: 0)) as! TestCell
        XCTAssertNotNil(cellOne.testLabel)
        cellTwo.testLabel.text = "Hamster"
        cellTwo.tag = 2
        
        let helper = HelperVC()
        let memoryGame = MemoryGame<TestCell>(usingGameDelegate: helper)
        
        let promise  = expectation(description: "Flipping time")
        memoryGame.prepare(cellOne, completion: { status in
            XCTAssert(status == GameStatus.pickOneMoreCard)
            memoryGame.prepare(cellTwo, completion: { twoStatus in
                print("Second Test : \(twoStatus)")
                XCTAssert(twoStatus == GameStatus.cardsDontMatch)
                promise.fulfill()
            })
        })
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testCardsMatch() {
        
        XCTAssertNotNil(collectionView)
        let cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: IndexPath(row: 0, section: 0)) as! TestCell
        XCTAssertNotNil(cellOne.testLabel)
        cellOne.testLabel.text = "Loro"
        cellOne.tag = 1
        
        XCTAssertNotNil(collectionView)
        let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: IndexPath(row: 0, section: 0)) as! TestCell
        XCTAssertNotNil(cellOne.testLabel)
        cellTwo.testLabel.text = "Loro"
        cellTwo.tag = 2
        
        let helper = HelperVC()
        let memoryGame = MemoryGame<TestCell>(usingGameDelegate: helper)
       
        let promise  = expectation(description: "Flipping time")
        memoryGame.prepare(cellOne, completion: { status in
            XCTAssert(status == GameStatus.pickOneMoreCard)
            memoryGame.prepare(cellTwo, completion: { twoStatus in
                print("Third Test : \(twoStatus)")
                XCTAssert(twoStatus == GameStatus.cardsMatch)
                promise.fulfill()
            })
        })
        waitForExpectations(timeout: 60, handler: nil)

    }
    
    func testPickOneMoreCard() {
        XCTAssertNotNil(collectionView)
        let cellOne = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: IndexPath(row: 0, section: 0)) as! TestCell
        XCTAssertNotNil(cellOne.testLabel)
        cellOne.testLabel.text = "Loro"
        cellOne.tag = 1
        
        XCTAssertNotNil(collectionView)
        let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: IndexPath(row: 0, section: 0)) as! TestCell
        XCTAssertNotNil(cellOne.testLabel)
        cellTwo.testLabel.text = "Loro"
        cellTwo.tag = 1
        
        let helper = HelperVC()
        let memoryGame = MemoryGame<TestCell>(usingGameDelegate: helper)
        
        let promise  = expectation(description: "Flipping time")
        memoryGame.prepare(cellOne, completion: { status in
            XCTAssert(status == GameStatus.pickOneMoreCard)
            memoryGame.prepare(cellTwo, completion: { twoStatus in
                XCTAssert(twoStatus == GameStatus.sameCardPicked)
                memoryGame.prepare(cellTwo, completion: { (thirdStatus) in
                    print("Fourth Test : \(thirdStatus)")
                     XCTAssert(thirdStatus == GameStatus.pickOneMoreCard)
                    promise.fulfill()
                })
                
            })
        })
        waitForExpectations(timeout: 60, handler: nil)
    }


}
