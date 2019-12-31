//
//  Settings.swift
//  flexibleProj
//
//  Created by Qintu Tao on 2019-03-18.
//  Copyright © 2019 Qintu Tao. All rights reserved.
//
 
import Foundation
struct Configuration {
    var presetMaps = [[Int]]()
    
    // Selecting a preset-maze
    init() {
        presetMaps = [
            [30,30,20,10],
            [20,20,20,10]
        ]
    }
    
    subscript(mazeNumber: Int) -> [Int]{
        get{
            return self.presetMaps[mazeNumber]
        }
        set{
            presetMaps[mazeNumber] = newValue
        }
    }
}
