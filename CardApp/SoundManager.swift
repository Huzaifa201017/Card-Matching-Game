//
//  SoundManager.swift
//  CardApp
//
//  Created by Huzaifa farooqi on 06/02/2022.
//

import Foundation
import AVFoundation

class SoundManager{
    
    var audioPlayer:AVAudioPlayer?
    
    enum soundEffect{
        
        case flip
        case match
        case nomatch
        case shuffle
        
    }
    
    func playSound(effect: soundEffect){
        
        var soundFile = ""
        switch effect {
        case .flip:
            soundFile = "cardflip"
        case .match:
            soundFile = "dingcorrect"
        case .nomatch:
            soundFile = "dingwrong"
        case .shuffle:
            soundFile = "shuffle"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFile, ofType: ".wav")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(string: bundlePath!)
        
        
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer?.play()
        }catch{
            
            print("Cannot play the audio file")
        }
    }
}
