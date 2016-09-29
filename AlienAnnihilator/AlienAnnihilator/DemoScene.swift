//
//  GameScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 7/14/16.
//  Copyright (c) 2016 GuacGetters. All rights reserved.

//Adding a power up where the bullets slow down so they just keep killling things that go into them??
//Get global timer for everything- alien spwans, when to add new alein types, ect.
//Kills should be a currency of sorts
//



//To Do:

/*
 
 Delete off screen nodes, I should waste resources doing a check 60 times a sec so maybe once every 5-10 seconds and wipe everything that is off screen
 Adjust gun shoot rate and alien spawn rates
 
 */






//Not properly removin power up lasers


import SpriteKit

//Build the Game Scene
class DemoScene: SKScene, SKPhysicsContactDelegate {
    
    //Demo scene stages
    let stages = [1,2,3,4,5]
    var activeComponenets:[String:Bool] = ["controller":false, "laser":false, "pauseButton":true, "spawning":false]
    var controllerUsed = false
    var passedAlienCount = 0
    var currentStage = 1
    var useBridge = false
    var stage4_reset_good = false
    //var screenSize:CGSize = nil
    
    var demoOn = true
    var shotsFired:Int = 0
    var shotsHit:Int = 0
    
    var accuracy:Int = 0
    
    var bossOn = false
    var currentAliensKilled = 0
    
    
    //Multiplers ordered as: speed, spawn time, lives?
    var normAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    var downAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    var behindAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    
    
    var downNotCalledYet = true
    var behindNotCalledYet = true
    
    
    fileprivate var score = 0 {
        didSet{
            
            //score = aliensKilled + numberBossesKilled * 50
            self.scoreLabel?.text = String(score)//"Score: " + String(score)
        }
    }
    fileprivate var scoreLabel:SKLabelNode?
    
    
    //Build the Aliens killed Label
    fileprivate var aliensKilled = 0 {
        didSet{
            self.aliensKilledLabel?.text = "Killed: " + String(aliensKilled) + "/20"
            score = aliensKilled + numberBossesKilled * 50
            
        }
        
    }
    fileprivate var aliensKilledLabel:SKLabelNode?
    
    var numberBossesKilled = 0
    
    //Instantiate the ship
    var aShip = Ship(startPosition: CGPoint(x:50,y:100), controllerVector: controlVector)
    
    
    //Build the shipLives label
    fileprivate var shipLives = 3000 {
        didSet{
            self.shipLivesLabel?.text = "Lives: " + String(shipLives)
        }
    }
    fileprivate var shipLivesLabel:SKLabelNode?
    
    
    
    //fileprivate var totalNodes = 0 {
    //   didSet{
    //self.totalNodesLabel?.text = "TotalNodes: " + String(totalNodes)
    //}
    //}
    
    //fileprivate var totalNodesLabel:SKLabelNode?
    
    
    //controller configthis is the way to d
    let controlStick = SKSpriteNode(texture: controllerHandleTexture, color: UIColor.clear, size: controllerHandleTexture.size())
    let controlBase = SKSpriteNode(texture: controllerBaseTexture, color: UIColor.clear, size: controllerBaseTexture.size())
    var controllerOn:Bool = false
    
    
    
    

    var pauseButton:PauseButton? = nil
    let progressBar : ProgressBar? = nil
    //var backGround:BackGroundAnimation?
    
    var heartArray:[SKSpriteNode] = []
    
    func removeHeart(){
        //let lostHeart = heartArray.removeLast()
        
        //lostHeart.removeFromParent()
        
    }
    
    
    
    
    //var backGround:BackGroundAnimation
    
    //    let allNodes:Int = subtreeCount()
    
