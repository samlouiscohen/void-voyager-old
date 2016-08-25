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





var shipAnimationFrames : [SKTexture]!


//Preload textures of GameScene before running it
let laserTexture = SKTextureAtlas(named:"Sprites").textureNamed("laser")
let shipStartTexture = SKTextureAtlas(named:"Sprites").textureNamed("samShip1")

let powerupBallTexture = SKTextureAtlas(named:"Sprites").textureNamed("powerupBall")
//let fireRateBallTexture = SKTextureAtlas(named:"Sprites").textureNamed("powerupBall")

let powerupBallHugeTexture = SKTextureAtlas(named:"Sprites").textureNamed("Hugepowerupball")
let powerupBallSprayTexture = SKTextureAtlas(named:"Sprites").textureNamed("spraypowerupBall")
let powerupBallRapidTexture = SKTextureAtlas(named:"Sprites").textureNamed("powerupBallRapid")

let hugeLaserTexture = SKTextureAtlas(named:"Sprites").textureNamed("hugeLaser")
let sprayLaserTexture = SKTextureAtlas(named:"Sprites").textureNamed("sprayBallLaser")

let allisonFaceTexture = SKTextureAtlas(named:"Sprites").textureNamed("allisonFace")
let sydFaceTexture = SKTextureAtlas(named:"Sprites").textureNamed("sydParty")




var trumpFaceTexture = SKTextureAtlas(named:"Sprites").textureNamed("trumpFaceOpen1")
let mikeFaceTexture = SKTextureAtlas(named:"Sprites").textureNamed("mikeAlien")
let behindAlienTexture = SKTextureAtlas(named:"Sprites").textureNamed("alien1_1")

let boss1StartTexture = SKTextureAtlas(named:"Sprites").textureNamed("bossAlienReal0")
let boss1BigEyeTexture = SKTextureAtlas(named:"Sprites").textureNamed("boss1Eye")
let boss1BigEyeSocketTexture = SKTextureAtlas(named:"Sprites").textureNamed("boss1BigEyeSocket")
let boss1SmallEyeTexture = SKTextureAtlas(named:"Sprites").textureNamed("boss1SmallEye")
let boss1SmallEyeSocketTexture = SKTextureAtlas(named:"Sprites").textureNamed("boss1SmallEyeSocket2")



let textureAtlas = SKTextureAtlas(named:"Sprites")

let shipFrames = ["shipSam1","shipSam2","shipSam3","shipSam4","shipSam5","shipSam6","shipSam7","shipSam8","shipSam9",
    "shipSam10","shipSam10","shipSam10","shipSam10","shipSam10",
    "shipSam9","shipSam8","shipSam7","shipSam6","shipSam5","shipSam4","shipSam3","shipSam2","shipSam1"].map{textureAtlas.textureNamed($0)}// look up map

let trumpFrames = ["trumpFaceOpen1","trumpFaceOpen2","trumpFaceOpen3","trumpFaceOpen4"].map{textureAtlas.textureNamed($0)}// look up map
let behindFrames = ["alien1_1","alien1_2","alien1_3","alien1_4","alien1_5","alien1_6","alien1_7","alien1_8",
    
    "alien1_8","alien1_7","alien1_6","alien1_5","alien1_4","alien1_3","alien1_2","alien1_1",
    
    ].map{textureAtlas.textureNamed($0)}// look up map
let bossFrames = ["bossAlienReal10","bossAlienReal10","bossAlienReal10","bossAlienReal9","bossAlienReal9","bossAlienReal9","bossAlienReal8","bossAlienReal8","bossAlienReal7","bossAlienReal7","bossAlienReal6","bossAlienReal6","bossAlienReal5","bossAlienReal4","bossAlienReal3","bossAlienReal2","bossAlienReal1","bossAlienReal0","bossAlienReal1","bossAlienReal2","bossAlienReal3","bossAlienReal4","bossAlienReal5","bossAlienReal6","bossAlienReal6","bossAlienReal7","bossAlienReal7","bossAlienReal8","bossAlienReal8","bossAlienReal9","bossAlienReal9","bossAlienReal9","bossAlienReal10","bossAlienReal10","bossAlienReal10"].map{textureAtlas.textureNamed($0)}// look up map


let controllerBaseTexture = SKTextureAtlas(named:"Sprites").textureNamed("controllerBase")
let controllerHandleTexture = SKTextureAtlas(named:"Sprites").textureNamed("controllerHandle")

