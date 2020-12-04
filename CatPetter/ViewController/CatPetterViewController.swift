//
//  CatPetterViewController.swift
//  CatPetter
//
//  Created by Haley Jones on 5/15/19.
//  Copyright © 2019 HaleyJones. All rights reserved.
//

import UIKit

class CatPetterViewController: UIViewController {

    //outlet
    @IBOutlet weak var catImageLabel: UIImageView!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var frameImage: UIImageView!
    @IBOutlet weak var petbutton: UIButton!
    @IBOutlet weak var catAffectionLabel: UILabel!
    @IBOutlet weak var playerLevelLabel: UILabel!
    @IBOutlet weak var playerPrideLabel: UILabel!
    @IBOutlet weak var screenCover: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var player: Player?
    var currentEncounter: CatEncounter?
    var gameState = "startingEncounter"{
        didSet{
            updatePetButton()
            guard let encounter = currentEncounter else {return}
            writeMessage(encounter: encounter)
            updateAffectionLabel(encounter: encounter)
            print(gameState)
            if (gameState == "loadingEncounter"){
                startNewEncounter()
            }
        }
    }
    
    var boxMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameState = "loadingEncounter"
        //hide screen to avoid a weirdo loading screen
        let playerLevel = 1
        
        player = Player(level: playerLevel)
        player?.delegate = self
        //fetch a cat, get its image, make sure to show the view when ur done
        startNewEncounter()
        playerLevelLabel.text = "LV. \(player?.level ?? 0)"
        playerPrideLabel.text = "Pride: \(player!.hp)/\(Int(player!.maxHP))"
    }
    
