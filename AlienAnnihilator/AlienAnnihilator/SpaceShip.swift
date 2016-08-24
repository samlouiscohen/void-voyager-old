//
//  Ship.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/14/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit




//The ship's gun variables that are set by contact with powerup balls


//Look into getter and setters on this
protocol GunVariables {
    
    var theLaserTexture:SKTexture {get set}
    var loadTimeSet:Double {get set}
    var semiAutomatic:Bool {get set}
    var name:String {get set}
    
}

struct normGunVariables:GunVariables{
    
    //let shipAnimation = normAnimation
    var theLaserTexture = laserTexture
    var loadTimeSet:Double = 0.5
    var semiAutomatic: Bool = true
    var name:String = "normGun"
    
}

struct hugeGunVariables:GunVariables{
    
    //let shipAnimation = normAnimation
    var theLaserTexture = hugeLaserTexture
    var loadTimeSet:Double = 0
    var semiAutomatic:Bool = true
    var name:String = "hugeGun"
    
}

struct machineGunVariables:GunVariables{
    var theLaserTexture = laserTexture
    var loadTimeSet:Double = 0
    var semiAutomatic:Bool = false //Automatic- I don't love this variable name (Not as explicit on Automatic case)
    var name:String = "machineGun"
}




//A different Gun class, rather than modifying the ship gun variables
class SprayGun:GenericGun{
    
    var laser1: Laser
    var laser2: Laser
    var laser3: Laser
    var laser4: Laser
    