let pauseButtonTexture = SKTextureAtlas(named:"Sprites").textureNamed("pauseButton")



//Build the Game Scene
class GameScene: SKScene, SKPhysicsContactDelegate {

    
    var bossOn = false
    var currentAliensKilled = 0
    
    //Multiplers ordered as: speed, spawn time, lives?
    var normAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    var downAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    var behindAlienMultiplers:[CGFloat] = [1.0, 0.01, 1.0]
    
    
    var downNotCalledYet = true
    var behindNotCalledYet = true
    
    //Build the Aliens killed Label
    private var aliensKilled = 0 {
        didSet{
            self.aliensKilledLabel?.text = "Dead Foes: " + String(aliensKilled)
        }
    }
    private var aliensKilledLabel:SKLabelNode?
    var numberBossesKilled = 0
    
    //Instantiate the ship
    var aShip = Ship(startPosition: CGPoint(x:50,y:200), controllerVector: controlVector)
    
    
    //Build the shipLives label
    private var shipLives = 3 {
        didSet{
            self.shipLivesLabel?.text = "Lives: " + String(shipLives)
        }
    }
    private var shipLivesLabel:SKLabelNode?
    

    //controller configthis is the way to d
    let controlStick = SKSpriteNode(texture: controllerHandleTexture, color: UIColor.clearColor(), size: controllerHandleTexture.size())
    let controlBase = SKSpriteNode(texture: controllerBaseTexture, color: UIColor.clearColor(), size: controllerBaseTexture.size())
    var controllerOn:Bool = false

    
    //Pause button...
    var pauseButton = PauseButton?()

    
    //Main scene did move to view drawing
    override func didMoveToView(view: SKView) {
        
        //let powerup = PowerUpBall(startPos: CGPoint(x:200,y:200), ballSpeed: 8)
//        let powerup = increaseFireRateBall()
        
        
        //print("hi")
        self.runAction(SKAction.fadeInWithDuration(0))
        
        //super.didMoveToView(view)
        //self.size = view.frame.size
        
        let screenSize:CGSize = (view.scene?.size)!
        
        //var pauseButton = PauseButton?()//(theTexture: pauseButtonTexture)//, gameScene: self)//SKSpriteNode(imageNamed: "pauseButton")
        //let pauseButton = PauseButton(texture: pauseButtonTexture, viewSceneSize: (view.scene?.size)!)//SKSpriteNode(imageNamed: "pauseButton")
        
        
        
        //Pause button...
        pauseButton = PauseButton(theTexture: pauseButtonTexture, gameScene: self)
        pauseButton!.position = CGPoint(x: (view.scene?.size.width)! - pauseButton!.size.width*0.7, y:(view.scene?.size.height)! - pauseButton!.size.height*0.7)
        addChild(pauseButton!)
        
//
        
//        
//        pauseButton.alpha = 0.5
//        addChild(pauseButton)
        //spawnBoss()
        
        
        //Preload all textures for preformance improvements
//        SKTextureAtlas(named: "Sprites").preloadWithCompletionHandler {
//            // Now everything you put into the texture atlas has been loaded in memory????
//            
//        }
        
        
        //So when we go back to scene the ship isnt moving from the last played game
        controlVector = CGVector(dx: 0,dy: 0)

        let aliensKilledLabel = SKLabelNode(fontNamed: "Times New Roman")
        //aliensKilledLabel.text = aliensKilled.description
        aliensKilledLabel.text = "Foes Killed': " + String(aliensKilled)
        aliensKilledLabel.fontSize = 14
        aliensKilledLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*0.8,y:CGRectGetMidY(self.frame)*0.1)
        self.addChild(aliensKilledLabel)
        self.aliensKilledLabel = aliensKilledLabel
        
        
        let shipLivesLabel = SKLabelNode(fontNamed: "Times New Roman")
        shipLivesLabel.text = "Lives: " + String(aShip.lives)
        shipLivesLabel.fontSize = 14
        shipLivesLabel.position = CGPoint(x:CGRectGetMidX(self.frame)*1.3,y:CGRectGetMidY(self.frame)*0.1)
        self.addChild(shipLivesLabel)
        self.shipLivesLabel = shipLivesLabel
        

        
        var powerupTimerLabel = SKLabelNode(fontNamed:"Times New Roman")
        powerupTimerLabel.text = "PU Time: " //this should be modified within the ship class
        powerupTimerLabel.fontSize = 14
        powerupTimerLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        //Where should this be added from?
        //self.addChild(powerupTimerLabel)
        
        
        
        
        //Set up the scene structure
        backgroundColor = SKColor.blackColor()
        
