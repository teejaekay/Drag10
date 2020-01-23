//
//  GameScene.swift
//  drag10.2
//
//  Created by Taylor Kelly on 9/27/18.
//  Copyright © 2018 Taylor Kelly. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

var isHome = true;
var score: Int = 0;
var highscore: Int = 0;
var gameOver = false
var playing = false
var plus10 = false


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starNum = 0
    var playBackground = SKSpriteNode(imageNamed: "play_scene")
    var greenPlayer = SKSpriteNode(imageNamed: "Gstar")
    var yellowPlayer = SKSpriteNode(imageNamed: "yellowstar1")
    var bluePlayer = SKSpriteNode(imageNamed: "Bstar1")
    var redPlayer = SKSpriteNode(imageNamed: "Rstar1")
    var touchLocation1 = CGPoint()
    var touchLocation2 = CGPoint()
    var touchLocation3 = CGPoint()
    var touchLocation4 = CGPoint()
    var dragging = false
    var playerSpawn = false
    var canTouch = true
    var scoreLabel = SKLabelNode()
    var highscoreLabel = SKLabelNode()
    var countdown = 10
    var countdownLabel = SKLabelNode(text: "10")
    var timer = Timer()
    let delay = SKSpriteNode()
    let reason = SKSpriteNode()
    var wrongColor = false
    
    var wrongDrag = SKSpriteNode(imageNamed: "wrongDrag")
    var tooSlow = SKSpriteNode(imageNamed: "tooSlow")
    var earth = SKSpriteNode(imageNamed: "gameOverEarth")
    var gameOverText = SKSpriteNode(imageNamed: "gameOverText")
    var gameOverScores = SKSpriteNode(imageNamed: "gameOverScores")
    var tapTo = SKSpriteNode(imageNamed: "gameOverTapContinue")
    

    
    override func didMove(to view: SKView)
    {
        
        if isHome  == true
        {
        goHome()
        }
        else
        {
            spawnPlayer()
        }
        
       
        self.backgroundColor = SKColor.black
        playBackground.size = self.frame.size
        playBackground.zPosition = -5
        self.addChild(playBackground)
        
        tooSlow.position = CGPoint(x: 0, y: 0)
        tooSlow.zPosition = 3
        tooSlow.alpha = 0
        self.addChild(tooSlow)
        
        wrongDrag.position = CGPoint(x: 0, y: 0)
        wrongDrag.zPosition = 3
        wrongDrag.alpha = 0
        self.addChild(wrongDrag)
        
        reason.position = CGPoint(x: 500, y: 0)
        self.addChild(reason)
        
        
        delay.position = CGPoint(x: 0, y: 800)
        self.addChild(delay)
        
        gameOverText.position = CGPoint(x: 0, y: 850)
        gameOverText.zPosition = 3
        self.addChild(gameOverText)
        
        gameOverScores.position = CGPoint(x: -800, y: 0)
        gameOverScores.zPosition = 3
        self.addChild(gameOverScores)
        
        earth.position = CGPoint(x: 0, y: -400)
        earth.zPosition = 3
        self.addChild(earth)
        
        scoreLabel.fontSize = 170
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontName = "New Amsterdam"
        scoreLabel.zPosition = 2
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: 270, y: 514)
        self.addChild(scoreLabel)
        
        highscoreLabel.fontSize = 140
        highscoreLabel.fontColor = SKColor.white
        highscoreLabel.fontName = "New Amsterdam"
        highscoreLabel.zPosition = 2
        highscoreLabel.text = String(highscore)
        highscoreLabel.position = CGPoint(x: 450, y: -148.699)
        self.addChild(highscoreLabel)
        
        countdownLabel.fontName = "New Amsterdam"
        countdownLabel.fontSize = 170
        countdownLabel.fontColor = SKColor.white
        countdownLabel.position = CGPoint(x: -270, y: 514)
        countdownLabel.zPosition = 2
        self.addChild(countdownLabel)
        
        gameOver = false
        
        let highScore = UserDefaults.standard
        
        if highScore.value(forKey: "highscore") != nil
        {
            highscore = highScore.value(forKey: "highscore") as! Int
        }
        //print(highscore)
        
        //clearHigh()
    }
    
    func clearHigh()
    {
        let highScore = UserDefaults.standard
        highScore.set(0, forKey: "highscore")
        highScore.synchronize()
        highscoreLabel.text = String(highscore)
    }
    
    func gameover()
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        gameOver = true
        timer.invalidate()
        playing = false
        deletePlayers()
        stopRotating()
        
        tapTo.position = CGPoint(x: 0, y: -25)
        tapTo.zPosition = 3
        tapTo.alpha = 0
        self.addChild(tapTo)
        
        playBackground.run(SKAction.fadeOut(withDuration: 0.5))
        countdownLabel.run(SKAction.fadeOut(withDuration: 0.5))
        
        scoreLabel.run(SKAction.move(to: CGPoint(x: 209.356, y: -15.873), duration: 0.5))
        scoreLabel.fontSize = 140
        highscoreLabel.run(SKAction.move(to: CGPoint(x: 209.356, y: -148.699), duration: 0.5))
        
        gameOverScores.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5))
        gameOverText.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.5))
        earth.run(SKAction.move(to: CGPoint(x: 0, y: -50), duration: 0.5))
        blinking()
        
        self.isUserInteractionEnabled = false
        delay.run(SKAction.moveBy(x: 0, y: 0.01, duration: 1.0), completion: touchEnabled)
       // reason.run(SKAction.moveBy(x: 0, y: 0.01, duration: 1), completion: reasonBlink)
        
        if score > highscore
        {
            highscore = score
            highscoreLabel.text = String(highscore)
            
            let highScore = UserDefaults.standard
            highScore.set(highscore, forKey: "highscore")
            highScore.synchronize()
            
            
        }
        
    }
    
    func touchEnabled()
    {
        self.isUserInteractionEnabled = true
    }
    
    func restartGame()
    {
        print("restarting game")
        gameOver = false
        self.removeChildren(in: [tapTo as SKNode])
        
        deletePlayers()
        
        score = 0
        scoreLabel.text = String(score)
        countdown = 10
        countdownLabel.text = String(countdown)
        
        playBackground.run(SKAction.fadeIn(withDuration: 0.5))
        countdownLabel.run(SKAction.fadeIn(withDuration: 0.5))
        
        scoreLabel.run(SKAction.move(to: CGPoint(x: 270, y: 514), duration: 0.5))
        scoreLabel.fontSize = 170
        highscoreLabel.run(SKAction.move(to: CGPoint(x: 450, y: -148.699), duration: 0.5))
        
        gameOverScores.run(SKAction.move(to: CGPoint(x: -800, y: 0), duration: 0.5))
        gameOverText.run(SKAction.move(to: CGPoint(x: 0, y: 850), duration: 0.5))
        earth.run(SKAction.move(to: CGPoint(x: 0, y: -400), duration: 0.5))
        
        
        spawnPlayer()
        
        
    }
    
    func delaySpawn()
    {
        
        delay.run(SKAction.fadeOut(withDuration: 0.0575), completion: spawnPlayer)
        
    }
    
    func blinking()
    {
        tapTo.run(SKAction.fadeIn(withDuration: 1), completion: blink)
        
    }
    func blink()
    {
        tapTo.run(SKAction.fadeOut(withDuration: 1), completion: blinking)
    }
    
    func goHome()
    {
        
        let homeScene = HomeScene(fileNamed: "HomeScene")
        homeScene?.scaleMode = .aspectFill
        self.view?.presentScene(homeScene!, transition: SKTransition.fade(withDuration: 0.1))
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        print("we have contact")
        canTouch = false
        self.removeChildren(in: [redPlayer as SKNode])
        self.removeChildren(in: [yellowPlayer as SKNode])
        self.removeChildren(in: [greenPlayer as SKNode])
        self.removeChildren(in: [bluePlayer as SKNode])
        
        stopRotating()
        spawnPlayer()
    }
    
    
    
    func spawnPlayer()
    {
        
        if !gameOver
        {
            delay.run(SKAction.fadeIn(withDuration: 0.01))
            canTouch = false;
            scoreLabel.text = "\(score)"
        
            print("spawing player")
        
        
            let playerNum = Int .random(in: 1...4)
        
            if playerNum == 1
            {
                starNum = 1
                bluePlayer.size = CGSize(width: 275, height: 275)
                //bluePlayer.position = CGPoint(x: 0, y: 0)
                bluePlayer.position = CGPoint(x: Int .random(in: -150...150), y: Int .random(in: -450...450))
                bluePlayer.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(7), duration: 1)))
                //bluePlayer.physicsBody = SKPhysicsBody(circleOfRadius: 225)
                //bluePlayer.physicsBody?.collisionBitMask = 1
                bluePlayer.physicsBody?.affectedByGravity = false
            
                self.addChild(bluePlayer)
                self.view?.isUserInteractionEnabled = true
            
            }
        
            if playerNum == 2
            {
                starNum = 2
                redPlayer.size = CGSize(width: 275, height: 275)
                //redPlayer.position = CGPoint(x: 0, y: 0)
                redPlayer.position = CGPoint(x: Int .random(in: -150...150), y: Int .random(in: -450...450))
                redPlayer.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(7), duration: 1)))
                //redPlayer.physicsBody = SKPhysicsBody(circleOfRadius: 225)
                redPlayer.physicsBody?.collisionBitMask = 1
                redPlayer.physicsBody?.affectedByGravity = false
            
            
                self.addChild(redPlayer)
                self.view?.isUserInteractionEnabled = true
            }
        
            if playerNum == 3
            {
                starNum = 3
                greenPlayer.size = CGSize(width: 275, height: 275)
                //greenPlayer.position = CGPoint(x: 0, y: 0)
                greenPlayer.position = CGPoint(x: Int .random(in: -150...150), y: Int .random(in: -450...450))
                greenPlayer.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(7), duration: 1)))
                //greenPlayer.physicsBody = SKPhysicsBody(circleOfRadius: 225)
                greenPlayer.physicsBody?.collisionBitMask = 1
                greenPlayer.physicsBody?.affectedByGravity = false
            
                self.addChild(greenPlayer)
                self.view?.isUserInteractionEnabled = true
            }
        
            if playerNum == 4
            {
                starNum = 4
                yellowPlayer.size = CGSize(width: 275, height: 275)
                //yellowPlayer.position = CGPoint(x: 0, y: 0)
                yellowPlayer.position = CGPoint(x: Int .random(in: -150...150), y: Int .random(in: -450...450))
                yellowPlayer.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(7), duration: 1)))
                //yellowPlayer.physicsBody = SKPhysicsBody(circleOfRadius: 225)
                yellowPlayer.physicsBody?.collisionBitMask = 1
                yellowPlayer.physicsBody?.affectedByGravity = false
        
                self.addChild(yellowPlayer)
                self.view?.isUserInteractionEnabled = true
            }
        
        }
    }
    
    func deletePlayers()
    {
        self.removeChildren(in: [bluePlayer as SKNode])
        self.removeChildren(in: [redPlayer as SKNode])
        self.removeChildren(in: [greenPlayer as SKNode])
        self.removeChildren(in: [yellowPlayer as SKNode])
    }
    
    
    func blue()
    {
       
        score += 1
        plus10 = true
        self.removeChildren(in: [bluePlayer as SKNode])
        canTouch = false
        //print("point")
        stopRotating()
        delaySpawn()
        //spawnPlayer()
    }
    
    func red()
    {
       
        score += 1
        plus10 = true
        self.removeChildren(in: [redPlayer as SKNode])
        canTouch = false
       // print("point")
        stopRotating()
        delaySpawn()
        //spawnPlayer()
    }
    func green()
    {
       
        score += 1
        plus10 = true
        self.removeChildren(in: [greenPlayer as SKNode])
        canTouch = false
        //print("point")
        stopRotating()
        delaySpawn()
        //spawnPlayer()
    }
    func yellow()
    {
       
        score += 1
        plus10 = true
        self.removeChildren(in: [yellowPlayer as SKNode])
        canTouch = false
        //print("point")
        stopRotating()
        delaySpawn()
        //spawnPlayer()
    }
    
    func stopRotating()
    {
        redPlayer.removeAllActions()
        bluePlayer.removeAllActions()
        greenPlayer.removeAllActions()
        yellowPlayer.removeAllActions()
    }
    
    @objc func updateTimer()
    {
        if countdown > 0
        {
            countdown -= 1
            countdownLabel.text = String(countdown)
        }
        
    }
    
    
    
    func startTimer()
    {
        if (!playing)
        {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        playing = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for _ in touches
        {
            
            if gameOver
            {
                restartGame()
            }
            else if !gameOver
            {
                canTouch = true
                startTimer()
            }
            
            
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        
        if canTouch == true
        {
        
            for touch in touches
            {
                if starNum == 2
                {
                    touchLocation2 = touch.location(in: self)
            
                if redPlayer.contains(touchLocation2)
                {
                dragging = true
                }
                if dragging == true
                {
                redPlayer.position.x = touchLocation2.x
                redPlayer.position.y = touchLocation2.y
                }
                if starNum == 2 && redPlayer.position.y < -580
                {
                    red()
                }
                if starNum == 2 && redPlayer.position.y > 610 || redPlayer.position.x > 335 || redPlayer.position.x < -255
                {
                    wrongColor = true
                    gameover()
                    canTouch = false
                    print("2 gameover")
                }
                }
               
                
                
                if starNum == 1
                {
                    touchLocation1 = touch.location(in: self)
                
                if bluePlayer.contains(touchLocation1)
                {
                    dragging = true
                }
                if dragging
                {
                    bluePlayer.position.x = touchLocation1.x
                    bluePlayer.position.y = touchLocation1.y
                }
                if starNum == 1 && bluePlayer.position.y > 585
                {
                    blue()
                }
                if starNum == 1 && bluePlayer.position.y < -600 || bluePlayer.position.x > 335 || bluePlayer.position.x < -255
                {
                    wrongColor = true
                    gameover()
                    canTouch = false
                    print("1 gameover")
                }
                }
                
                if starNum == 3
                {
                    touchLocation3 = touch.location(in: self)
                
                
                if greenPlayer.contains(touchLocation3)
                {
                    dragging = true
                }
                if dragging == true
                {
                    greenPlayer.position.x = touchLocation3.x
                    greenPlayer.position.y = touchLocation3.y
                }
                if starNum == 3 && greenPlayer.position.x > 285
                {
                    green()
                }
                if starNum == 3 && greenPlayer.position.x < -255 || greenPlayer.position.y > 610 || greenPlayer.position.y < -600
                {
                    print("3 gameover")
                    canTouch = false
                    wrongColor = true
                    gameover()
                } 
                
                }
                
                if starNum == 4
                {
                    touchLocation4 = touch.location(in: self)
                
                if yellowPlayer.contains(touchLocation4)
                {
                    dragging = true
                }
                if dragging == true
                {
                    yellowPlayer.position.x = touchLocation4.x
                    yellowPlayer.position.y = touchLocation4.y
                }
                if starNum == 4 && yellowPlayer.position.x < -285
                {
                    yellow()
                }
                if starNum == 4 && yellowPlayer.position.x > 335 || yellowPlayer.position.y > 610 || yellowPlayer.position.y < -600
                {
                    print("4 gameover")
                    canTouch = false
                    wrongColor = true
                    gameover()
                }
                }
                
            }
        
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches
        {
            //print("touch ended")
            
            dragging = false
            
        
        }
    }

    
    override func update(_ currentTime: TimeInterval)
    {
        
        if !gameOver && score >= 10
        {
            if score % 10 == 0 && countdown != 0 && plus10
            {
                countdown = 10
                countdownLabel.text = String(countdown)
                plus10 = false
            }
        }
        
        if !gameOver && countdown == 0
        {
            wrongColor = false
            gameover()
        
        }
        
    }
}
