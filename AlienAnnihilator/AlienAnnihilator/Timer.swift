//
//  Timer.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/4/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit




//Timer class and Protocol

protocol TimerDelegate {
    func timerWillStart(_ timer : Timer)
    func timerDidFire(_ timer : Timer)
    func timerDidPause(_ timer : Timer)
    func timerWillResume(_ timer : Timer)
    func timerDidStop(_ timer : Timer)
}



class Timer : NSObject {
    
    var timer : Foundation.Timer!
    var interval : TimeInterval
    var difference : TimeInterval = 0.0
    var delegate : TimerDelegate?
    
    init(interval: TimeInterval, delegate: TimerDelegate?)
    {
        self.interval = interval
        self.delegate = delegate
    }
    
    func start(_ aTimer : Foundation.Timer?){
        if aTimer != nil {
            fire()
        }
        
        if timer == nil {
            delegate?.timerWillStart(self)
            timer = Foundation.Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        }
    }
    
    func pause(){
        if timer != nil {
            difference = timer.fireDate.timeIntervalSince(Date())
            timer.invalidate()
            timer = nil
            delegate?.timerDidPause(self)
        }
    }
    
    func resume(){
        if timer == nil {
            delegate?.timerWillResume(self)
            if difference == 0.0 {
                start(nil)
            } else {
                Foundation.Timer.scheduledTimer(timeInterval: difference, target: self, selector: #selector(start), userInfo: nil, repeats: false)
                difference = 0.0
            }
        }
    }
    
    func stop(){
        if timer != nil {
            difference = 0.0
            timer.invalidate()
            timer = nil
            delegate?.timerDidStop(self)
        }
    }
    
    func fire(){
        delegate?.timerDidFire(self)
        
    }
}
