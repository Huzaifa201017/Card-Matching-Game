//
//  Model.swift
//  CardApp
//
//  Created by Huzaifa farooqi on 03/02/2022.
//

import Foundation
class cardModel{
    
    func getCards() -> [Card] {
        var card_arr = [Card]()
      
        var randomNum = 0
        
        var arr = [Int]()
        
        while(arr.count != 8){
            randomNum = (Int).random(in: 1...13)
            if !arr.contains(randomNum){
                arr += [randomNum]
                print(randomNum)
                let card1 = Card()
                let card2 = Card()


                card1.imageName = "card\(randomNum)"
                card2.imageName = "card\(randomNum)"
                card_arr += [card1 , card2]
                
            }
        }
        card_arr.shuffle()
        return card_arr
    }
}
