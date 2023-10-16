//
//  cardCollectionViewCell.swift
//  CardApp
//
//  Created by Huzaifa farooqi on 03/02/2022.
//

import UIKit

class cardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell (_ card:Card){
        
        self.card = card  // pointing the self.card to the specific card object of the array at specific index path .now all the changes will be in the array .
        self.frontImageView.image = UIImage(named: card.imageName)
        
        if self.card?.isMatched == true{
           
            self.frontImageView.alpha = 0
            self.backImageView.alpha = 0
            return
            
        }else{
            
            self.frontImageView.alpha = 1
            self.backImageView.alpha = 1
            
        }
        
        if self.card?.isFlipped == true{
            
            self.flipUp(0)
            
        }else{
            
            self.flipDown(0, 0)
        }
    }
    
    func flipUp(_ speed : TimeInterval = 0.3){
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options:[.transitionFlipFromLeft ,.showHideTransitionViews ], completion: nil)
        
        card?.isFlipped = true
        
    }
    
    func flipDown(_ speed : TimeInterval = 0.3 ,_  delay:TimeInterval = 0.5){
        
        card?.isFlipped = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options:[.transitionFlipFromLeft ,.showHideTransitionViews ], completion: nil)
        }
       
    }
    
    func remove(){
        
        self.backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options:.curveEaseOut , animations: {
            self.frontImageView.alpha = 0
            
        }, completion: nil)
    }
    
    
}
