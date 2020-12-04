//
//  EncounterText.swift
//  CatPetter
//
//  Created by Haley Jones on 5/15/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import Foundation

struct EncounterText{
    
    static var shared = EncounterText()
    
    //properties. This will just be used for random stuff.
    
    var encounterStarts = ["notices you!", "suddenly appears!", "blocks your path!", "leaps from the shadows!", "just woke up!", "shifts from another dimension!", "dscends from on high!", "was here first!", "pretends not to notice you!", "closes in!", "declares a challenge!", "lands in front of you!", "craves a worthy challenger!"]
    var catNames = ["Frank", "Mittens", "Bubsy", "Peanut", "Douglas", "Victoria", "Scrambles", "Mika", "Rambo", "Jesse", "James", "Spike", "Caesar", "Admiral", "Captain", "Nancy", "Adeline", "Benedetta", "Belle", "Celestine", "Corona", "Kirin", "Damaris", "Django", "Edwin", "Brad Kitt", "Butch Catsidy", "Glub", "Dizzy", "Catt Damon", "Mr. Meowgi", "Banjo", "Iggy", "Nacho", "Jarvis", "Karren from Accounting", "Boof", "Jason Bourne", "Cat Benetar", "Mimosa"]
    var bossNames = ["Zeus", "Collosus", "Draygus", "Stormlord", "Zephyra", "Breezy", "Caliente", "Ringo", "Titan", "Kong", "Hercules", "Maximus", "Remington"]
    var bossTitles = ["King", "Queen", "Duke", "Dutchess", "Monarch", "Grand Chairman", "The Exalted", "Archlord", "The Infernal", "Voidsent", "General", "Head Honcho", "Tough Guy", "The Legendary"]
    var catActions = ["turns away!", "doesn't seem interested!", "starts to walk away!", "seems more interested in someone else.", "doesn't seem impressed.", "won't even look at you.", "doesn't speak. The silence is very awkward.", "just wanted food, not attention.", "can't be bothered.", "just isn't feelig it.", "won't obey you without more badges.", "is loafing around", "is pretending to buffer slowly.", "meows at you, but like, in a snarky way.", "thinks you might be more of a dog person.", "seems to just want treats.", "looks at you judgementally.", "knocks some of your things over."]
    
    mutating func shuffleArrays(){
        encounterStarts.shuffle()
        catNames.shuffle()
        bossNames.shuffle()
    }
}