//    @IBAction func catButtonPressed(_ sender: Any) {
//        CatController.shared.fetchCat(apiKey: CatController.shared.apiKey) { (cat) in
//            guard let currentCat = cat else {return}
//            CatController.shared.fetchCatImage(cat: currentCat, apiKey: CatController.shared.apiKey, completion: { (catPic) in
//                DispatchQueue.main.async {
//
//                    self.catImageLabel.image = catPic
//                    self.frameImage.frame = self.catImageLabel.frame
//                    guard let cat = cat else {return}
//                    EncounterText.shared.shuffleArrays()
//                    let encounter = CatEncounter(cat: cat, name: EncounterText.shared.catNames.randomElement() ?? "", hp: 20, level: 1)
//                    self.writeMessage(encounter: encounter)
//                }
//            })
//        }
//    }
//
    
    
    @IBAction func petButtonPressed(_ sender: UIButton) {
        guard let encounter = currentEncounter else {return}
        switch gameState{
        case "startingEncounter":
            gameState = "chooseAction"
            return
        case "chooseAction":
            gameState = "rollForPet"
            return
        case "rollForPet":
            gameState = "petResults"
            return
        case "petResults":
            if encounter.catHP == encounter.catMaxHP{
                gameState = "catFriended"
                return
            } else {
                gameState = "catAction"
                return
            }
        case "catAction":
            gameState = "actionResult"
            return
        case "actionResult":
            gameState = "chooseAction"
            return
        case "catFriended":
            gameState = "endEncounter"
            return
        case "endEncounter":
            gameState = "expCalc"
        case "expCalc":
            gameState = "nextEncounter"
            return
        case "nextEncounter":
            gameState = "loadingEncounter"
            return
        default:
            return
        }
        
    }
    
    //a function to show the screen when loading is done
    func showScreen(){
        self.screenCover.alpha = 0
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0
        //make sure to write the message!
        guard let encounter = currentEncounter else {return}
        writeMessage(encounter: encounter)
    }
    
    //a function to hide the screen during loading
    func hideScreen(){
        self.screenCover.alpha = 1
        self.activityIndicator.startAnimating()
        self.activityIndicator.alpha = 1
    }
    
    //how effective is your pet???????
    func rollForPet() -> Int{
        guard let player = player else {return 0}
        let hitChance = Int.random(in: 0...20)
        guard hitChance != 0 else {gameState = "petResults"; return 0}
        let petMin = Int(player.petPower)
        let petMax = Int(Double(player.petPower) * 1.5)
        let petEffectiveness = Int.random(in: petMin...petMax)
        return petEffectiveness
    }
    //increase affection with that pet
    func petCat(with power: Int){
        guard let encounter = currentEncounter else {return}
        encounter.catHP += power
        if encounter.catHP > encounter.catMaxHP {encounter.catHP = encounter.catMaxHP}
    }
    //make the one button say the correct thing
    func updatePetButton(){
        if gameState != "chooseAction"{
            petbutton.setTitle("Next", for: .normal)
        } else {
            petbutton.setTitle("Pet!", for: .normal)
        }
    }
    //write text to the little text box
    func writeMessage(encounter: CatEncounter){
        var message = ""
        switch gameState{
        case "startingEncounter":
           message = "\(encounter.catName) \(EncounterText.shared.encounterStarts.randomElement() ?? "")"
        case "chooseAction":
            message = "What will you do?"
        case "rollForPet":
            message = "You try to pet \(encounter.catName)!"
        case "petResults":
            let effectiveness = rollForPet()
            if effectiveness == 0{
                message = "\(encounter.catName) refused the pet!"
            } else {
                message = "Successful pet! \(effectiveness) affections!!"
            }
            petCat(with: effectiveness)
            updateAffectionLabel(encounter: encounter)
        case "catAction":
            message = "\(encounter.catName) \(EncounterText.shared.catActions.randomElement() ?? "couldn't think of anything!")"
        case "actionResult":
            let damage = takeDamage(from: encounter)
            message = "Your pride takes \(damage) damage!"
        case "catFriended":
            message = "\(encounter.catName) seems to have come around!"
        case "endEncounter":
            message = "Made friends with \(encounter.catName)!!"
        case "expCalc":
            let results = self.gainEXP(from: encounter)
            message = "Gained \(results.0) experience."
            if results.1 == true{
                message += " Level up!"
            }
        case "nextEncounter":
            message = "Onto the next new friend."
        default:
            return
        }
        messageLabel.text = message
    }
    //cats being standoffish hurts your pride.
    func takeDamage(from encounter: CatEncounter) -> Int{
        let damage = encounter.catLevel
        guard let player = player else {return 0}
        player.hp -= damage
        return damage
    }
    //generates a new encounter
    func startNewEncounter(){
        //hide the screen so we can not have a weird looking screen between encounters
        hideScreen()
        CatController.shared.fetchCat(apiKey: CatController.shared.apiKey) { (cat) in
            guard let currentCat = cat else {return}
            CatController.shared.fetchCatImage(cat: currentCat, apiKey: CatController.shared.apiKey, completion: { (catPic) in
                DispatchQueue.main.async {
                    //set up the UI
                    self.catImageLabel.image = catPic
                    guard let player = self.player else {return}
                    //try and keep the curve reasonable?
                    let minLevel = max(player.level - 1, 1)
                    let maxLevel = player.level + 1
                    //improve randomness by shuffling arrays
                    EncounterText.shared.shuffleArrays()
                    //make a new encounter
                    let encounter = CatEncounter(cat: currentCat, name: EncounterText.shared.catNames.randomElement() ?? "Bob", level: Int.random(in: minLevel...maxLevel))
                    //manage the message
                    self.writeMessage(encounter: encounter)
                    //tell the app what encounter is current
                    self.currentEncounter = encounter
                    //start the loop
                    self.gameState = "startingEncounter"
                    self.showScreen()
                }
            })
        }
    }
    //update the cat's "hp"
    func updateAffectionLabel(encounter: CatEncounter){
        catAffectionLabel.text = "Affection: \(encounter.catHP)/\(encounter.catMaxHP)"
    }
    //handle EXP and leveling! I had time to do so many cool extras i swear.
    func gainEXP(from encounter: CatEncounter) -> (Int, Bool){
        guard let player = player else {return (0, false)}
        var levelUp = false
        let expGain = encounter.catLevel * 5
        player.exp += expGain
        if player.exp >= player.expToLevel{
            player.level += 1
            player.exp -= player.expToLevel
            player.expToLevel = Int(Double(player.expToLevel) * 1.5)
            player.maxHP = (Double(player.level) * 1.8) * 5
            round(player.maxHP)
            player.hp = Int(player.maxHP)
            levelUp = true
        }
        return (expGain, levelUp)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//delegation!
extension CatPetterViewController: PlayerDelegate{
    //did these so i could use property observers on player properties
    func hpChanged(sender: Player) {
        playerPrideLabel.text = "(Pride: \(sender.hp)/\(Int(sender.maxHP))"
    }
    
    func levelChanged(sender: Player) {
        playerLevelLabel.text = "LV. \(sender.level)"
    }
}
