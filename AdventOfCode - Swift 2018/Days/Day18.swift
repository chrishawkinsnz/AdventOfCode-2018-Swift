//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

fileprivate enum LumberTileType: String {
    case ground = "."
    case trees = "|"
    case lumberyard = "#"
}

fileprivate struct Tile: PointPrintable {
    
    fileprivate var position: Point
    fileprivate var tileType: LumberTileType
    
    var displayCharacter: String {
        return tileType.rawValue
    }
    
    init(position: Point, char: String) {
        self.position = position
        self.tileType = LumberTileType.init(rawValue: char)!
    }
}

func day18Part1() {
    let tiles = day18InputSimple.lines.enumerated().map { y, line in
        line.enumerated().map { x, char in
            return Tile.init(position: Point(x:x, y:y), char: String(char))
        }
    }
    print(grid: tiles)
}
