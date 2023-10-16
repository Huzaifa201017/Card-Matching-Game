//
//  ViewController.swift
//  CardApp
//
//  Created by Huzaifa farooqi on 03/02/2022.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerView: UILabel!
    
    
    var model = cardModel()
    var cards = [Card]()
    var index:IndexPath?
    var timer:Timer?
    var milliSecond = 20 * 1000
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cards = model.getCards()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        soundPlayer.playSound(effect: .shuffle)
    }

    // MARK: - Collection view delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // Create the collection view cell

        // This method actually return the cell for index path , if we have newly demanded for this object then it would create a new one but if we had scrolled some object then that object will stay in the memory and would be  recycled(dequued) and when needed it would be again appeared

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! cardCollectionViewCell

        // configuration Done
        cell.configureCell(cards[indexPath.row])
        // return it
        return cell
    }
    
    // Now here is something tricky , actually the track of bollean variables like is matched or is flipped , they are changed in the array so as we know that collection view is memory efficient and it uses the previously allocated object that is scrolled up for the screen that is currently can be seen at present . So when in configure method we make self.card = card, we are actually pointing that self.card at this card in the array as passed in the parameter . when we flip up or flip down we are actually making changes iin the array . wo when we check that whether the card is flipped or not we are actually checking in the array at the element to which the card is pointing currently .
    
    // Suppose we fliiped the first box now the object of this collecton view cell has been created and when we scroll it up , last box is assigned this object . now it will be flipped as we have fliiped the first box , now we check in array if that last box was fliiped or not , if it is not then we will flip down this object . so we will see in the last object that it is not fliiped . all of this is because CV is memory efficient .
    
    func collectionView(_ collectionView:UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell = collectionView.cellForItem(at: indexPath)as? cardCollectionViewCell
        
        // optional condition after '&&'
        if cards[indexPath.row].isFlipped == false && cards[indexPath.row].isMatched == false && milliSecond != 0 {
           
            cell?.flipUp()
            
            soundPlayer.playSound(effect: .flip)
            
            if self.index == nil{
                self.index = indexPath
                
            }else{
                
                self.checkCards(indexPath)
                self.index = nil
                
            }
            
        }
        
    }
    
    func checkCards(_ secondIndexPath: IndexPath){
        
        let card2 = cards[secondIndexPath.row]
        let card1 = cards[index!.row]
        
        let cardCell1 = collectionView.cellForItem(at: index!) as?cardCollectionViewCell
        
        let cardCell2 = collectionView.cellForItem(at: secondIndexPath)as?cardCollectionViewCell
        
        
        if cards[secondIndexPath.row].imageName == cards[index!.row].imageName{
            
            // cardsMatched , now remove them
            card1.isMatched  = true
            card2.isMatched = true
            
            cardCell1?.remove()
            cardCell2?.remove()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
                self.soundPlayer.playSound(effect: .match)
            }
            
        }else{
            
            // flip them down again
            
            card1.isFlipped = false
            card2.isFlipped = false
            
            cardCell1?.flipDown()
            cardCell2?.flipDown()
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                
                self.soundPlayer.playSound(effect: .nomatch)
            }
            //soundPlayer.playSound(effect: .nomatch)
        }
    }

    
    @objc func timerFired (){
        
        milliSecond -= 1
        
        let seconds:Double = Double(milliSecond) / 1000.0
        
        timerView.text = String (format: "Time Remaining: %.2f",  seconds)
        
        if milliSecond == 0 {
            
            timerView.textColor = UIColor.red
            timer?.invalidate()
            
            checkForEndGame()
        }
        
    }
    
    func checkForEndGame (){
        
        var isWin = true
        
        for card in cards {
            
            if card.isMatched == false{
                
                isWin = false
                break
            }
        }
        
        if isWin {
            showAlert(title: "Congratulations!", message: "You've won the game!")
        
        }else{
            
            showAlert(title: "Sorry!", message: "Better Luck next time!")
        }
    }
    
    func showAlert (title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAlert)
        
        present (alert , animated: true , completion: nil)
    }
}

