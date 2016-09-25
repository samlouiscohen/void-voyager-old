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
//Use lazy var for efficiemcy


//To Do:

/*
 
 Delete off screen nodes, I should waste resources doing a check 60 times a sec so maybe once every 5-10 seconds and wipe everything that is off screen
 Adjust gun shoot rate and alien spawn rates
 
 */






//Not properly removin power up lasers


import SpriteKit



var partyMode = false

//Set up the physics catagories for collisions (each bit of the 32 is a catagory)
struct PhysicsCategory {
    static let None      :  UInt32 = 0;
    static let All       :  UInt32 = UInt32.max
    static let Alien     :  UInt32 = 0b1
    static let Laser     :  UInt32 = 0b10
    static let Ship      :  UInt32 = 0b11
    
    static let AlienBoss :  UInt32 = 0b100
    static let PowerUp   :  UInt32 = 0b101
}


var controlVector:CGVector = CGVector(dx: 0, dy: 0)



//------------------------------------- Preload sprites-------------


let infoIconTexture = Assets.sharedInstance.sprites.textureNamed("info_icon") 
let heartTexture = Assets.sharedInstance.sprites.textureNamed("gHeart-1")

//Ship textures
let ship0 = Assets.sharedInstance.sprites.textureNamed("ship0_r")
let ship1 = Assets.sharedInstance.sprites.textureNamed("ship1_r")
let ship2 = Assets.sharedInstance.sprites.textureNamed("ship2_r")
let ship3 = Assets.sharedInstance.sprites.textureNamed("ship3_r")
let ship4 = Assets.sharedInstance.sprites.textureNamed("ship4_r")
let ship5 = Assets.sharedInstance.sprites.textureNamed("ship5_r")
let ship6 = Assets.sharedInstance.sprites.textureNamed("ship6_r")
let ship7 = Assets.sharedInstance.sprites.textureNamed("ship7_r")
let ship8 = Assets.sharedInstance.sprites.textureNamed("ship8_r")
let ship9 = Assets.sharedInstance.sprites.textureNamed("ship9_r")
let shipFrames = [ship0,ship1,ship2,ship3,ship4,ship5,ship6,ship7,ship8,ship9,ship9,ship9,ship8,ship7,ship6,ship5,ship4,ship3,ship2,ship1,ship0]


//Main alien textures
let mainAlien0 = Assets.sharedInstance.sprites.textureNamed("mainAlien0_r")//("mainAlien0")
let mainAlien1 = Assets.sharedInstance.sprites.textureNamed("mainAlien1_r")
let mainAlien2 = Assets.sharedInstance.sprites.textureNamed("mainAlien2_r")
let mainAlien3 = Assets.sharedInstance.sprites.textureNamed("mainAlien3_r")
let mainAlien4 = Assets.sharedInstance.sprites.textureNamed("mainAlien4_r")
let mainAlien5 = Assets.sharedInstance.sprites.textureNamed("mainAlien5_r")
let mainAlien6 = Assets.sharedInstance.sprites.textureNamed("mainAlien6_r")
let mainAlien7 = Assets.sharedInstance.sprites.textureNamed("mainAlien7_r")
let mainAlien8 = Assets.sharedInstance.sprites.textureNamed("mainAlien8_r")
let mainAlien9 = Assets.sharedInstance.sprites.textureNamed("mainAlien9_r")
let mainAlien10 = Assets.sharedInstance.sprites.textureNamed("mainAlien10_r")
let mainAlienFrames = [mainAlien0,mainAlien1,mainAlien2,mainAlien3,mainAlien4,mainAlien5,mainAlien6,mainAlien7,mainAlien8,mainAlien9,mainAlien10,mainAlien9,mainAlien8,mainAlien7,mainAlien6,mainAlien5,mainAlien4,mainAlien3,mainAlien2,mainAlien1,mainAlien0]

