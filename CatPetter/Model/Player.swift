//
//  Player.swift
//  CatPetter
//
//  Created by Haley Jones on 5/15/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation

class Player{
    var delegate: PlayerDelegate?
    
    var level: Int{
        didSet{
            delegate?.levelChanged(sender: self)
            self.petPower = Int(Double(level) * 1.3)
        }
    }
    var hp: Int{
        didSet{
            delegate?.hpChanged(sender: self)
        }
    }
    var maxHP: Double = 10
    var petPower: Int
    var exp = 0
    var expToLevel = 10
    
    init(level: Int){
        self.level = level
        self.hp = Int((Double(level) * 1.8) * 5 )
        self.maxHP = (Double(level) * 1.8) * 5
        self.petPower = Int(Double(level) * 1.3)
    }
}

protocol PlayerDelegate{
    func hpChanged(sender: Player)
    func levelChanged(sender: Player)
}
