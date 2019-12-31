//
//  GameScene.swift
//  flexibleProj
//
//  Created by Qintu Tao on 2019-02-27.
//  Copyright © 2019 Qintu Tao. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
// BUG: Message Sending and presentational style transitioning currently not following any logic, please fix it
// BUG: Destination Point not coloured, please finish it
// BUG: Wall's colours and Path's colours are reversed, please reverse that

// TODO: Timer and Menu View to be completed.


class GameScene: SKScene {
    // the data entered here must correspond with the for loops in the didMove function
    // TODO: change the initializer according to the new board class
    var board = Board(columns: 21, rows: 21, interval: 20, size: 20)
    var boardSwitch: boardMutable = .locked
    var playerLocation = [0,5]
    weak var moveDelegate: GameSceneDelegate?
    
    
    override func didMove(to view: SKView) {
        let playerCord = (board[playerLocation[0],playerLocation[1]]?.cube.position)!
        //zoom-in function
        let cameraNode = SKCameraNode()
        cameraNode.position = playerCord

        scene?.addChild(cameraNode)
        scene?.camera = cameraNode

        let zoomInAction = SKAction.scale(to: 0.2, duration: 0.4)
        cameraNode.run(zoomInAction)
        
        //TODO: change the loop run time according to new system, ideally it would be five
        for x in 0 ..< 21{
            for y in 0 ..< 21{
                guard let sprite = board[x,y] else{
                    return
                }
                self.addChild(sprite.cube)
                self.addChild(sprite.leftwall)
                self.addChild(sprite.topWall)
                self.addChild(sprite.rightWall)
                self.addChild(sprite.bottomWall)
            }
        }
        // TODO: change user position accordingly
        board[2,1]?.cube.color = .red
        
        hardCodeTheEntireThing()
        showPlayer(atX: 0, atY: 5)
        // TODO: change the destination point accordingly
        board[11,11]?.cube.color = .yellow
        
        // The Movement Buttons in zoomed-in mode, the buttons will be moving together with the camera node.
        let leftButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow"), size:CGSize(width: 50, height: 50))
        leftButton.alpha = 0.5
        leftButton.position = CGPoint(x: playerCord.x - 50, y: playerCord.y + 0)
        leftButton.zRotation = CGFloat(Double.pi * 0.5)
        leftButton.name = "leftButton"
        scene?.addChild(leftButton)
        
        let upButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow"), size:CGSize(width: 50, height: 50))
        upButton.alpha = 0.5
        upButton.position = CGPoint(x: playerCord.x - 0, y: playerCord.y + 50)
        upButton.name = "upButton"
        scene?.addChild(upButton)
        
        let rightButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow"), size:CGSize(width: 50, height: 50))
        rightButton.alpha = 0.5
        rightButton.position = CGPoint(x: playerCord.x + 50, y: playerCord.y - 0)
        rightButton.zRotation = CGFloat(Double.pi * 1.5)
        rightButton.name = "rightButton"
        scene?.addChild(rightButton)
        
        let downButton = SKSpriteNode(texture: SKTexture(imageNamed: "Arrow"), size:CGSize(width: 50, height: 50))
        downButton.alpha = 0.5
        downButton.position = CGPoint(x: playerCord.x + 0, y: playerCord.y - 50)
        downButton.zRotation = CGFloat(Double.pi)
        downButton.name = "downButton"
        scene?.addChild(downButton)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let posX = playerLocation[0]
        let posY = playerLocation[1]
        
        // add control button function by Ali
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            if node?.name == "LeftButton" || node?.name == "leftButton" {
                move(to: .left, fromX:posX, fromY:posY)
            }
            else if node?.name == "UpButton" || node?.name == "upButton" {
                move(to: .top, fromX:posX, fromY:posY)
            }
            else if node?.name == "RightButton" || node?.name == "rightButton" {
                move(to: .right, fromX:posX, fromY:posY)
            }
            else if node?.name == "DownButton" || node?.name == "downButton" {
                print("hello")
                move(to: .bottom, fromX:posX, fromY:posY)
                print("hello world")
            }
            
            else {
                return
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // turn cubes into white
        switch boardSwitch {
        case .locked:
            
            break
        default:
            // TODO: verify if the previous version of board locating system still works
            let posX = (Int(touches.first!.location(in: self).x) + 220) / 21
            let posY = (Int(touches.first!.location(in: self).y) + 220) / 21
            if(posX >= 0 && posY >= 0 && posX < 21 && posY < 21){
                board[20 - posY,posX]?.changeCubeColor()
            }
            break
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // called before each frame is rendered
        
    }
    
    // function that initalizes the board
    func hardCodeTheEntireThing(){
        // for presentation purpose, the code is hardcoded here; however, when it comes to later development, it should be changed into a dynamic function that suits any preset-mazes, or even user defined mazes
        // TODO: may have to redo the hardcoded stuff; otherwise, implement the coordinate system in other ways.
        let hardCodeCode = [
            [5],
            [1,2,3,5,6,7,9,11,12,13,15,16,17,19],
            [1,3,7,9,13,17,19],
            [1,3,4,5,7,9,10,11,13,14,15,17,19],
            [1,7,11,15,17,19],
            [1,3,4,5,6,7,8,9,11,12,13,15,17,19],
            [1,3,9,15,17],
            [1,2,3,5,6,7,9,10,11,12,13,14,15,17,18,19],
            [1,3,5,13,19],
            [1,3,5,7,8,9,10,11,13,14,15,16,17,19],
            [1,5,7,11,13,15],
            [1,2,3,4,5,7,9,11,13,15,17,18,19],
            [1,5,7,9,13,15,19],
            [1,3,5,7,9,11,12,13,15,16,17,19],
            [1,3,5,7,9,11,17,19],
            [1,3,5,6,7,9,10,11,12,13,15,16,17,19],
            [1,3,7,11,13,19],
            [1,3,4,5,7,8,9,10,11,13,15,16,17,18,19],
            [1,5,13,19],
            [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19],
            []
        ]
        // compose the board in zoomed-out state
        for x in 0 ..< 21 {
            for y in hardCodeCode[x]{
                board[x,y]!.changeCubeColor()
                board[x,y]!.currentCubeState = .free
            }
        }
    }
    // the function that moves the view port together witht the player
    private func moveViewPort(to direction:wallDirection, from currentX: Int, from currentY: Int){
        // turn the camera node first
        self.camera?.position = (board[currentX,currentY]?.cube.position)!
    }
    
    // the fucntion that moves the 4 controlling buttons
    private func moveButttons(_  currentX: Int,_ currentY: Int){
        // get the center of the canvas
        let currLoc = (board[currentX,currentY]?.cube.position)!
        for node in self.children {
            if node.name == "leftButton" {
                node.position = CGPoint(x: currLoc.x - 50,  y: currLoc.y)
            }else if node.name == "upButton"{
                node.position = CGPoint(x: currLoc.x ,y: currLoc.y + 50)
            }else if node.name == "rightButton"{
                node.position = CGPoint(x: currLoc.x + 50 ,y: currLoc.y)
            }else if node.name == "downButton"{
                node.position = CGPoint(x: currLoc.x ,y: currLoc.y - 50)
            }
            
        }
    }
    // the function that responds to user movement
    private func move(to direction:wallDirection,fromX currentX: Int, fromY currentY: Int) {
        var collisionX = 0
        var collisionY = 0
        switch direction {
        case .left:
            collisionX = currentX
            collisionY = currentY - 1
            if !isGoingToCrashIntoWall(atX: collisionX, atY:collisionY){
                //then increment
                leavePlayer(atX: currentX, atY: currentY)
                showPlayer(atX: collisionX, atY: collisionY)
                playerLocation = [collisionX,collisionY]
                moveViewPort(to: .left, from: collisionX, from: collisionY)
                moveButttons(collisionX, collisionY)
            }
            
        case .top:
            collisionX = currentX - 1
            collisionY = currentY
            if !isGoingToCrashIntoWall(atX: collisionX, atY:collisionY){
                //then increment
                leavePlayer(atX: currentX, atY: currentY)
                showPlayer(atX: collisionX, atY: collisionY)
                playerLocation = [collisionX,collisionY]
                moveViewPort(to: .left, from: collisionX, from: collisionY)
                moveButttons(collisionX, collisionY)
            }
        case .right:
            collisionX = currentX
            collisionY = currentY + 1
            if !isGoingToCrashIntoWall(atX: collisionX, atY:collisionY){
                //then increment
                leavePlayer(atX: currentX, atY: currentY)
                showPlayer(atX: collisionX, atY: collisionY)
                playerLocation = [collisionX,collisionY]
                moveViewPort(to: .left, from: collisionX, from: collisionY)
                moveButttons(collisionX, collisionY)
            }
        case .bottom:
            collisionX = currentX + 1
            collisionY = currentY
            if !isGoingToCrashIntoWall(atX: collisionX, atY:collisionY){
                //then increment
                leavePlayer(atX: currentX, atY: currentY)
                showPlayer(atX: collisionX, atY: collisionY)
                playerLocation = [collisionX,collisionY]
                moveViewPort(to: .left, from: collisionX, from: collisionY)
                moveButttons(collisionX, collisionY)
            }
        default:
            fatalError("cannot move to pointed area")
        }
        moveDelegate?.moved(X: playerLocation[0], Y: playerLocation[1])
        
        if playerLocation[0] == 11 && playerLocation[1] == 11 {
            playerLocation = [0,5]
            showPlayer(atX: 0, atY: 5)
            leavePlayer(atX: 11, atY: 11)
            board[11,11]?.cube.color = .yellow
        }
    }
    
    // the function that checks if it is going to crash into the wall
    private func isGoingToCrashIntoWall(atX x:Int,atY y:Int) -> Bool {
        if board[x,y]!.currentCubeState == .blocked{
            return true
        }else{
            return false
        }
    }
    
    // the function that changes the color of the player cube
    func showPlayer(atX x:Int, atY y:Int) {
        board[x,y]!.cube.color = .red
    }
    //the function that clears the color of player cube
    func leavePlayer(atX x:Int, atY y:Int){
        board[x,y]!.cube.color = .white
    }
}

protocol GameSceneDelegate:class {
    func moved(X:Int,Y:Int)
}
