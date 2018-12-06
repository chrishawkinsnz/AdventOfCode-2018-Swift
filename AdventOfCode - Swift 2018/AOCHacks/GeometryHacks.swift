//
//  Geometry.swift
//  AdventOfCode - Swift 2018
//
//  Created by Chris Hawkins on 3/12/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

struct Point: Equatable, Hashable {
    var x: Int
    var y: Int
    
    func manhattanDistanceTo(_ other: Point) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
    
}

extension Point {
    init(wd: Int, ht: Int) {
        self.init(x: wd, y: ht)
    }
    
    var wd: Int {
        return x
    }
    
    var ht: Int {
        return y
    }
}

extension Point {
    init(tuple: (Int, Int)) {
        self.init(x: tuple.0, y: tuple.1)
    }
}

typealias Size = Point

struct Rect {
    var origin: Point
    var size: Size
    
    var occupiedPositions: [Point] {
        let positions = (origin.x..<origin.x + size.wd).allPairs(with: (origin.y..<origin.y + size.ht)).map { Point.init(x: $0.0, y: $0.1) }
        return positions
    }
}
