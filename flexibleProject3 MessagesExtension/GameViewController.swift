//
//  GameViewController.swift
//  flexibleProj
//
//  Created by Qintu Tao on 2019-02-27.
//  Copyright © 2019 Qintu Tao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {
    // variables
    static let viewControllerIdentifier = "MazeViewController"
    var currentPosition = [11,10]
    var scene = GameScene()
    
    weak var delegate :GameViewControllerDelegate?
    
    // timer
    var gameTimer = Timer()
    var gameTime = 0
    var timeFinished = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startsTimer()
        print("view Loaded")
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                self.scene = scene as! GameScene
                self.scene.moveDelegate = self
                //sending data to messageviewcontroller
            
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }
    
    @objc func action(){
        gameTime += 1
        print(String(gameTime))
        print("Counting gameTime")
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // function that stops the timer
    func stopsTimer() {
        self.gameTimer.invalidate()
        self.timeFinished = self.gameTime
        self.gameTime = 0
        print(self.timeFinished)
        self.gameTimer = Timer()
    }
    
    // function that starts the timer
    func startsTimer(){
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.action), userInfo: nil, repeats: true)
    }
    
    // function that clears the timer
    
}

//extracting current player position from GameScene
extension GameViewController: GameSceneDelegate{
    func moved(X: Int, Y: Int) {
        self.currentPosition = [X,Y]
        delegate?.getCurrentPlayerPosition(at: X, at: Y)
        
        // TODO: change the position according to the new coordinate system
        // the player cube is not moving locations any more; instead, the entire block moves.
            
        if X == 11 && Y == 11 {
            stopsTimer()
        }
    }
}

//protocol for MessageViewController to extract current player position
protocol GameViewControllerDelegate: class {
    func getCurrentPlayerPosition(at X:Int, at Y:Int)
}


