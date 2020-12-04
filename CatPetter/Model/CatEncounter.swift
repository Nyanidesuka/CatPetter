//
//  CatEncounter.swift
//  CatPetter
//
//  Created by Haley Jones on 5/15/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation

class CatEncounter{
    let cat: Cat //hand in a fetched cat
    let catName: String //use a random name
    var catHP: Int //use the level
    let catLevel: Int //calculate based on ID
    let catMaxHP: Int
    
    init(cat: Cat, name: String, level: Int){
        self.cat = cat
        self.catName = name
        self.catMaxHP = Int(Double(level)  * 5)
        self.catHP = 0
        self.catLevel = level
    }
}
