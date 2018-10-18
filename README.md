# AJMMemoryGame

MemoryGame is a component written in Swift 4, it provides the flexibility you need in order to play memory using any view you setup and a have nice flipping animation 😃<br /><br />

To start playing <b>you need to set two rules</b> : 

<ul>
  <li>How MemoryGame will know if the same view was picked</li>
  <li>How MemoryGame will know if there's a match between views</li>
</ul>

## Usage
1. Import MemoryGame framework

```swift 
import AJMMemoryGame
```

2. Conform your Cards or Views to the Flippable protocol

  ```swift
  
 class CardView : UIView, Flippable {
 
    func reveal() {
    }
    
    func unreveal() {
    }
    
    func matches(elem: Flippable) -> Bool {
       return true
    }
}
  ```
  
3. You can perform a custom logic by implementing the functions `reveal()` and `unreveal()` like changing the alpha from your subviews.

4. Let memory game know that 2 cards match my implementing the Flippable `function matches(elem:)`. In this example two cards match if they have the same background color.

  ```swift
  func matches(elem: Flippable) -> Bool {
        guard let otherView = elem as? CardView, let color = otherView.backgroundColor else { return false }
        return color == self.backgroundColor!
    }
   ```

4. Conform your ViewController to the MemoryGameDelegate and implement the function `function isUserPickingSameCard(cardOne:cardTwo:)`. In this example, we know the user has picked the same card twice by comparing the tag attribute.

  ```swift
  func isUserPickingSameCard(cardOne: UIView, cardTwo: UIView) -> Bool {
      return cardOne.tag == cardTwo.tag
    }
  ```
  
5. Create a property of type `MemoryGame<Flippable>` on your ViewController like the following example:

  ```swift
class HelperViewController: UIViewController, MemoryGameDelegate {

    var memoryGame : MemoryGame<HelperView>!
    
```
6. Add your views to the MemoryGame by using the `prepare(_ card :  T, completion: ((_ status : GameStatus) -> Void)?)` function.

    ```swift
    @objc func tap(sender : UITapGestureRecognizer) {
        guard let helperView = sender.view as? HelperView else { return  }
       
       memoryGame.prepare(helperView) { (status) in
            print(status)
        }

    } 
 
7. A completionHandler will be called with one of the final status 
    ```swift 
    enum GameStatus{
         case pickOneMoreCard
         case sameCardPicked
         case cardsDontMatch
         case cardsMatch
    }
     ```

## Preview
![Preview](https://media.giphy.com/media/xUOwGbTSdQNORNuYLK/giphy.gif)
