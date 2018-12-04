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

typealias Size = Point

struct Rect {
    var origin: Point
    var size: Size
    
    var occupiedPositions: [Point] {
        let positions = (origin.x..<origin.x + size.wd).allPairs(with: (origin.y..<origin.y + size.ht)).map { Point.init(x: $0.0, y: $0.1) }
        return positions
    }
}