    //Main scene did move to view drawing
    override func didMove(to view: SKView) {
        shotsFired = 0
        
        
        
        

        
        
        
        
        let screenSize:CGSize = (view.scene?.size)!
        aShip.position = CGPoint(x:screenSize.width/2,y:screenSize.height*0.2)
        
        //Pause button...
        pauseButton = PauseButton(theTexture: pauseButtonTexture, aScene: self)
        pauseButton!.position = CGPoint(x: (screenSize.width) - pauseButton!.size.width*0.7, y:(screenSize.height) - pauseButton!.size.height*0.7)
        if(activeComponenets["pauseButton"] != true){
            pauseButton?.alpha = 0.3
        }
        
        addChild(pauseButton!)
        
        
        for index in 0...shipLives-1 {
            let heart:SKSpriteNode = SKSpriteNode(texture: heartTexture)
            //heart.setScale(0.1)
            let spaceFactor = 1.2 * heart.size.width * CGFloat(index)
            heart.position = CGPoint(x:screenSize.width*0.3 + spaceFactor, y:heart.size.height * 0.7)//screenSize.height*0.1)
            heartArray.append(heart)
            //addChild(heart)
        }
        
        
        
        
        
        
        //So when we go back to scene the ship isnt moving from the last played game
        controlVector = CGVector(dx: 0,dy: 0)
        aShip.physicsBody?.velocity = CGVector(dx:0, dy:0)
        
        
        let scoreWordLabel = SKLabelNode(fontNamed: "Chalkduster")//"Times New Roman")
        scoreWordLabel.text = "Score: "// + String(score)
        scoreWordLabel.fontSize = screenSize.width * 0.04
        scoreWordLabel.position = CGPoint(x:screenSize.width*0.6,y:screenSize.height*0.02)
        //self.addChild(scoreWordLabel)
        //self.scoreLabel = scoreWordLabel
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")//"Times New Roman")
        scoreLabel.text = String(score)//"Score: " + String(score)
        scoreLabel.fontSize = screenSize.width * 0.04
        //scoreLabel.anchorPoint
        let scoreLabelWidth = scoreLabel.frame.width
        
        let scoreNumXPos = scoreWordLabel.position.x + scoreWordLabel.frame.width/1.5
        
        scoreLabel.position = CGPoint(x:scoreNumXPos + scoreLabel.frame.width,y:scoreWordLabel.position.y)
        
        //scoreLabel.position = CGPoint(x:screenSize.width*0.6+scoreLabelWidth,y:screenSize.height*0.02)
        //self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
        
        
        
        let aliensKilledLabel = SKLabelNode(fontNamed: "Times New Roman")
        //aliensKilledLabel.text = aliensKilled.description
        aliensKilledLabel.text = "Killed: " + String(aliensKilled) + "/20"
        aliensKilledLabel.fontSize = 30
        //aliensKilledLabel.fontSize = self.frame.width * 0.0 //screenSize.width * 0.1// 14
        aliensKilledLabel.position = CGPoint(x:self.frame.midX,y:self.frame.midY*1.5)
        aliensKilledLabel.isHidden = true
        self.addChild(aliensKilledLabel)
        self.aliensKilledLabel = aliensKilledLabel
        
        
        let shipLivesLabel = SKLabelNode(fontNamed: "Times New Roman")
        shipLivesLabel.text = "Lives: " + String(aShip.lives)
        shipLivesLabel.fontSize = self.frame.width * 0.02 //14
        shipLivesLabel.position = CGPoint(x:self.frame.midX*1.3,y:self.frame.midY*0.02)
        //self.addChild(shipLivesLabel)
        //self.shipLivesLabel = shipLivesLabel
        
        
        //let totalNodesLabel = SKLabelNode(fontNamed: "Times New Roman")
        //totalNodesLabel.text = "totalNodes: " + String(self.totalNodes)
        //totalNodesLabel.fontSize = 14
        //totalNodesLabel.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        //self.addChild(totalNodesLabel)
        //self.totalNodesLabel = totalNodesLabel
        
        var powerupTimerLabel = SKLabelNode(fontNamed:"Times New Roman")
        powerupTimerLabel.text = "PU Time: " //this should be modified within the ship class
        powerupTimerLabel.fontSize = 14
        powerupTimerLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        //Where should this be added from?
        //self.addChild(powerupTimerLabel)
        
        
        //size.width = 667.0
        //base side = size.width*0.075
        
        
        
        //Set up the scene structure
        backgroundColor = SKColor.black
        
        addChild(aShip)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        /* Set up for the controller */
        //Establish the base
        
        print("TITIS",size.width,self.frame.width)
        
        controlBase.size = CGSize(width: self.frame.width/8, height: self.frame.width/8) //90
        controlBase.position = CGPoint(x:controlBase.size.width/2,y:controlBase.size.height/2)//size.width*0.075, y:size.height*0.1)
        controlBase.zPosition = 1
        controlBase.name = "controlBase"
        addChild(controlBase)
        
        //Establish the stick
        controlStick.position = controlBase.position
        controlStick.size = CGSize(width: controlBase.size.width*0.55, height: controlBase.size.height*0.55)
        controlStick.zPosition = 2
        controlStick.name = "controlStick"
        addChild(controlStick)
        
        //Make semi-transparent
        controlBase.alpha = 0.25
        controlStick.alpha = 0.25
        
        
        
        
        //Fade everything out
        if(activeComponenets["controller"] != true){
            controlBase.alpha = 0.1
            controlStick.alpha = 0.1
        }
        if(activeComponenets["pauseButton"] != true){
            pauseButton?.alpha = 0.3
        }
        
        
        //Start spawning normal aliens immediately
        
        //startSpawningNorm()
        
        //Begin count down for bosses
        //startSpawningBosses()
        //spawnPowerup()
        //startSpawningPowerUps()
        //startSpawningPowerUps()
        startStage1()
        
        //stage5()
        //stage6()
        
    }
    
    
        //Stages of training:
        //Here is where demoScene controls are turned on and off and alins are spwaned from
    
    
    
    
        //Stages defined (text ect)
    //let label1 = makeLabel(text: "You're now out in the great void, filled with creatures of all shapes and sizes.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
    //let label2 = makeLabel(text: "Welcome to training. You have a long journey ahead of you, so lets get started.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
    
    //let label3 = makeLabel(text: "Touch and move the ships virtual controller to navigate the void.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
    //some action then wait 5 seconds
    //let label4 = makeLabel(text: "Uh Oh! There appear to be 5 aliens heading your way! Avoid them at all costs! Youll be safe once they pass.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
    //some action-- if any hit reset "You didnt dodge, try these guys!"
    //let label5 = makeLabel(text: "Great job! You avoided all of those aliens!", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
    
    
    func fadeIn(time:TimeInterval) -> SKAction{
        let fadeInAction = SKAction.fadeIn(withDuration: time)
        return fadeInAction
    }
    func fadeOut(time:TimeInterval) -> SKAction{
        let fadeOutAction = SKAction.fadeOut(withDuration: time)
        return fadeOutAction
    }
    
    
    