//Down alien textures
let down0 = Assets.sharedInstance.sprites.textureNamed("down1_r")
let down1 = Assets.sharedInstance.sprites.textureNamed("down1_r")
let down2 = Assets.sharedInstance.sprites.textureNamed("down2_r")
let down3 = Assets.sharedInstance.sprites.textureNamed("down3_r")
let down4 = Assets.sharedInstance.sprites.textureNamed("down4_r")
let down5 = Assets.sharedInstance.sprites.textureNamed("down5_r")
let down6 = Assets.sharedInstance.sprites.textureNamed("down6_r")
let down7 = Assets.sharedInstance.sprites.textureNamed("down7_r")
let down8 = Assets.sharedInstance.sprites.textureNamed("down8_r")
let down9 = Assets.sharedInstance.sprites.textureNamed("down9_r")
let down10 = Assets.sharedInstance.sprites.textureNamed("down10_r")
let down11 = Assets.sharedInstance.sprites.textureNamed("down11_r")
let down12 = Assets.sharedInstance.sprites.textureNamed("down12_r")
let down13 = Assets.sharedInstance.sprites.textureNamed("down13_r")
let down14 = Assets.sharedInstance.sprites.textureNamed("down14_r")
let down15 = Assets.sharedInstance.sprites.textureNamed("down15_r")
let down16 = Assets.sharedInstance.sprites.textureNamed("down16_r")
let down17 = Assets.sharedInstance.sprites.textureNamed("down17_r")
let down18 = Assets.sharedInstance.sprites.textureNamed("down18_r")
let down19 = Assets.sharedInstance.sprites.textureNamed("down19_r")
let down20 = Assets.sharedInstance.sprites.textureNamed("down20_r")
let down21 = Assets.sharedInstance.sprites.textureNamed("down21_r")
let down22 = Assets.sharedInstance.sprites.textureNamed("down22_r")
let down23 = Assets.sharedInstance.sprites.textureNamed("down23_r")
let down24 = Assets.sharedInstance.sprites.textureNamed("down24_r")

let downAlienFrames = [down0,down1,down2,down3,down4,down5,down6,down7,down8,down9,down10,down11,down12,down13,down14,down15,down16,down17,down18,down19,down20,down21,down22,down23,down24,
    down23,down22,down21,down20,down19,down18,down17,down16,down15,down14,down13,down12, down11,down10,down9,down8,down7,down6,down5,down4,down3,down2,down1]


//Behind Alien textures
let behindAlien0 = Assets.sharedInstance.sprites.textureNamed("behindAlien0")
let behindAlien1 = Assets.sharedInstance.sprites.textureNamed("behindAlien1")
let behindAlien2 = Assets.sharedInstance.sprites.textureNamed("behindAlien2")
let behindAlien3 = Assets.sharedInstance.sprites.textureNamed("behindAlien3")
let behindAlien4 = Assets.sharedInstance.sprites.textureNamed("behindAlien4")
let behindAlien5 = Assets.sharedInstance.sprites.textureNamed("behindAlien5")
let behindAlien6 = Assets.sharedInstance.sprites.textureNamed("behindAlien6")
let behindAlien7 = Assets.sharedInstance.sprites.textureNamed("behindAlien7")

let behindAlienFrames = [behindAlien7,behindAlien6,behindAlien5,behindAlien4,behindAlien3,behindAlien2,behindAlien1,behindAlien0,behindAlien1,behindAlien2,behindAlien3,behindAlien4,behindAlien5,behindAlien6]



//Boss 1 textures
let bossAlienReal0 = Assets.sharedInstance.sprites.textureNamed("bossAlien0")
let bossAlienReal1 = Assets.sharedInstance.sprites.textureNamed("bossAlien1")
let bossAlienReal2 = Assets.sharedInstance.sprites.textureNamed("bossAlien2")
let bossAlienReal3 = Assets.sharedInstance.sprites.textureNamed("bossAlien3")
let bossAlienReal4 = Assets.sharedInstance.sprites.textureNamed("bossAlien4")
let bossAlienReal5 = Assets.sharedInstance.sprites.textureNamed("bossAlien5")
let bossAlienReal6 = Assets.sharedInstance.sprites.textureNamed("bossAlien6")
let bossAlienReal7 = Assets.sharedInstance.sprites.textureNamed("bossAlien7")
let bossAlienReal8 = Assets.sharedInstance.sprites.textureNamed("bossAlien8")
let bossAlienReal9 = Assets.sharedInstance.sprites.textureNamed("bossAlien9")
let bossAlienReal10 = Assets.sharedInstance.sprites.textureNamed("bossAlien10")