        addChild(aShip)

        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        
        /* Set up for the controller */
        //Establish the base
        controlBase.position = CGPoint(x:size.width*0.075, y:size.height*0.1)
        controlBase.size = CGSize(width: 90, height: 90)
        controlBase.zPosition = 1
        controlBase.name = "controlBase"
        addChild(controlBase)
        
        //Establish the stick
        controlStick.position = controlBase.position
        controlStick.size = CGSize(width: 50, height: 50)
        controlStick.zPosition = 2
        controlStick.name = "controlStick"
        addChild(controlStick)

        //Make semi-transparent
        controlBase.alpha = 0.25
        controlStick.alpha = 0.25
        
        
        
        //Start spawning normal aliens immediately
        startSpawningNorm()
        
        


        startSpawningPowerUps()

//        let prog = ProgressBar()
//        prog.position = CGPoint(x:200,y:200)
//        
//        addChild(prog)
        

    }
    
    
    
    
    //This could be incremental- so u can shoot powerups, maybe they have 3 lives and if u kill it u kill it- but otherwise most will help u and they will stay the whole game
    func startSpawningPowerUps(){
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            
            SKAction.waitForDuration(3),
            SKAction.runBlock(spawnPowerUps)
            
            
            ])))
    }
    
    func spawnPowerUps(){
        
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
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addNormAlien),
            SKAction.waitForDuration(Double(random(1,max: 2))-Double(normAlienMultiplers[1])),
            SKAction.runBlock(updateNormMultipliers)
            ])))
    }
    
    func startSpawningDown(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addDownAlien),
            SKAction.waitForDuration(Double(random(8,max: 15))-Double(downAlienMultiplers[1])),
            SKAction.runBlock(updateDownMultipliers)
            ])))
    }
    
    func startSpawningBehind(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addBehindAlien),
            SKAction.waitForDuration(Double(random(10,max: 20))-Double(behindAlienMultiplers[1])),
            SKAction.runBlock(updateBehindMultipliers)
            ])))
    }
    

    
    
    func killOffAlien(alien:SKNode){
        
        func stopMotion(){
            alien.physicsBody?.categoryBitMask = 0
            alien.physicsBody?.collisionBitMask = 0
            alien.physicsBody?.contactTestBitMask = 0
            
            alien.physicsBody?.dynamic = false
            alien.physicsBody?.velocity = CGVector(dx:0, dy:0)
            alien.removeActionForKey("facialMotion")
        }

        
        func removeAlien(){
            alien.removeFromParent()
        }
        
        let stopMoving = SKAction.runBlock(stopMotion)
        let color = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.7, duration: 0)

        let fadeOut = SKAction.fadeOutWithDuration(1)
        let removeFromParent = SKAction.runBlock(removeAlien)
        
        let die = SKAction.sequence([stopMoving, color, fadeOut, removeFromParent])

        alien.runAction(die)
    }
    
    
    
    
    func alien_laser_contact(contact:SKPhysicsContact){
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
    
    
    func boss_laser_contact(contact:SKPhysicsContact){
        
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
            }
            
        } else if let theBoss = contact.bodyB.node as? bossAlien1 {
            theBoss.shot()
            if(theBoss.lives < 1){
                numberBossesKilled += 1
            }
        }
        

        
        
    }
    
    
    func boss_ship_contact(contact:SKPhysicsContact){
        
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


    
    func alien_ship_contact(contact:SKPhysicsContact){
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

        aliensKilled = aliensKilled + 1
        shipLives = shipLives-1
        aShip.lives = aShip.lives - 1
        
        killOffAlien((alien)!)
        
    }
    
    
    
    
    
    
    
    
    func ship_powerup_contact(contact:SKPhysicsContact){
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
            
//            //aShip.applyPowerup(thePowerup)
//            //thePowerup.apply(aShip)
//            thePowerup.animateRemove()
            
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
    
    
    
    func didBeginContact(contact:SKPhysicsContact){
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
//
        if(aliensKilled % 60 == 0 && aliensKilled != 0 && aliensKilled != currentAliensKilled){
            
            spawnBoss()
            currentAliensKilled = aliensKilled
            
            //print("boss")

        }
        

        
        //Create and go to the game over scene if the ship has 0 lives
        if(shipLives<1){
            gameOver()
        }
        
        
    }
    
    
    
    func gameOver(){
        let gameOverScene = GameOverScene(size: self.size, aliensKilled: self.aliensKilled, numberBossesKilled: self.numberBossesKilled)
        //self.view?.presentScene(gameOverScene, transition: reveal)
        self.view?.presentScene(gameOverScene, transition: SKTransition.fadeWithColor(SKColor.redColor(), duration: 3))
    }
    

    func random(min:UInt32, max:UInt32) -> CGFloat{
        return CGFloat(arc4random_uniform(max - min) + min)
        //return CGFloat(arc4random_uniform(2))*(max-min) + min
    }
    
    
    
    
    
    
    
    
    

    
    //Make all this code way more compact later
    func updateNormMultipliers(){
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
    
    
    
    func incrementDifficulty(){
        
    }
    
    
    
    
    
    //Functions to create new alien instances with progressive difficulty
    func addNormAlien(){

        let mult = normAlienMultiplers
        
        let alienInst = normAlien(startPos:CGPoint(x: 10,y: 10), speed: random(UInt32(10),max: UInt32(50))*mult[0])
        
        let yStart = random(UInt32(alienInst.size.height/2), max: UInt32(size.height-alienInst.size.height))
        alienInst.position = CGPoint(x:size.width+alienInst.size.width/2, y:CGFloat(yStart))
        
        addChild(alienInst)
    }
    
    func addDownAlien(){
        
        let mult = downAlienMultiplers
        
        let alienInst = downAlien(startPos:CGPoint(x: 10,y: 10),speed: random(UInt32(10),max: UInt32(30))*mult[0])
        //this line makes no sense, maybe use lasy variables or something
        let xStart = random(UInt32(alienInst.size.width/2), max: UInt32(size.width-alienInst.size.width))
        alienInst.position = CGPoint(x: xStart, y:CGFloat(size.height + alienInst.size.width/2))
        addChild(alienInst)
    }
    
    func addBehindAlien(){
        
        let mult = behindAlienMultiplers
        
        let alienInst = behindAlien(startPos:CGPoint(x: 10,y: 10),speed: random(UInt32(5),max: UInt32(40))*mult[0])
        let yStart = random(UInt32(alienInst.size.height/2), max: UInt32(size.height-alienInst.size.height))
        alienInst.position = CGPoint(x: -alienInst.size.width/2, y:CGFloat(yStart))
        addChild(alienInst)
    }
    
    
    
    func spawnBoss(){
        bossOn = true
        //print("Bosssssssssssss")
        
        
        let bossSpawnLabel = SKLabelNode(fontNamed: "Times New Roman")
        //aliensKilledLabel.text = aliensKilled.description
        bossSpawnLabel.text = "BOSS INCOMING!"
        bossSpawnLabel.color = SKColor.redColor()
        bossSpawnLabel.fontSize = 24
        bossSpawnLabel.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        
        
        func addTheLabelChild(){
            
            addChild(bossSpawnLabel)
            //print("YEAH WE GOT THISSSSS")
            
        }
        func removeSpawnLabel(){
            bossSpawnLabel.removeFromParent()
        }
        
        let labelWaitTime = SKAction.waitForDuration(1)
        
        let fadeIn = SKAction.fadeInWithDuration(1)
        let fadeOut = SKAction.fadeOutWithDuration(4)
        
        func animateLabel(){
            
            let labelWaitTime = SKAction.waitForDuration(3)
            
            let fadeIn = SKAction.fadeInWithDuration(2)
            let fadeOut = SKAction.fadeOutWithDuration(4)
            
            
            let labelAnimation = SKAction.sequence([fadeIn,labelWaitTime,fadeOut])
            
            
            //bossSpawnLabel.runAction(SKAction.sequence([fadeIn,labelWaitTime,fadeOut]))
            //print("hello99999")
            
            let waitTillRemove = SKAction.waitForDuration(labelAnimation.duration)
            let labelRemove = SKAction.removeFromParent()
            
            
            bossSpawnLabel.runAction(SKAction.sequence([labelAnimation, waitTillRemove, labelRemove]))
            
        }
        
        
        let displayLabel = SKAction.sequence([SKAction.runBlock(addTheLabelChild),SKAction.runBlock(animateLabel)])
        
        //bossSpawnLabel.runAction(displayLabel)
        
        
        //Run the display label action on the GameScene
        self.runAction(displayLabel)
        
        
        
        
        let xCoord:CGFloat = -200//random(UInt32(0), max: UInt32(size.width))
        let yCoord = random(UInt32(0), max: UInt32(size.height))
        
        let boss = bossAlien1(startPos: CGPoint(x:xCoord,y:yCoord))
        addChild(boss)
        
    }
    

    
    func normalizeVector(v:CGVector) -> CGVector{
        let length: CGFloat = sqrt((v.dx*v.dx)+(v.dy*v.dy))
        let ans:CGVector = CGVector(dx:v.dx/length,dy:v.dy/length)
        return ans
    }
    
    


    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch : AnyObject in touches {
//            let location = touch.locationInNode(self)
//            let actionBouger = SKAction.moveTo(CGPoint(x: location.x, y: location.y), duration: 2.5)
//            ship.runAction(actionBouger)
//            let dx = location.x - ship.position.x
//            let dy = location.y - ship.position.y
//            var angleInRadians = atan2(dy, dx) - CGFloat(M_PI_2)
//            if(angleInRadians < 0){
//                angleInRadians = angleInRadians + 2 * CGFloat(M_PI)
//            }
//            ship.zRotation = angleInRadians
//            let actionAngle = SKAction.rotateToAngle(angleInRadians, duration: 0)
//            ship.runAction(actionAngle)
//        }
//    }
    

    
    //A dictionary to hold all touch start locations
    var startingTouches = [UITouch : CGPoint]()
    
    func goToGameScene(){
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size) // create your new scene
        let transition = SKTransition.fadeWithDuration(1.0) // create type of transition (you can check in documentation for more transtions)
        gameScene.scaleMode = SKSceneScaleMode.Fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)
            startingTouches[touch as! UITouch] = location
            
            if(CGRectContainsPoint(controlBase.frame, location) && !scene!.paused){
                controllerOn = true
            }
            else{
                controllerOn = false
            }
            
            if(pauseButton!.containsPoint(location)){
                pauseButton!.switchState()
            }
            
            
            if(!CGRectContainsPoint(controlBase.frame, location) && !pauseButton!.containsPoint(location) && !scene!.paused){
                
                
                //print("Has actions: ", aShip.gun.hasActions())
                aShip.gun.shootingFingerDown = true

                aShip.gun.fire()
                
                
            }
            
            if(CGRectContainsPoint(aShip.frame, location)){
                
                if(partyMode){
                    partyMode = false
                }
                else{
                    partyMode = true
                }
                
                
                
            }
            
            
            


        }
    }

    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)

            //The starting location of the given touch we're working with
            let touchStartPoint:CGPoint = startingTouches[touch as! UITouch]!
            
            
            //Play with this - Is it better than using the controller on??? (Note: u can move into the frame of the controller and move it)
            //if(controllerOn == true){
            if(CGRectContainsPoint(controlBase.frame, location) && !scene!.paused){
            
                let joyVector = CGVector(dx:location.x - controlBase.position.x, dy:location.y - controlBase.position.y)
                
                
                //Get angle between two components opp/adj of controlStick vector with arctan
                let angle = atan2(joyVector.dy, joyVector.dx)
                //Revise this- it's unneccasary because I normalize the vector anyway
                let length:CGFloat = controlBase.frame.size.height
                let xDist:CGFloat = sin(angle - 1.5879633) * length
                let yDist:CGFloat = cos(angle - 1.57879633) * length
                
                //Keep the stick on its "base"
                if(CGRectContainsPoint(controlBase.frame, location)){
                    controlStick.position = location
                }
                else{
                    controlStick.position = CGPoint(x:controlBase.position.x - xDist, y:controlBase.position.y - yDist)
                }

            
                //Float bc cosf only takes floats not CGFloats -> what is the real difference?
                //let degree = angle * CGFloat(180/M_PI)
                //var calcRotation:Float = Float(angle-1.57879633) + Float(M_PI_2)
                //let xVelocity = 50 * CGFloat(cosf(calcRotation))
                //let yVelocity = 50 * CGFloat(sinf(calcRotation))
                
                let v:CGVector = CGVector(dx:joyVector.dx,dy:joyVector.dy)
                let unitVector:CGVector = normalizeVector(v)
                controlVector = CGVector(dx:unitVector.dx,dy:unitVector.dy)
                

 
            }
        }
        

    }

    
    func resetController(){
        let move:SKAction = SKAction.moveTo(controlBase.position, duration: 0.2)
        //Causes the animation to slow as it progresses
        move.timingMode = .EaseOut
        controlStick.runAction(move)
        controlVector = CGVector(dx:0,dy:0)
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch : AnyObject in touches {
            
            //Does this make any more sense than the commented code below it?
            //difference is that this code if speaking strictly about touch's location at start time rather than location at end time!
            
            //Reset if touch that is on controller is lifted or if no fingers are on the screen
            if(CGRectContainsPoint(controlBase.frame, startingTouches[touch as! UITouch]!)){
                resetController()
            }
                
            //If it wasn't in the move box then the potential continual shot ended
            else{
                
                
                //If user lifts finger while automatic enabled then stop firing
                //aShip.gun.shootingFingerDown = false
                if(!aShip.gun.gunSettings.semiAutomatic){
                    
                    aShip.gun.removeActionForKey("shootMachineGunLaser")
                }
                
               
                
                
                //Force a call to this method to update it (****************THIS ISNT EVEN NEEDED? WHERE IS IT NEEDED?)
                //aShip.gun.updatefingerState()
            }
            
            
//            if(startingTouches.count < 1){
//                resetController()
//            }
            
            
        
            //Remove the touch
            startingTouches.removeValueForKey(touch as! UITouch)
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
    
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */



        

        
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
        
        
        aShip.updateShipProperties(shipVelocity: controlVector, laserStartPos: CGPoint(x:0,y:0))
        
        if(shipLives<1){
            enumerateChildNodesWithName("normAlien", usingBlock: gameOverBounceMode)
            enumerateChildNodesWithName("downAlien", usingBlock: gameOverBounceMode)
            enumerateChildNodesWithName("behindAlien", usingBlock: gameOverBounceMode)

        }
        
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
        

        
        
//        self.enumerateChildNodesWithName("progressBar",
//                                         usingBlock: { node, _ in
//                                            if let progressBar = node as? ProgressBar {
//                                                progressBar.update()
//                                                
//                                            }
//            }
//        )

        
        self.enumerateChildNodesWithName("bossAlien",
            usingBlock: { node, _ in
                if let bossSprite = node as? bossAlien1 {
                    bossSprite.update(self.aShip)
                    
                }
            }
        )
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
        
        
        self.aShip.gun.enumerateChildNodesWithName("laser",
                                         usingBlock: { node, _ in
                                            if let aLaser = node as? Laser {
                                                //print(self.size.width/2)
                                                //print(self.aShip.position.x)
                                                //print(aLaser.position.x)
                                                //print("hi")
                                                if(aLaser.position.x > self.size.width*2){
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
        
        self.enumerateChildNodesWithName("normAlien",
             usingBlock: { node, _ in
                if let aNormAlien = node as? normAlien {
                    //print(self.size.width/2)
                    //print(self.aShip.position.x)

                    if(aNormAlien.position.x < -aNormAlien.size.width){
                        aNormAlien.removeFromParent()
                    }
                }
            }
        )
        
        
        self.enumerateChildNodesWithName("behindAlien",
                                         usingBlock: { node, _ in
                                            if let aBehindAlien = node as? behindAlien {
                                                //print(self.size.width/2)
                                                //print(self.aShip.position.x)
                                                
                                                if(aBehindAlien.position.x > self.size.width*1.2){
                                                    aBehindAlien.removeFromParent()
                                                }
                                            }
            }
        )
        
        
        self.enumerateChildNodesWithName("downAlien",
                                         usingBlock: { node, _ in
                                            if let aDownAlien = node as? downAlien {

                                                
                                                if(aDownAlien.position.y < -aDownAlien.size.height){
                                                    aDownAlien.removeFromParent()
                                                }
                                            }
            }
        )
        
        
   
        
    }


    func gameOverBounceMode(node:SKNode, abool:UnsafeMutablePointer<ObjCBool>){
        node.physicsBody?.categoryBitMask = 0
    }
    


    
    

    
    
    
    
    
    
    
    
    
    
    

}





