    func addLabelChild(label:SKLabelNode){
         addChild(label)
    }
    
    
    func startStage1(){
        
        currentStage = 1
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let wait = SKAction.wait(forDuration: 1)
        
        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        let waitTillRemove = SKAction.wait(forDuration: baselabelAnimation.duration)
        let labelRemove = SKAction.removeFromParent()
        
        let label0 = makeLabel(text: "You're now roaming the great void.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        let animate0 = SKAction.sequence([baselabelAnimation, waitTillRemove, labelRemove])
        self.addChild(label0)
        label0.run(animate0)
        let nextWait = SKAction.wait(forDuration: animate0.duration)
        
        let label1 = makeLabel(text: "Welcome to training.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        label1.isHidden = true
        let animate1 = SKAction.sequence([nextWait,SKAction.run {label1.isHidden = false},baselabelAnimation, waitTillRemove, labelRemove])
        self.addChild(label1)
        label1.run(animate1)
        
        
        
        let label2 = makeLabel(text: "Here you will learn how to survive.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        label2.isHidden = true
        self.addChild(label2)
        
        
        let animate2 = SKAction.sequence([nextWait,nextWait, SKAction.run {label2.isHidden = false},baselabelAnimation,labelRemove])
        label2.run(SKAction.sequence([animate2]))
        

        self.run(SKAction.sequence([SKAction.wait(forDuration:wait.duration+animate2.duration), SKAction.run(stage2)]))
        
        
    }
    
    
    
    
    
    func stage2(){
        
        currentStage = 2
        
        // use joystick
        let labelRemove = SKAction.removeFromParent()

        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.25)
        let wait = SKAction.wait(forDuration: 1)
        
        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        let actionLabel1 = makeLabel(text: "Touch and hold the virtual joypad to navigate.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        self.addChild(actionLabel1)
        
        actionLabel1.run(SKAction.sequence([baselabelAnimation,SKAction.run(waitForTouchDown),labelRemove]))
        //Controller now active
    }
    
    
    func waitForTouchDown(){
        
        activeComponenets["controller"] = true
        //let color = SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.7, duration: 0.5)
        let wait = SKAction.wait(forDuration: 2)
        //let discolor = SKAction.colorize(with: SK, colorBlendFactor: <#T##CGFloat#>, duration: <#T##TimeInterval#>)
        
        let boldController = SKAction.run {
            self.controlBase.alpha = 0.75
            self.controlStick.alpha = 0.75
        }
        let disBoldController = SKAction.run {
            self.controlBase.alpha = 0.25
            self.controlStick.alpha = 0.5
        }
        
        controlBase.run(SKAction.sequence([boldController,wait,disBoldController]))
        controlStick.run(SKAction.sequence([boldController,wait,disBoldController]))
        
        
        
    }
    
    func stage3(){
        
        currentStage = 3
        //"You should also know that this universe is riddled with wormholes."
        //"see for yourself, go through one side of your screen to pop out on the other"
        //"This will be very useful when avoiding enemies later on"
        
        //Use teleporting
        
        print("IN STAGE 3")
        let labelRemove = SKAction.removeFromParent()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let wait = SKAction.wait(forDuration: 1)
        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        
        let actionLabel1 = makeLabel(text: "Okay. A little shakey, but we'll make do.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel1.isHidden = true
        self.addChild(actionLabel1)
        
        actionLabel1.run(SKAction.sequence([wait,SKAction.run {actionLabel1.isHidden = false},baselabelAnimation,labelRemove]))
        
        let actionLabel2 = makeLabel(text: "Know- this universe is riddled with wormholes.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel2.isHidden = true
        self.addChild(actionLabel2)
        
        let nextWait = SKAction.wait(forDuration: baselabelAnimation.duration)
        let animate2 = SKAction.sequence([wait,nextWait, SKAction.run {actionLabel2.isHidden = false},baselabelAnimation,labelRemove])
        actionLabel2.run(SKAction.sequence([animate2]))
        
        
        let actionLabel3 = makeLabel(text: "See for yourself,", position: CGPoint(x:self.frame.midX,y:self.frame.midY + actionLabel2.frame.height*1.5))
        actionLabel3.isHidden = true
        self.addChild(actionLabel3)
        let animate3 = SKAction.sequence([wait,nextWait,nextWait, SKAction.run {actionLabel3.isHidden = false},baselabelAnimation,labelRemove])
        actionLabel3.run(SKAction.sequence([animate3]))
        let actionLabel4 = makeLabel(text: "Go through one side of your screen", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel4.isHidden = true
        self.addChild(actionLabel4)
        let animate4 = SKAction.sequence([wait,nextWait,nextWait, SKAction.run {actionLabel4.isHidden = false},baselabelAnimation,SKAction.run {self.useBridge = true},labelRemove])
        actionLabel4.run(SKAction.sequence([animate4]))
        
        let actionLabel5 = makeLabel(text: "To pop out on the other.", position: CGPoint(x:self.frame.midX,y:self.frame.midY - actionLabel3.frame.height*1.5))
        actionLabel5.isHidden = true
        self.addChild(actionLabel5)
        let animate5 = SKAction.sequence([wait,nextWait,nextWait, SKAction.run {actionLabel5.isHidden = false},baselabelAnimation,SKAction.run {self.useBridge = true},labelRemove])
        actionLabel5.run(SKAction.sequence([animate5]))
        
        
        //self.run(SKAction.sequence([SKAction.wait(forDuration: baselabelAnimation.duration*4), SKAction.run(buildAliens)]))
        
        
        

        
        
        
    }
    

    
    func stage4(){
        
        currentStage = 4
        //Avoid aliens
        
        
        let labelRemove = SKAction.removeFromParent()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let wait = SKAction.wait(forDuration: 1.5)
        
        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        let nextWait = SKAction.wait(forDuration: baselabelAnimation.duration)

        let actionLabel1 = makeLabel(text: "Great! You're a natural!", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        self.addChild(actionLabel1)
        
        actionLabel1.run(SKAction.sequence([baselabelAnimation,labelRemove]))
        
        
        let actionLabel2 = makeLabel(text: "Just in time too..", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel2.isHidden = true
        self.addChild(actionLabel2)
        let animate2 = SKAction.sequence([nextWait, SKAction.run {actionLabel2.isHidden = false},baselabelAnimation,labelRemove])
        actionLabel2.run(SKAction.sequence([animate2]))
        
        
        let actionLabel3 = makeLabel(text: "Ten aliens inbound! Move to the left!", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel3.isHidden = true
        self.addChild(actionLabel3)
        let animate3 = SKAction.sequence([nextWait,nextWait, SKAction.run {actionLabel3.isHidden = false},baselabelAnimation,labelRemove])
        actionLabel3.run(SKAction.sequence([animate3]))
        
        let actionLabel4 = makeLabel(text: "Remember to take advantage of teleportation!!", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel4.isHidden = true
        self.addChild(actionLabel4)
        let animate4 = SKAction.sequence([nextWait,nextWait,nextWait, SKAction.run {actionLabel4.isHidden = false},baselabelAnimation,labelRemove])
        actionLabel4.run(SKAction.sequence([animate4]))
        

        
        
        self.run(SKAction.sequence([nextWait,SKAction.wait(forDuration: baselabelAnimation.duration*3), SKAction.run(buildAliens)]))

    }
    
    
    
    
    
    
    func buildAliens(){
        
        addNormAlien()
        addNormAlien()
        addNormAlien()
        addNormAlien()
        addNormAlien()
        addNormAlien()
        addNormAlien()
        addNormAlien()
        addNormAlien()
        addNormAlien()
        
        print("build aliens")
    }
    
    
    
    
    
    func stage4_reset(){
        
        passedAlienCount = 0
        
        let labelRemove = SKAction.removeFromParent()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 0.5)
        
        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        let nextWait = SKAction.wait(forDuration: baselabelAnimation.duration)
        
        let actionLabel1 = makeLabel(text: "Ahh you were hit.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        self.addChild(actionLabel1)
        
        actionLabel1.run(SKAction.sequence([baselabelAnimation,labelRemove]))
        
        
        let actionLabel2 = makeLabel(text: "Try again.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel2.isHidden = true
        self.addChild(actionLabel2)
        print("in stage 4")
        let animate2 = SKAction.sequence([nextWait,SKAction.run {actionLabel2.isHidden = false},baselabelAnimation,SKAction.run(self.buildAliens),labelRemove])
        actionLabel2.run(SKAction.sequence([animate2]))
        

        
    }
    
    
    func stage5(){
        
        currentStage = 5
        //self.activeComponenets["controller"] = true
        print("In stage 5")
        let labelRemove = SKAction.removeFromParent()
        
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let wait = SKAction.wait(forDuration: 1)
        print("In stage 5.")

        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        let nextWait = SKAction.wait(forDuration: baselabelAnimation.duration)
        
        let actionLabel1 = makeLabel(text: "AWESOME! You're already an adroit pilot.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        self.addChild(actionLabel1)
        print("In stage 5..")

        actionLabel1.run(SKAction.sequence([baselabelAnimation,labelRemove]))
        
        print("In stage 5...")

        let actionLabel2 = makeLabel(text: "Now for the fun-- your Laser Cannon is active.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel2.isHidden = true
        self.addChild(actionLabel2)
        let animate2 = SKAction.sequence([nextWait,SKAction.run {actionLabel2.isHidden = false},baselabelAnimation,labelRemove])
        actionLabel2.run(SKAction.sequence([animate2]))
        print("In stage 5....")

        let actionLabel3 = makeLabel(text: "Touch anywhere on the screen", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel3.isHidden = true
        self.addChild(actionLabel3)
        let animate3 = SKAction.sequence([nextWait,nextWait,SKAction.run {actionLabel3.isHidden = false; self.activeComponenets["laser"] = true},baselabelAnimation,labelRemove])
        actionLabel3.run(SKAction.sequence([animate3]))
        
        let actionLabel4 = makeLabel(text: "with your non-steering hand to shoot.", position: CGPoint(x:self.frame.midX,y:actionLabel3.position.y-actionLabel3.frame.height*1.5))
        actionLabel4.isHidden = true
        self.addChild(actionLabel4)
        let animate4 = SKAction.sequence([nextWait,nextWait,SKAction.run {actionLabel4.isHidden = false;},baselabelAnimation,labelRemove])
        actionLabel4.run(SKAction.sequence([animate4]))
        print("In stage 5.....")

        let actionLabel5 = makeLabel(text: "Blast through some extraterrestrials!!", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel5.isHidden = true
        self.addChild(actionLabel5)
        print("hello")
        let animate5 = SKAction.sequence([nextWait,nextWait,nextWait,
                                          SKAction.run {actionLabel5.isHidden = false;
                                            
                                            self.aliensKilledLabel?.isHidden=false;},
                                          baselabelAnimation,SKAction.run(self.buildAliens),SKAction.run(self.buildAliens), labelRemove])
        actionLabel5.run(SKAction.sequence([animate5]))
        
        
        
        print("hello2")

    }
    
    
    func stage5_reset(){
        
        self.enumerateChildNodes(withName: "normAlien",using: { node, _ in
            if let aNormAlien = node as? normAlien {
                aNormAlien.physicsBody?.categoryBitMask = 0
                aNormAlien.removeFromParent()
                print("removed")
                
            }
            }
        )
        
        aliensKilled = 0
        
        let labelRemove = SKAction.removeFromParent()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 1.5)
        
        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        let nextWait = SKAction.wait(forDuration: baselabelAnimation.duration)
        
        let actionLabel1 = makeLabel(text: "You can't let any escape!", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        self.addChild(actionLabel1)
        
        actionLabel1.run(SKAction.sequence([baselabelAnimation,labelRemove]))
        
        
        let actionLabel2 = makeLabel(text: "Try again.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        actionLabel2.isHidden = true
        self.addChild(actionLabel2)
        print("in stage 4")
        let animate2 = SKAction.sequence([nextWait,SKAction.run {actionLabel2.isHidden = false},baselabelAnimation,SKAction.run(self.buildAliens),SKAction.run(self.buildAliens),labelRemove])
        actionLabel2.run(SKAction.sequence([animate2]))
        
    }
    
    func stage6(){
        
        //self.run(SKAction.sequence(self.aliensKilledLabel.)){self.aliensKilledLabel?.isHidden=false;}
        
        
        currentStage = 6
        
        let labelRemove = SKAction.removeFromParent()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let wait = SKAction.wait(forDuration: 1.5)
        
        let baselabelAnimation = SKAction.sequence([fadeIn,wait,fadeOut])
        let nextWait = SKAction.wait(forDuration: baselabelAnimation.duration)
        
        let theactionlabel1 = makeLabel(text: "Congrats! You have completed training.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        self.addChild(theactionlabel1)
        
        theactionlabel1.run(SKAction.sequence([fadeIn,wait,fadeOut,labelRemove]))
        
        let theactionlabel2 = makeLabel(text: "You're ready to go out on your own now.", position: CGPoint(x:self.frame.midX,y:self.frame.midY))
        theactionlabel2.isHidden = true
        self.addChild(theactionlabel2)
        
        theactionlabel2.run(SKAction.sequence([nextWait,SKAction.run {theactionlabel2.isHidden = false},baselabelAnimation,labelRemove]))
        
        
        func buildStartScene(){
            run(
                SKAction.run() {
                    //Make a new gameScene
                    let startScene:StartScene = StartScene(size: self.view!.bounds.size)
                    startScene.scaleMode = SKSceneScaleMode.fill
                    //Present it with a transition
                    self.view!.presentScene(startScene, transition: SKTransition.fade(withDuration: 2))//    Scene(startScene)//, transition: SKTransition.doorway(withDuration: 0.5))
                }
            )
        }
        
        
        self.run(SKAction.sequence([nextWait,nextWait,SKAction.fadeOut(withDuration: 3) ,SKAction.run(buildStartScene)]))
        
        
        
    }
    
    
    
    
    


    
    
    
    
    
    func makeLabel(text:String, position:CGPoint) -> SKLabelNode{
        let introLabel = SKLabelNode(fontNamed: "Times New Roman")
        introLabel.text = text
        introLabel.fontSize = self.frame.width * 0.05 //14
        introLabel.position = position//CGPoint(x:self.frame.midX,y:self.frame.midY)
    
        return introLabel
    }

    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //This could be incremental- so u can shoot powerups, maybe they have 3 lives and if u kill it u kill it- but otherwise most will help u and they will stay the whole game
    func startSpawningPowerUps(){
        self.run(SKAction.repeatForever(SKAction.sequence([
            
            SKAction.wait(forDuration: 3),
            SKAction.run(spawnPowerup)
            
            
            ])))
    }
    
    func spawnPowerup(){
        
        let numAvailablePowerups:UInt32 = 3
        let powerup:PowerUpBall
        
        let laserType = random(0, max: numAvailablePowerups)
        
        if(laserType == 0){powerup = PowerUpBall(theBallSettings: HugeGunBall())}
        else if(laserType == 1){powerup = PowerUpBall(theBallSettings: SprayGunBall())}
        else{powerup = PowerUpBall(theBallSettings: MachineGunBall())}
        
        //powerup = PowerUpBall(theBallSettings: MachineGunBall())
        
        //let powerup = PowerUpBall(theBallSettings: SprayGunBall())//increaseFireRateBall()
        //powerup.ballSettings = HugeGunBall()
        self.addChild(powerup)
        //self.addChild(enlargeLaserBall())
    }
    
    //Building the aliens (Why is this seperate
    func startSpawningNorm(){
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(addNormAlien),
            SKAction.wait(forDuration: Double(random(1,max: 2))-Double(normAlienMultiplers[1])),
            SKAction.run(updateNormMultipliers)
            ])))
    }
    
    func startSpawningDown(){
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(addDownAlien),
            SKAction.wait(forDuration: Double(random(8,max: 15))-Double(downAlienMultiplers[1])),
            SKAction.run(updateDownMultipliers)
            ])))
    }
    
    func startSpawningBehind(){
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(addBehindAlien),
            SKAction.wait(forDuration: Double(random(10,max: 20))-Double(behindAlienMultiplers[1])),
            SKAction.run(updateBehindMultipliers)
            ])))
    }
    
    
    
    func startSpawningBosses(){
        
        run(SKAction.repeatForever(SKAction.sequence([
            
            SKAction.wait(forDuration: Double(random(40, max: 60))),
            SKAction.run(spawnBoss)
            ])))
        
    }
    
    
    
    
    func killOffAlien(_ alien:SKNode){
        
        print("Kill off")
        
        //Disable multiple contacts
        alien.physicsBody?.categoryBitMask = 0
        
        func stopMotion(){
            
            //            alien.physicsBody?.collisionBitMask = 0
            //            alien.physicsBody?.contactTestBitMask = 0
            
            alien.physicsBody?.isDynamic = false
            alien.physicsBody?.velocity = CGVector(dx:0, dy:0)
            alien.removeAction(forKey: "facialMotion")
        }
        
        
        func removeAlien(){
            alien.removeFromParent()
        }
        
        let stopMoving = SKAction.run(stopMotion)
        let color = SKAction.colorize(with: SKColor.red, colorBlendFactor: 0.7, duration: 0)
        
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        let removeFromParent = SKAction.run(removeAlien)
        
        let die = SKAction.sequence([stopMoving, color, fadeOut, removeFromParent])
        
        alien.run(die)
        totalNodes-=1
    }
    
    
    
    
    func alien_laser_contact(_ contact:SKPhysicsContact){
        var alien:SKNode? = nil
        if contact.bodyA.categoryBitMask == PhysicsCategory.Alien && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            alien = contact.bodyA.node
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.Alien && contact.bodyA.categoryBitMask == PhysicsCategory.Laser{
            alien = contact.bodyB.node
        }
        else{
            return
        }
        
        aliensKilled = aliensKilled + 1
        aShip.lives = aShip.lives - 1
        
        killOffAlien((alien)!)
        
        
        
        
    }
    
    
    func boss_laser_contact(_ contact:SKPhysicsContact){
        
        var boss:SKNode? = nil
        if contact.bodyA.categoryBitMask == PhysicsCategory.AlienBoss && contact.bodyB.categoryBitMask == PhysicsCategory.Laser{
            boss = contact.bodyA.node
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.AlienBoss && contact.bodyA.categoryBitMask == PhysicsCategory.Laser{
            boss = contact.bodyB.node
        }
        else{
            return
        }
        
        
        if let theBoss = contact.bodyA.node as? bossAlien1 {
            
            theBoss.shot()
            if(theBoss.lives < 1){
                numberBossesKilled += 1
                totalNodes-=1
            }
            
        } else if let theBoss = contact.bodyB.node as? bossAlien1 {
            theBoss.shot()
            if(theBoss.lives < 1){
                numberBossesKilled += 1
                totalNodes-=1
            }
        }
        
        
        
        
    }
    
    
    func boss_ship_contact(_ contact:SKPhysicsContact){
        
        var boss:SKNode? = nil
        if contact.bodyA.categoryBitMask == PhysicsCategory.AlienBoss && contact.bodyB.categoryBitMask == PhysicsCategory.Ship{
            boss = contact.bodyA.node
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.AlienBoss && contact.bodyA.categoryBitMask == PhysicsCategory.Ship{
            boss = contact.bodyB.node
        }
        else{
            return
        }
        
        
        if let theBoss = contact.bodyA.node as? bossAlien1 {
            
            theBoss.shot()
            gameOver()
            
        } else if let theBoss = contact.bodyB.node as? bossAlien1 {
            theBoss.shot()
            gameOver()
        }
        
        
        
    }
    
    
    
    func alien_ship_contact(_ contact:SKPhysicsContact){
        var alien:SKNode? = nil
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.Alien && contact.bodyB.categoryBitMask == PhysicsCategory.Ship{
            alien = contact.bodyA.node
            
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.Alien && contact.bodyA.categoryBitMask == PhysicsCategory.Ship{
            alien = contact.bodyB.node
            
        }
        else{
            return
        }
        
        //killOffAlien((alien)!)
        //aliensKilled = aliensKilled + 1
        //shipLives = shipLives-1
        //aShip.lives = aShip.lives - 1
        //removeHeart()
        
        
        
        print("ship/alien contact")
        
        self.enumerateChildNodes(withName: "normAlien",using: { node, _ in
            if let aNormAlien = node as? normAlien {
                aNormAlien.physicsBody?.categoryBitMask = 0
                aNormAlien.removeFromParent()
                print("removed")
                
            }
            }
        )

        if(activeComponenets["laser"]==false){
           
            //Remove all ones on scene and start again
            print("ALmost")
            stage4_reset_good = true
            if(stage4_reset_good){
                stage4_reset()
                stage4_reset_good = false
            }
            
            print("ALmost2")
            
        }
        
        if(activeComponenets["laser"] == true){
            
            stage5_reset()
            
        }
        
    }
    
    
    
    
    
    
    
    
    func ship_powerup_contact(_ contact:SKPhysicsContact){
        var powerup:SKNode? = nil
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.PowerUp && contact.bodyB.categoryBitMask == PhysicsCategory.Ship{
            powerup = contact.bodyA.node
            
        }
        else if contact.bodyB.categoryBitMask == PhysicsCategory.PowerUp && contact.bodyA.categoryBitMask == PhysicsCategory.Ship{
            powerup = contact.bodyB.node
            
        }
        else{
            return
        }
        
        
        print("YAYAYYAYSDYAYSFYASYDFYASYDGYSYDGYSYDGY POWER UPPPPPPPPPPPP")
        print("YAYAYYAYSDYAYSFYASYDFYASYDGYSYDGYSYDGY POWER UPPPPPPPPPPPP")
        print("YAYAYYAYSDYAYSFYASYDFYASYDGYSYDGYSYDGY POWER UPPPPPPPPPPPP")
        
        if let thePowerup = contact.bodyA.node as? PowerUpBall {
            
            thePowerup.apply(aShip)
            thePowerup.animateRemove()
            let runTime = thePowerup.ballSettings.runTime
            aShip.startPowerupTimer(runTime)
            
            
        } else if let thePowerup = contact.bodyB.node as? PowerUpBall {
            
            thePowerup.apply(aShip)
            thePowerup.animateRemove()
            
            let runTime = thePowerup.ballSettings.runTime
            aShip.startPowerupTimer(runTime)
        }
        
        
        
        
    }
    
    
    
    func didBegin(_ contact:SKPhysicsContact){
        alien_laser_contact(contact)
        alien_ship_contact(contact)
        boss_laser_contact(contact)
        boss_ship_contact(contact)
        
        ship_powerup_contact(contact)
        

    }
    
    
    
    func gameOver(){
        let gameOverScene = GameOverScene(size: self.size, aliensKilled: self.aliensKilled, numberBossesKilled: self.numberBossesKilled, laserAccuracy: accuracy)
        //self.view?.presentScene(gameOverScene, transition: reveal)
        self.view?.presentScene(gameOverScene, transition: SKTransition.fade(with: SKColor.red, duration: 3))
    }
    
    
    
    //Make all this code way more compact later
    func updateNormMultipliers(){
        //if(normAlienMultiplers[0]<)
        
        normAlienMultiplers[0] = normAlienMultiplers[0]*1.01
        normAlienMultiplers[1] = normAlienMultiplers[1]*1.01
    }
    func updateDownMultipliers(){
        downAlienMultiplers[0] = downAlienMultiplers[0]*1.01
        downAlienMultiplers[1] = downAlienMultiplers[1]*1.01
    }
    func updateBehindMultipliers(){
        behindAlienMultiplers[0] = behindAlienMultiplers[0]*1.01
        behindAlienMultiplers[1] = behindAlienMultiplers[1]*1.01
    }
    
    
    
    //Functions to create new alien instances with progressive difficulty
    func addNormAlien(){
        let mult = normAlienMultiplers
        let alienInst = normAlien(startPos:CGPoint(x: 10,y: 10), speed: random(UInt32(30), max: UInt32(60))*mult[0])
        let yStart = random(UInt32(alienInst.size.height/2), max: UInt32(size.height-alienInst.size.height))
        alienInst.position = CGPoint(x:size.width+alienInst.size.width/2, y:yStart)
        addChild(alienInst)
        totalNodes+=1
    }
    
    func addDownAlien(){
        
        let mult = downAlienMultiplers
        
        let alienInst = downAlien(startPos:CGPoint(x: 10,y: 10),speed: random(UInt32(10),max: UInt32(30))*mult[0])
        //this line makes no sense, maybe use lasy variables or something
        
        
        let xStart = random(UInt32(alienInst.size.width/2), max: UInt32(size.width-alienInst.size.width))
        alienInst.position = CGPoint(x: xStart, y:CGFloat(size.height + alienInst.size.width/2))
        addChild(alienInst)
        totalNodes+=1
    }
    
    func addBehindAlien(){
        
        let mult = behindAlienMultiplers
        
        let alienInst = behindAlien(startPos:CGPoint(x: 10,y: 10),speed: random(UInt32(5),max: UInt32(40))*mult[0])
        let yStart = random(UInt32(alienInst.size.height/2), max: UInt32(size.height-alienInst.size.height))
        alienInst.position = CGPoint(x: -alienInst.size.width/2, y:CGFloat(yStart))
        addChild(alienInst)
        totalNodes+=1
    }
    
    
    
    func spawnBoss(){
        bossOn = true
        
        let bossSpawnLabel = SKLabelNode(fontNamed: "Times New Roman")
        //aliensKilledLabel.text = aliensKilled.description
        bossSpawnLabel.text = "BOSS INCOMING!"
        bossSpawnLabel.color = SKColor.red
        bossSpawnLabel.fontSize = 24
        bossSpawnLabel.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        
        
        func addTheLabelChild(){
            
            addChild(bossSpawnLabel)
        }
        
        func removeSpawnLabel(){
            bossSpawnLabel.removeFromParent()
        }
        
        let labelWaitTime = SKAction.wait(forDuration: 1)
        
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 4)
        
        
        func animateLabel(){
            
            let labelWaitTime = SKAction.wait(forDuration: 3)
            
            let fadeIn = SKAction.fadeIn(withDuration: 2)
            let fadeOut = SKAction.fadeOut(withDuration: 4)
            
            
            let labelAnimation = SKAction.sequence([fadeIn,labelWaitTime,fadeOut])
            
            let waitTillRemove = SKAction.wait(forDuration: labelAnimation.duration)
            let labelRemove = SKAction.removeFromParent()
            
            
            bossSpawnLabel.run(SKAction.sequence([labelAnimation, waitTillRemove, labelRemove]))
            
        }
        
        
        let displayLabel = SKAction.sequence([SKAction.run(addTheLabelChild),SKAction.run(animateLabel)])
        
        
        //Run the display label action on the GameScene
        self.run(displayLabel)
        
        
        
        
        let xCoord:CGFloat = -200//random(UInt32(0), max: UInt32(size.width))
        let yCoord = random(UInt32(0), max: UInt32(size.height))
        
        let boss = bossAlien1(startPos: CGPoint(x:xCoord,y:yCoord), bossSpeed:CGFloat(20))
        addChild(boss)
        
    }
    
    
    
    func normalizeVector(_ v:CGVector) -> CGVector{
        let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
        let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
        return ans
    }
    
    
    
    //A dictionary to hold all touch start locations
    var startingTouches = [UITouch : CGPoint]()
    
    //    func goToGameScene(){
    //        let gameScene:GameScene = GameScene(size: self.view!.bounds.size) // create your new scene
    //        let transition = SKTransition.fadeWithDuration(1.0) // create type of transition (you can check in documentation for more transtions)
    //        gameScene.scaleMode = SKSceneScaleMode.Fill
    //        self.view!.presentScene(gameScene, transition: transition)
    //    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches {
            let location = touch.location(in: self)
            startingTouches[touch as! UITouch] = location
            
            if(controlBase.frame.contains(location) && !scene!.isPaused){
                controllerOn = true
            }
            else{
                controllerOn = false
            }
            
            
            
            if(controlBase.frame.contains(location) && activeComponenets["controller"] == true && !scene!.isPaused){
                if(controllerUsed == false){
                    controllerUsed = true
                    
                    
                    stage3()
                    
                }
                
            
            }
            
                
            if(pauseButton!.contains(location) && activeComponenets["pauseButton"] == true){
                pauseButton!.switchState()
            }
            
            
        
            
            
            
            
            if(!controlBase.frame.contains(location) && activeComponenets["laser"] == true && !pauseButton!.contains(location) && !scene!.isPaused){
                
                aShip.gun.shootingFingerDown = true
                
                aShip.gun.fire()
                
                
            }
            
            if(aShip.frame.contains(location)){
                
                if(partyMode){
                    partyMode = false
                }
                else{
                    partyMode = true
                }
                
                
                
            }
            
            
            
            
            
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.location(in: self)
            
            //The starting location of the given touch we're working with
            let touchStartPoint:CGPoint = startingTouches[touch as! UITouch]!
            
            
            //Play with this - Is it better than using the controller on??? (Note: u can move into the frame of the controller and move it)
            //if(controllerOn == true){
            if(controlBase.frame.contains(touchStartPoint) && activeComponenets["controller"] == true && !scene!.isPaused){
                
    
                
                
                let joyVector = CGVector(dx:location.x - controlBase.position.x, dy:location.y - controlBase.position.y)
                
                

                controlStick.position = location
                
                let rangeToCenterSprite = SKRange(lowerLimit: 0, upperLimit: controlBase.size.width/2 - controlStick.size.width/2)
                let distanceConstraint:SKConstraint = SKConstraint.distance(rangeToCenterSprite, to: controlBase.position)
                controlStick.constraints = [distanceConstraint]
                
                
                
                //Float bc cosf only takes floats not CGFloats -> what is the real difference?
                //let degree = angle * CGFloat(180/M_PI)
                //var calcRotation:Float = Float(angle-1.57879633) + Float(M_PI_2)
                //let xVelocity = 50 * CGFloat(cosf(calcRotation))
                //let yVelocity = 50 * CGFloat(sinf(calcRotation))
                
                let v:CGVector = CGVector(dx:joyVector.dx,dy:joyVector.dy)
                let unitVector:CGVector = normalizeVector(v)
                controlVector = CGVector(dx:unitVector.dx,dy:unitVector.dy)
                
                aShip.updateShipProperties(shipVelocity: controlVector, laserStartPos: CGPoint(x:0,y:0))
                
                //aShip.physicsBody?.velocity = CGVector(dx: controlVector.dx * 100, dy: controlVector.dy * 100)
                
                
            }
        }
        
        
    }
    
    
    func resetController(){
        let move:SKAction = SKAction.move(to: controlBase.position, duration: 0.2)
        //Causes the animation to slow as it progresses
        move.timingMode = .easeOut
        controlStick.run(move)
        controlVector = CGVector(dx:0,dy:0)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            //Does this make any more sense than the commented code below it?
            //difference is that this code if speaking strictly about touch's location at start time rather than location at end time!
            
            //Reset if touch that is on controller is lifted or if no fingers are on the screen
            if(controlBase.frame.contains(startingTouches[touch as! UITouch]!)){
                resetController()
                aShip.updateShipProperties(shipVelocity: controlVector, laserStartPos: CGPoint(x:0,y:0))
                
                //aShip.physicsBody?.velocity = CGVector(dx:0, dy:0)
            }
                
                //If it wasn't in the move box then the potential continual shot ended
            else{
                
                
                //If user lifts finger while automatic enabled then stop firing
                //aShip.gun.shootingFingerDown = false
                if(!aShip.gun.gunSettings.semiAutomatic){
                    
                    aShip.gun.removeAction(forKey: "shootMachineGunLaser")
                }
                
                
                
                
                //Force a call to this method to update it (****************THIS ISNT EVEN NEEDED? WHERE IS IT NEEDED?)
                //aShip.gun.updatefingerState()
            }
            
            
            //            if(startingTouches.count < 1){
            //                resetController()
            //            }
            
            
            
            //Remove the touch
            startingTouches.removeValue(forKey: touch as! UITouch)
        }
        
    }
    
    //
    //    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    //        for touch:AnyObject in touches!{
    //
    //            startingTouches.removeAll()
    //
    //        }
    //    }
    //
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        
        if(passedAlienCount>=10){
            stage5()
            passedAlienCount = 0
            //dont repeat stage 4

        }
        
        //Done!
        if(aliensKilled>=20 && demoOn){
            stage6()
            demoOn = false

            
        }
        
        
        
        
        //let allNodes:Int = subtreeCount()
        //print("Total Nodes: ",allNodes)
        
        
        //Maybe optimize
        //aShip.progressBar?.position = CGPoint(x: self.position.x - (self.size.width/2 + self.size.width/7.0), y: self.position.y)
        //print(aShip.progressBar)
        //print(aShip.progressBar?.position)
        
        aShip.updateProgressBar()
        
        
        // list all values
        //        print("Values of startingTouches: ")
        //        for (key, value) in startingTouches {
        //            print(value)
        //        }
        
        
        //        print(startingTouches.count)
        //        if(startingTouches.count < 1){
        //            resetController()
        //        }
        //        print(aShip.position)
        
        //        boss.moveBody()
        
        
        //This should just be called in
        //aShip.updateShipProperties(shipVelocity: controlVector, laserStartPos: CGPoint(x:0,y:0))
        
        //        if(shipLives<1){
        //            enumerateChildNodesWithName("normAlien", usingBlock: gameOverBounceMode)
        //            enumerateChildNodesWithName("downAlien", usingBlock: gameOverBounceMode)
        //            enumerateChildNodesWithName("behindAlien", usingBlock: gameOverBounceMode)
        //
        //        }
        
        //Screen boundries (Loop ship position)
        if(aShip.position.x > self.size.width){
            aShip.position.x = 0
            if(currentStage==3&&useBridge){stage4();useBridge=false}
        }
        if(aShip.position.x < 0){
            aShip.position.x = self.size.width
            if(currentStage==3&&useBridge){stage4();useBridge=false}
            
        }
        if(aShip.position.y > self.size.height + aShip.size.height/2){
            aShip.position.y = 0
            if(currentStage==3&&useBridge){stage4();useBridge=false}
        }
        if(aShip.position.y < 0){
            aShip.position.y = self.size.height - aShip.size.height/2
            if(currentStage==3&&useBridge){stage4();useBridge=false}
        }
        
        
        
        //        self.enumerateChildNodesWithName("progressBar",
        //                                         usingBlock: { node, _ in
        //                                            if let progressBar = node as? ProgressBar {
        //                                                progressBar.update()
        //
        //                                            }
        //            }
        //        )
        
        
        self.enumerateChildNodes(withName: "bossAlien",
                                 using: { node, _ in
                                    if let bossSprite = node as? bossAlien1 {
                                        bossSprite.update(self.aShip)
                                        
                                    }
            }
        )
        
        
        
        //        self.enumerateChildNodesWithName("star",
        //                                         usingBlock: { node, _ in
        //
        //
        //
        //                                            let positionInScene = self.convertPoint(node.position, fromNode: self.backGround!)
        //
        //                                            if(positionInScene.x > self.scene?.size.width){
        //                                                print("PAST!!!!")
        //                                                node.position.x = -50
        //                                            }
        //
        //            }
        //        )
        
        //
        //
        //        self.enumerateChildNodesWithName("normAlien",
        //            usingBlock: { node, _ in
        //
        //                if let aNormAlien = node as? normAlien {
        //
        //                    if(aNormAlien.position.x < -aNormAlien.size.width){
        //                        aNormAlien.removeFromParent()
        //                    }
        //                }
        //            }
        //        )
        
        
        
        
        
        //Remove Code run every time interval
        
        //print(self.children.count)
        
        //Uncomment this
        self.aShip.gun.enumerateChildNodes(withName: "laser",
                                           using: { node, _ in
                                            if let aLaser = node as? Laser {
                                                let positionInScene = self.convert(aLaser.position, from: self.aShip.gun)
                                                //                                                print("realPos:  ",positionInScene)
                                                //                                                print("self.size.width/2:  ",self.size.width/2)
                                                //                                                print("ship.x:  ",self.aShip.position.x)
                                                //                                                print("laser.x:  ",aLaser.position.x)
                                                //print("hi")
                                                
                                                //Should ma
                                                
                                                //                                                if(aLaser.position.x > self.size.width){
                                                if(positionInScene.x > self.size.width*1.05 || positionInScene.x < 0 - aLaser.size.width/2  ||
                                                    positionInScene.y > self.size.height*1.05 || positionInScene.y < 0 - aLaser.size.height/2){
                                                    
                                                    print("Remove laser")
                                                    
                                                    
                                                    
                                                    aLaser.removeFromParent()
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                            }
            }
        )
        
        
        //        self.enumerateChildNodesWithName("laser",
        //                                         usingBlock: { node, _ in
        //                                            if let aNormAlien = node as? Ship {
        //                                                print(self.size.width/2)
        //                                                print(self.aShip.position.x)
        //                                                //print(aLaser.position.x)
        //                                                //print("hi")
        //                                                if(aNormAlien.position.x < -aNormAlien.size.width){
        //                                                    aNormAlien.removeFromParent()
        //                                                }
        //                                            }
        //            }
        //        )
        
        self.enumerateChildNodes(withName: "normAlien",
                                 using: { node, _ in
                                    if let aNormAlien = node as? normAlien {
                                        //print(self.size.width/2)
                                        //print(self.aShip.position.x)
                                        
                                        //Just avoid aliens stage
                                        if(self.currentStage == 4){
                                            if(aNormAlien.position.x < -aNormAlien.size.width){
                                                aNormAlien.removeFromParent()
                                                self.passedAlienCount += 1
                                            }
                                        }
                                        
                                        //shoot aliens stage
                                        if(self.currentStage == 5){
                                            if(aNormAlien.position.x < -aNormAlien.size.width){
                                                //aNormAlien.removeFromParent()
                                            
                                                if(self.activeComponenets["laser"]==true){
                                                    
                                                    
                                                    self.stage5_reset()
                                                }
                                            }
                                        }
            }
            }
        )
        
        
        self.enumerateChildNodes(withName: "behindAlien",
                                 using: { node, _ in
                                    if let aBehindAlien = node as? behindAlien {
                                        //print(self.size.width/2)
                                        //print(self.aShip.position.x)
                                        
                                        if(aBehindAlien.position.x > self.size.width*1.2){
                                            aBehindAlien.removeFromParent()
                                            //self.totalNodes-=1
                                        }
                                    }
            }
        )
        
        
        self.enumerateChildNodes(withName: "downAlien",
                                 using: { node, _ in
                                    if let aDownAlien = node as? downAlien {
                                        
                                        
                                        if(aDownAlien.position.y < -aDownAlien.size.height){
                                            aDownAlien.removeFromParent()
                                            //self.totalNodes-=1
                                        }
                                    }
            }
        )
        
        
        self.enumerateChildNodes(withName: "powerupBall",
                                 using: { node, _ in
                                    if let powerupBall = node as? PowerUpBall {
                                        
                                        
                                        if(powerupBall.position.x < -powerupBall.size.width){
                                            powerupBall.removeFromParent()
                                            //self.totalNodes-=1
                                            print("Gone ball---------")
                                        }
                                    }
            }
        )
        
        
        
        //        enumerateChildNodesWithName("//.") { (node, _) -> Void in
        //            print("Node: \(node.name)")
        //        }
        
        
        
        
    }
    
    
    
    
    
    func gameOverBounceMode(_ node:SKNode, abool:UnsafeMutablePointer<ObjCBool>){
        node.physicsBody?.categoryBitMask = 0
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}





























