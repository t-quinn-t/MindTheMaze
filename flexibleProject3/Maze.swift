//
//  Maze.swift
//  flexibleProj
//
//  Created by Qintu Tao on 2019-02-28.
//  Copyright © 2019 Qintu Tao. All rights reserved.
//

import Foundation
import SpriteKit

/**
 The structures that define the board, the cube, and the walls.The board object represents the grid system, which is achieved by utilizing a 2D array. The Cube structure represents the individual square, which contains 4 walls and a  square sprite cube. The topWalls and the leftWalls are conventionally enabled from the initail, whereas the rightWall and the bottomWall are conventionally disabled from the initial. The bottomWalls of the  last row of the maze and the rightWalls of the  last column of the maze is enabled for the border. [depricated]
 */

struct Settings{
    static let transparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
}

struct Board {
    // the board (grid) object
    // initializing variables
    let columns: Int
    let rows: Int
    var array: Array<Cube?>
    
    //constructor
    init(columns:Int,rows:Int,interval:Int,size:Int) {
        self.columns = columns
        self.rows = rows
        array = Array(repeating: nil, count: rows * columns) // initializing an array filled with Cubes
        self.renderBoard(interval: interval,size:size)
    }
    
    //subscription
    subscript(column: Int,row: Int) -> Cube? {
        get{
            return array[row * columns + column]
        }
        set{
            array[row * columns + column] = newValue
        }
    }
    
    // function that positions each spriteNode
    mutating func renderBoard(interval:Int,size:Int) {
        self.createSpriteNodes(size)
        //TODO: dynamic anchir points
        let leftAnchorPoint = -((self.columns - 1) * interval / 2)
        let topAnchorPoint = (self.rows - 1) * interval / 2
        for row in 0..<rows {
            for col in 0..<columns {
                //TODO: CHANGE ANCHORPOINT
                self[row,col]!.cube.position = CGPoint(x: leftAnchorPoint + col * interval , y: topAnchorPoint - row * interval)
                //add the postions of corresponding walls ( left and top )
                self[row,col]!.leftwall.position = CGPoint(x: leftAnchorPoint + col * interval - interval / 2, y: topAnchorPoint - row * interval)
                self[row,col]!.topWall.position = CGPoint(x: leftAnchorPoint + col * interval, y: topAnchorPoint - row * interval + interval / 2)
                //check if bottom and right walls are necessary
                if row == self.rows - 1 {
                    self[row,col]!.bottomWall.position = CGPoint(x: leftAnchorPoint + col * interval, y: topAnchorPoint - row * interval - interval / 2)
                    self[row,col]!.changeWallStateTo(.bottom, .enabled)
                }
                if col == self.columns - 1 {
                    self[row,col]!.rightWall.position = CGPoint(x: leftAnchorPoint + col * interval + interval / 2, y: topAnchorPoint - row * interval)
                    self[row,col]!.changeWallStateTo(.right, .enabled)
                }
                
            }
        }
    }
    
    //create spriteNodes; however, the wallNodes are rendered directly in the Wall Class
    mutating func createSpriteNodes(_ size:Int) {
        for square in 0..<self.array.count{
            let cube = SKSpriteNode()
            cube.color = Settings.transparent
            cube.size = CGSize(width: size, height: size)
            cube.name = "cube\(square + 1)"
            let sqr = Cube(cube: cube)
            print(sqr.currentCubeState)
            self.array[square] = sqr
        }
    }
}

// A cube that stores a squareNode and 3 wallNodes
struct Cube{
    var cube: SKSpriteNode
    var currentCubeState: cubeState
    
    // only the left and the top walls are needed, otherwise the walls will be overlapping with each other
    var leftwall: SKSpriteNode
    var topWall: SKSpriteNode
    var rightWall: SKSpriteNode
    var bottomWall: SKSpriteNode
    