    override init(){
        
        laser1 = Laser(theLaserTexture: sprayLaserTexture)
        laser2 = Laser(theLaserTexture: sprayLaserTexture)
        laser3 = Laser(theLaserTexture: sprayLaserTexture)
        laser4 = Laser(theLaserTexture: sprayLaserTexture)
        
        super.init()
    }
    
    
    override func addLaser(){
        
        print("ADD SPRAY LASERS!")
        
        laser1 = Laser(theLaserTexture: sprayLaserTexture)//gunSettings.theLaserTexture)
        laser1.physicsBody!.velocity = CGVector(dx:500,dy:0)
        
        laser2 = Laser(theLaserTexture: sprayLaserTexture)//gunSettings.theLaserTexture)
        laser2.physicsBody!.velocity = CGVector(dx:450,dy:160)
        
        laser3 = Laser(theLaserTexture: sprayLaserTexture)//gunSettings.theLaserTexture)
        laser3.physicsBody!.velocity = CGVector(dx:450,dy:-160)
        
        laser4 = Laser(theLaserTexture: sprayLaserTexture)//gunSettings.theLaserTexture)
        laser4.physicsBody!.velocity = CGVector(dx:-500,dy:0)
        
        
        self.addChild(laser1)
        self.addChild(laser2)
        self.addChild(laser3)
        self.addChild(laser4)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




















//------------------------------Gun class for the ship------------------------------

protocol Gun{
    
    var gunSettings:GunVariables {get set}
    var laser: Laser {get set}
    var loadingTime:NSTimer? {get set}
    //    var loadTimeSet:Double {get set}
    var stillLoading: Bool {get set}
    func shoot()
    func finishLoading()
    
    
}


class GenericGun:SKNode, Gun{
    
    
    var shootingFingerDown = false
    
    
    
    var gunSettings:GunVariables = normGunVariables()
    
    
    
    var laser: Laser// = Laser()
    
    //Loading time properties of the gun
    var loadingTime:NSTimer?
    //var loadTimeSet:Double = 0.5
    var stillLoading: Bool
    
    //Questionable
    override init(){
        
        print("Made generic gun")
        laser = Laser(theLaserTexture: gunSettings.theLaserTexture)
        
        
        stillLoading = false
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Ready the laser for fire
    func addLaser(){
        print("Add Laser")
        laser = Laser(theLaserTexture: gunSettings.theLaserTexture)
        self.addChild(laser)
        
        //This line was moved from right after the call to addLaser()
        self.laser.physicsBody!.velocity = CGVector(dx:500,dy:0)
    }
    
    //Ready laser and apply a foward velocity to it
    func shoot(){
        print("shoot")
        
        
        //        if(!self.gunSettings.semiAutomatic && self.shootingFingerDown){
        //            continualShooting()
        //        }
        
        //We cannot shoot if we're still loading the gun
        if(stillLoading){
            return
        }
        
        //If the gun is done loading we can shoot
        addLaser()
        //self.laser.physicsBody!.velocity = CGVector(dx:500,dy:0)
        
        
        //After shooting start loading gun timer again
        stillLoading = true
        
        
        self.loadingTime = NSTimer.scheduledTimerWithTimeInterval(gunSettings.loadTimeSet, target: self, selector: #selector(self.finishLoading), userInfo: nil, repeats: false)
        
    }
    
    
    
    
    //Method that is called by the scheduledTimer after a shot and wait time
    func finishLoading(){
        self.loadingTime?.invalidate()
        stillLoading = false
    }
    
    
    
    /*
     Work out clean logic for rapid shooting
     
     
     In gameScene:
     Finger down: calls fire()
     Finger up: sets shootingFingerDown == false
     
     
     In ship:
     
     1. fire() works by transfering shoot() logic based on the variable automatic
     2. If automatic: Then rapidFire() shoot be called
     
     rapidFire(): Should call checkFingerState()
     
     
     this all relys on the updating
     
     
     
     
     updateShootFingerState()
     
     continualShooting()
     
     
     */
    
    
    
    
    
    
    
    
    
    
    
    //Shoot() logic is transferred to this method if fire() is called and the gun is set to automatic
    func shootRapid(){
        
        /**
         Method to handle rapid shooting logic.
         If users finger is down, then run action "shootMachineGun" which adds and fires a laser every 0.1 second
         Otherwise, remove the action.
         
         *This allows for continual shooting on finger down-- no need to tap rapidly.
         
         */
        
        let fractionalWait = SKAction.waitForDuration(0.1)
        
        let loadLaser = SKAction.runBlock(addLaser)
        
        let rapidReloadAndFire = SKAction.sequence([loadLaser, fractionalWait])
        let shootMachineGun = SKAction.repeatActionForever(rapidReloadAndFire)
        
        self.runAction(shootMachineGun, withKey: "shootMachineGunLaser")
        
    }
    
    
    
    
    //Fire called from GameScene upon touch down
    func fire(){
        
        if(self.gunSettings.semiAutomatic){
            //Single shot
            shoot()
            print("fire led to a normal shot")
        }
        else{
            //Automatic
            print("THIS SHOULD BE CALLED ONCE!!!!!!")
            shootRapid()
            
        }
        
    }
    
    
}

//------------------------------Laser class for the ship------------------------------

class Laser:SKSpriteNode{
    
    var scaleSize:CGFloat = 0.6
    
    
    
    init(theLaserTexture:SKTexture){
        
        super.init(texture: theLaserTexture, color: UIColor.clearColor(), size: theLaserTexture.size())
        
        //Laser physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: theLaserTexture.size().width/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Laser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = 0;
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.linearDamping = 0.0;
        
        self.setScale(scaleSize)
        
        self.name = "laser"
        //remove()
    }
    
    
    //Is this more sensable than removing from the scene itself?
    func remove(){
        
        print("in function")
        if(self.position.x > (scene?.size.width)!/2){
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}










//--------------------------------Ship class-------------------------------

class Ship:SKSpriteNode{
    
    static var shipState = "norm"
    //var laser: Laser = Laser()
    
    //A dictionary with String keys and AnyType array values
    static var shipTypes: [String: [Any]] = [
        
        //Array structure: ship/laser textures, fireRate, health stats (maybe invincible on one?)
        "norm":[SKTexture(imageNamed:"Sprites/fullShip.png"), SKTexture(imageNamed:"Sprites/laser.jpg"),7],
        "rapid":[SKTexture(imageNamed:"Sprites/fullShip.png"),7],
        "bazooka":[SKTexture(imageNamed:"Sprites/fullShip.png"),7]
    ]
    
    
    
    
    //All variables as to allow for powerups?
    var moveSpeed:CGFloat
    
    var lives:Int
    
    var lasers = [SKSpriteNode]()
    var canShoot = false
    
    
    
    var gun:GenericGun = GenericGun()
    
    
    let scaleFactor:CGFloat = 0.5
    
    init(startPosition startPos:CGPoint, controllerVector:CGVector){
        
        self.lives = 3
        self.moveSpeed = 160
        
        super.init(texture: shipStartTexture, color: UIColor.clearColor(), size: shipStartTexture.size())
        
        //Set position
        self.position = startPos
        
        //Add the gun to the ship (addChild and also relative positioning)
        attachGun(gun)
        
        //This scale should be corrected within photoshop itself
        self.setScale(scaleFactor)
        
        //Physics of the ship
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Alien
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.angularVelocity = CGFloat(0)
        self.physicsBody?.affectedByGravity = false //TBD
        
        self.physicsBody?.velocity.dx = controllerVector.dx * moveSpeed
        self.physicsBody?.velocity.dy = controllerVector.dy * moveSpeed
        
        self.name = "ship"
        
        //Call animations
        self.animateShip1()
        
    }
    
    
    func updateVelocity(v:CGVector){
        self.physicsBody?.velocity.dx = v.dx * moveSpeed
        self.physicsBody?.velocity.dy = v.dy * moveSpeed
    }
    
    
    func attachGun(gun:GenericGun){
        gun.position = CGPointMake(self.size.width/2 + (self.size.width/15),-self.size.width/30)
        self.addChild(gun)
    }
    
    
    func animateShip1() {
        let animate = SKAction.animateWithTextures(shipFrames, timePerFrame: 0.1)
        let forever = SKAction.repeatActionForever(animate)
        self.runAction(forever)
    }
    
    
    func updateShipProperties(shipVelocity v:CGVector,laserStartPos laserStart:CGPoint){
        updateVelocity(v)
        //ect. ect.
    }
    
    
    
    
    
    
    
    //Timer to deactivate a given powerup
    
    func startPowerupTimer(powerupTime:Int){
        
        print("END THE GUN NOW!!!")
        var timeLeft:Int = powerupTime
        
        let oneSecondWait = SKAction.waitForDuration(1)
        
        //Function to add the timer label HERE
        
        func modifyTimer(){
            
            if(timeLeft > 0){
                timeLeft -= 1
                print(timeLeft)
                
            }
            else{
                //remove label here
                
                if(self.gun.gunSettings.name == "machineGun"){ removeMachineGun() }
                resetGun()
                print("PowerUp over")
                self.removeActionForKey("powerupTimer")
                
            }
        }
        
        
        func removeMachineGun(){
            self.gun.removeActionForKey("shootMachineGunLaser")
            //self.gun.shootingFingerDown = false
            print("Remove action for shootMAchine")
            //Without this line then it isnt updated after the powerup HERE
            //self.gun.continualShooting()
            
            //updateGunStatus()
            
        }
        
        
        
        func resetGun(){
            print("RESET gun")
            self.gun = GenericGun()
            self.attachGun(self.gun)
            self.gun.gunSettings = normGunVariables()
            
        }
        
        
        let checkTimeLeft = SKAction.runBlock(modifyTimer)
        
        
        
        let runPowerupClock = SKAction.repeatActionForever(SKAction.sequence([oneSecondWait, checkTimeLeft]))
        
        self.runAction(runPowerupClock, withKey: "powerupTimer")
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}