let bossFrames = [bossAlienReal10,bossAlienReal10,bossAlienReal10,bossAlienReal9,bossAlienReal9,bossAlienReal9,bossAlienReal8,bossAlienReal8,bossAlienReal7,bossAlienReal7,bossAlienReal6,bossAlienReal6,bossAlienReal5,bossAlienReal4,bossAlienReal3,bossAlienReal2,bossAlienReal1,bossAlienReal0,bossAlienReal1,bossAlienReal2,bossAlienReal3,bossAlienReal4,bossAlienReal5,bossAlienReal6,bossAlienReal6,bossAlienReal7,bossAlienReal7,bossAlienReal8,bossAlienReal8,bossAlienReal9,bossAlienReal9,bossAlienReal9,bossAlienReal10,bossAlienReal10,bossAlienReal10]


let boss1BigEyeTexture = Assets.sharedInstance.sprites.textureNamed("bossEye")
let boss1BigEyeSocketTexture = Assets.sharedInstance.sprites.textureNamed("bossBigEyeSocket")
let boss1SmallEyeTexture = Assets.sharedInstance.sprites.textureNamed("bossSmallEye")
let boss1SmallEyeSocketTexture = Assets.sharedInstance.sprites.textureNamed("bossSmallEyeSocket")












//Normal laser
let laserTexture = Assets.sharedInstance.sprites.textureNamed("laser_r")


//Powerup balls
let powerupBallHugeTexture = Assets.sharedInstance.sprites.textureNamed("powerupBallHuge")
let powerupBallSprayTexture = Assets.sharedInstance.sprites.textureNamed("powerupBallSpray")
let powerupBallRapidTexture = Assets.sharedInstance.sprites.textureNamed("powerupBallRapid")
//Powerup lasers
let hugeLaserTexture = Assets.sharedInstance.sprites.textureNamed("hugeLaserTexture")
let sprayLaserTexture = Assets.sharedInstance.sprites.textureNamed("SprayLaserTexture")







//Controller textures
let controllerBaseTexture = Assets.sharedInstance.sprites.textureNamed("controllerBase-1")
let controllerHandleTexture = Assets.sharedInstance.sprites.textureNamed("controllerHandle-1")
//Pause button texture
let pauseButtonTexture = Assets.sharedInstance.sprites.textureNamed("pauseButton")







var totalNodes = 0


