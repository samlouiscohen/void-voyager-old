//
//  PowerUps.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/15/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit



protocol PowerupBallVariables {
    
    var powerupType:String {get set}
    var texture:SKTexture {get set}
    var ballSpeed:Double {get set}
    var runTime:CGFloat {get set}
    //var gunVars:normGun {get set}
    //var ballRadius:Double {get set}
    
}


//let powerupBallHugeTexture = SKTextureAtlas(named:"Sprites").textureNamed("Hugepowerupball")
//let powerupBallSprayTexture = SKTextureAtlas(named:"Sprites").textureNamed("spraypowerupBall")
//let powerupBallRapidTexture = SKTextureAtlas(named:"Sprites").textureNamed("powerupBallRapid")
//
//let hugeLaserTexture = SKTextureAtlas(named:"Sprites").textureNamed("hugeLaser")
//let sprayLaserTexture = SKTextureAtlas(named:"Sprites").textureNamed("sprayBallLaser")




//Powerup structs that initialize the powerupball type and its associated characteristics

struct SprayGunBall:PowerupBallVariables{
    var powerupType = "spray"
    var texture: SKTexture = powerupBallSprayTexture
    var ballSpeed: Double = 10
    var runTime:CGFloat = 10
    //var gunVars:normGun = bigGun()
    
}


struct HugeGunBall:PowerupBallVariables{
    var powerupType = "huge"
    var texture: SKTexture = powerupBallHugeTexture
    var ballSpeed: Double = 10
    var runTime:CGFloat = 10
    
}


struct MachineGunBall:PowerupBallVariables{
    var powerupType = "machineGun"
    var texture: SKTexture = powerupBallRapidTexture
    var ballSpeed: Double = 10
    var runTime:CGFloat = 10
    
}




class PowerUpBall:SKSpriteNode{
    //The 'container' for powerups
    
    
    var ballSettings:PowerupBallVariables //What does this really do?
    
    let timer = 30
    
    
    init(theBallSettings:PowerupBallVariables){
        
        
        ballSettings = theBallSettings
        
        super.init(texture: ballSettings.texture, color: UIColor.clearColor(), size: ballSettings.texture.size())
        
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: ballSettings.texture.size().width/2)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.PowerUp
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
        
        
        self.physicsBody?.collisionBitMask = PhysicsCategory.None //Which one is better??
        self.physicsBody?.collisionBitMask = 0;
        
        
        self.physicsBody?.usesPreciseCollisionDetection = true //Do I even need this..?
        
        self.physicsBody?.linearDamping = 0.0;
        
        
        
        
        //These are all staying the same for now
        self.physicsBody?.velocity = CGVector(dx:-20,dy:0)
        //self.position = CGPoint(x:(scene?.size.width)!/2,y: (scene?.size.height)!/2)    =
        self.position = CGPoint(x:800,y:200)
        
    }
    
    
    func animateRemove(){
        
        func freezePowerupBall(){
            self.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
        }
        
        func remove(){
            self.removeFromParent()
        }
        
        let stopBallMotion = SKAction.runBlock(freezePowerupBall)
        let animate = SKAction.fadeOutWithDuration(1)
        let removeFromParent = SKAction.runBlock(remove)
        
        let used = SKAction.sequence([stopBallMotion, animate, removeFromParent])
        
        runAction(used)
        
    }
    
    
    func apply(theShip:Ship){
        //theShip.gun.removeActionForKey("shootMachineGunLaser")

        //Clean this up for multiple powerups (currently restricted to 1)
        removeAllPreExisting(theShip)
        
        switch (ballSettings.powerupType){
           
            //In each case we should reset the ship to default and also reset the timer
            case "spray":
                theShip.gun = SprayGun()
                theShip.attachGun(theShip.gun)//both of these lines should be within the "attach gun" method, maybe name "configureGun" or something
            case "huge":
                //theShip.gun = GenericGun()
                theShip.gun.gunSettings = hugeGunVariables()
            
            
            case "machineGun":
                theShip.gun.gunSettings = machineGunVariables()
                //theShip.gun = GenericGun()
            
            default:
                print("Default that ass")
                theShip.gun = GenericGun()
                theShip.attachGun(theShip.gun)
                theShip.gun.gunSettings = normGunVariables()
            
        }
        
    }
    
    
    
    func removeAllPreExisting(theShip:Ship){
        
        
        print("REmove EXISTING!!!!")
        
        
        //Restrict to only 1 powerup at a time
        
        //Remove the action before changing from the gun the action was called on
        if(!theShip.gun.gunSettings.semiAutomatic){
            theShip.gun.removeActionForKey("shootMachineGunLaser")
        }
        theShip.gun = GenericGun()
        theShip.attachGun(theShip.gun)
        theShip.gun.gunSettings = normGunVariables()
        
        
        if((theShip.parent?.childNodeWithName("progressBar")) != nil){
            theShip.parent?.childNodeWithName("progressBar")?.removeFromParent()
        }
        
        
        


    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