    //initialize the walls
    var verticalWall: SKSpriteNode = SKSpriteNode(color: .white, size: CGSize(width: 3, height: 23))
    var horizontalWall: SKSpriteNode = SKSpriteNode(color: .white, size: CGSize(width: 23, height: 3))
    //the right and bottom walls are default to disabled to avoid duplication
    
    //MARK: THE WIDTH OR HEIGHT FOR RIGHT OR BOTTOM WALL SHOULD BE WIDTH PLUS HEIGHT
    var rightBorderWall: SKSpriteNode = SKSpriteNode(color: Settings.transparent, size: CGSize(width: 3, height: 23))
    var bottomBorderWall: SKSpriteNode = SKSpriteNode(color: Settings.transparent, size: CGSize(width: 23, height: 3))
    //TODO: MOVE THE INITALIZATION OF THE SAMPLE NODES TO INITIALITOR
    
    //configuring the vertical walls and horizontal walls
    init(cube: SKSpriteNode) {
        self.cube = cube
        self.currentCubeState = .blocked
        // initialized with the color of white, representing enabled state
        // MARK: COULD POTENTIALLY BE ADDED WITH MORE STATES, DEPENDING ON THE GAME'S DESSIGN
        self.verticalWall.name = "verticalWall"
        self.horizontalWall.name = "horizontalWall"
        // the names will be overritten afterwards
        
        //initalized with walls
        self.leftwall = self.verticalWall
        self.topWall = self.horizontalWall
        self.rightWall =  self.rightBorderWall
        self.bottomWall = self.bottomBorderWall
    }
    
    //fucntions that checks a wall's state
    func checkWallState(direction: wallDirection) -> wallState {
        switch direction {
        case .left:
            return checkState(self.leftwall)
        case .top:
            return checkState(self.topWall)
        case .right:
            return checkState(self.rightWall)
        default:
            return checkState(self.bottomWall)
        }
    }
    // check a node's availability by checking their colours
    func checkState(_ wall:SKSpriteNode) -> wallState {
        if wall.color == .white{
            return .disabled
        }else{
            return .enabled
        }
    }
    
    // function that changes a single wall's state
    mutating func changeWallStateTo(_ direction: wallDirection,_  toState:wallState){
        //the switch is used to check the state and toggles the state
        switch toState {
            
        case .disabled: // this disables the wall
            switch direction {
            case .left:
                self.leftwall.color = .init(hue: 0, saturation: 0, brightness: 0, alpha: 0)
                break
            case .top:
                self.topWall.color = .init(hue: 0, saturation: 0, brightness: 0, alpha: 0)
                break
            case .right:
                self.rightWall.color = .init(hue: 0, saturation: 0, brightness: 0, alpha: 0)
                break
            default:
                self.bottomWall.color = .init(hue: 0, saturation: 0, brightness: 0, alpha: 0)
                break
            }
            break
            
        default: // this enables the wall
            switch direction{
            case .left:
                self.leftwall.color = .white
                break
            case .top:
                self.topWall.color = .white
                break
            case .right:
                self.rightWall.color = .white
                break
            default:
                self.bottomWall.color = .white
                break
            }
            break
        }
    }
    // this mutates cube's colors
    mutating func changeCubeColor(){
        switch currentCubeState {
        case .blocked:
            self.cube.color = .white
            self.currentCubeState = .free // change-1
            break
        default:
            self.cube.color = Settings.transparent
            self.currentCubeState = .blocked //change-1
            break
        }
    }
}

// MARKS: ZOOMED-IN VERSION OF THE BOARD:
struct LargeBoard{
    
}

// MARKS: ENUMERATIONS
// enumeration for wallState
enum wallState{
    case enabled
    case disabled
}
// enumeration for wallDirection
enum wallDirection{
    case left
    case top
    case right
    case bottom
}
//enumeration for cubeState
enum cubeState{
    case free
    case blocked
}
//locked the board for developer purpose, unlocked the board for gaming purpose
enum boardMutable{
    case locked
    case unlockedd
}
//the enumerator used to determine which type of message is sent in the conversation
enum messageType{
    case maze
    case request
}