//Build the Game Scene
class GameScene: SKScene, SKPhysicsContactDelegate {

    
    
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
            self.aliensKilledLabel?.text = "Dead Foes: " + String(aliensKilled)
            score = aliensKilled + numberBossesKilled * 50

        }
        
    }
    fileprivate var aliensKilledLabel:SKLabelNode?
    
    var numberBossesKilled = 0
    
    //Instantiate the ship
    var aShip = Ship(startPosition: CGPoint(x:50,y:200), controllerVector: controlVector)
    
    
    //Build the shipLives label
    fileprivate var shipLives = 3 {
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

    
    
    
    //var background:BackGroundAnimation
    //Pause button...
    //var pauseButton = PauseButton?()
    var pauseButton:PauseButton? = nil
    let progressBar : ProgressBar? = nil
    //var backGround:BackGroundAnimation?
    
    var heartArray:[SKSpriteNode] = []

    func removeHeart(){
        let lostHeart = heartArray.removeFirst()
        
        lostHeart.removeFromParent()
        
    }
    
    //var backGround:BackGroundAnimation
    
//    let allNodes:Int = subtreeCount()
    
    //Main scene did move to view drawing
    override func didMove(to view: SKView) {
        shotsFired = 0
        
        
        
        let screenSize:CGSize = (view.scene?.size)!

        //Pause button...
        pauseButton = PauseButton(theTexture: pauseButtonTexture, aScene: self)
        pauseButton!.position = CGPoint(x: (screenSize.width) - pauseButton!.size.width*0.7, y:(screenSize.height) - pauseButton!.size.height*0.7)
        addChild(pauseButton!)

        
        for index in 0...shipLives-1 {
            let heart:SKSpriteNode = SKSpriteNode(texture: heartTexture)
            //heart.setScale(0.1)
            let spaceFactor = 1.2 * heart.size.width * CGFloat(index)
            heart.position = CGPoint(x:screenSize.width*0.3 + spaceFactor, y:heart.size.height * 0.7)//screenSize.height*0.1)
            heartArray.append(heart)
            addChild(heart)
        }
        
        

    
        
        
        //So when we go back to scene the ship isnt moving from the last played game
        controlVector = CGVector(dx: 0,dy: 0)
        aShip.physicsBody?.velocity = CGVector(dx:0, dy:0)

        
        let scoreWordLabel = SKLabelNode(fontNamed: "Chalkduster")//"Times New Roman")
        scoreWordLabel.text = "Score: "// + String(score)
        scoreWordLabel.fontSize = screenSize.width * 0.04
        scoreWordLabel.position = CGPoint(x:screenSize.width*0.6,y:screenSize.height*0.02)
        self.addChild(scoreWordLabel)
        //self.scoreLabel = scoreWordLabel
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")//"Times New Roman")
        scoreLabel.text = String(score)//"Score: " + String(score)
        scoreLabel.fontSize = screenSize.width * 0.04
        //scoreLabel.anchorPoint
        
        let scoreNumXPos = scoreWordLabel.position.x + scoreWordLabel.frame.width/1.5
        
        scoreLabel.position = CGPoint(x:scoreNumXPos + scoreLabel.frame.width,y:scoreWordLabel.position.y)
        
        //scoreLabel.position = CGPoint(x:screenSize.width*0.6+scoreLabelWidth,y:screenSize.height*0.02)
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
        
        
        
        let aliensKilledLabel = SKLabelNode(fontNamed: "Times New Roman")
        //aliensKilledLabel.text = aliensKilled.description
        aliensKilledLabel.text = "Foes Killed: " + String(aliensKilled)
        aliensKilledLabel.fontSize = self.frame.width * 0.02 //screenSize.width * 0.1// 14
        aliensKilledLabel.position = CGPoint(x:self.frame.midX*0.8,y:self.frame.midY*0.02)
        //self.addChild(aliensKilledLabel)
        self.aliensKilledLabel = aliensKilledLabel
        
        
        let shipLivesLabel = SKLabelNode(fontNamed: "Times New Roman")
        shipLivesLabel.text = "Lives: " + String(aShip.lives)
        shipLivesLabel.fontSize = self.frame.width * 0.02 //14
        shipLivesLabel.position = CGPoint(x:self.frame.midX*1.3,y:self.frame.midY*0.02)
        //self.addChild(shipLivesLabel)
        self.shipLivesLabel = shipLivesLabel
        

        //let totalNodesLabel = SKLabelNode(fontNamed: "Times New Roman")
        //totalNodesLabel.text = "totalNodes: " + String(self.totalNodes)
        //totalNodesLabel.fontSize = 14
        //totalNodesLabel.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        //self.addChild(totalNodesLabel)
        //self.totalNodesLabel = totalNodesLabel
        
        //var powerupTimerLabel = SKLabelNode(fontNamed:"Times New Roman")
        //powerupTimerLabel.text = "PU Time: " //this should be modified within the ship class
        //powerupTimerLabel.fontSize = 14
        //powerupTimerLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        //Where should this be added from?
        //self.addChild(powerupTimerLabel)
        
        //Set up the scene structure
        backgroundColor = SKColor.black
        
        addChild(aShip)

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        /* Set up for the controller */
        //Establish the base
        
        print("TITIS",size.width,self.frame.width)
        
        controlBase.size = CGSize(width: self.frame.width/8, height: self.frame.width/8) //90
        controlBase.position = CGPoint(x:controlBase.size.width*0.55,y:controlBase.size.height*0.55)//size.width*0.075, y:size.height*0.1)
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
        controlStick.alpha = 0.5
        
        
        
        //Start spawning normal aliens immediately
        
        startSpawningNorm()
        
        //Begin count down for bosses
        startSpawningBosses()
        //spawnPowerup()
        //startSpawningPowerUps()
        //startSpawningPowerUps()


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

        killOffAlien((alien)!)
        aliensKilled = aliensKilled + 1
        shipLives = shipLives-1
        aShip.lives = aShip.lives - 1
        removeHeart()

        
        
        print("ship/alien contact")
        
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
        
        
        if(aliensKilled > 20 && downNotCalledYet){
            startSpawningDown()
            downNotCalledYet = false
        }
        if(aliensKilled > 40 && behindNotCalledYet){
            startSpawningBehind()
            behindNotCalledYet = false
        }

        if(aliensKilled % 60 == 0 && aliensKilled != 0 && aliensKilled != currentAliensKilled){
            spawnPowerup()
            currentAliensKilled = aliensKilled
        }
        
        

        
        //Create and go to the game over scene if the ship has 0 lives
        if(shipLives<1){
            gameOver()
        }
        
        
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
        let alienInst = normAlien(startPos:CGPoint(x: 10,y: 10), speed: random(UInt32(10), max: UInt32(50))*mult[0])
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
        
        let boss = bossAlien1(startPos: CGPoint(x:xCoord,y:yCoord))
        addChild(boss)
        
    }
    

    
    func normalizeVector(_ v:CGVector) -> CGVector{
        let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
        let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
        return ans
    }
    

    
    //A dictionary to hold all touch start locations
    var startingTouches = [UITouch : CGPoint]()

    
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
            
            if(pauseButton!.contains(location)){
                pauseButton!.switchState()
            }
            
            
            if(!controlBase.frame.contains(location) && !pauseButton!.contains(location) && !scene!.isPaused){
                
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
            if(controlBase.frame.contains(touchStartPoint) && !scene!.isPaused){
            
                let joyVector = CGVector(dx:location.x - controlBase.position.x, dy:location.y - controlBase.position.y)
                controlStick.position = location
                
                let rangeToCenterSprite = SKRange(lowerLimit: 0, upperLimit: controlBase.size.width/2 - controlStick.size.width/2)
                let distanceConstraint:SKConstraint = SKConstraint.distance(rangeToCenterSprite, to: controlBase.position)
                controlStick.constraints = [distanceConstraint]
                
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
            
            //Reset if touch that is on controller is lifted or if no fingers are on the screen
            if(controlBase.frame.contains(startingTouches[touch as! UITouch]!)){
                resetController()
                aShip.updateShipProperties(shipVelocity: controlVector, laserStartPos: CGPoint(x:0,y:0))

            }
                
            //If it wasn't in the move box then the potential continual shot ended
            else{
                //If user lifts finger while automatic enabled then stop firing
                //aShip.gun.shootingFingerDown = false
                if(!aShip.gun.gunSettings.semiAutomatic){
                    aShip.gun.removeAction(forKey: "shootMachineGunLaser")
                }
            }

            //Remove the touch
            startingTouches.removeValue(forKey: touch as! UITouch)
        }

    }

    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        //let allNodes:Int = subtreeCount()
        //print("Total Nodes: ",allNodes)


        aShip.updateProgressBar()

//        if(shipLives<1){
//            enumerateChildNodesWithName("normAlien", usingBlock: gameOverBounceMode)
//            enumerateChildNodesWithName("downAlien", usingBlock: gameOverBounceMode)
//            enumerateChildNodesWithName("behindAlien", usingBlock: gameOverBounceMode)
//
//        }
        
        //Screen boundries (Loop ship position)
        if(aShip.position.x > self.size.width){
            aShip.position.x = 0
        }
        if(aShip.position.x < 0){
            aShip.position.x = self.size.width
        }
        if(aShip.position.y > self.size.height + aShip.size.height/2){
            aShip.position.y = 0
        }
        if(aShip.position.y < 0){
            aShip.position.y = self.size.height - aShip.size.height/2
        }
        
        
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
        

        //Uncomment this
        self.aShip.gun.enumerateChildNodes(withName: "laser",
                                         using: { node, _ in
                                            if let aLaser = node as? Laser {
                                                let positionInScene = self.convert(aLaser.position, from: self.aShip.gun)

                                                
//                                          if(aLaser.position.x > self.size.width){
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

                    if(aNormAlien.position.x < -aNormAlien.size.width){
                        aNormAlien.removeFromParent()
                        //self.totalNodes-=1
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





























