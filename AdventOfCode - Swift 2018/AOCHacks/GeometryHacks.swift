//
//  Geometry.swift
//  AdventOfCode - Swift 2018
//
//  Created by Chris Hawkins on 3/12/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

struct Point: Equatable, Comparable, Hashable, CustomDebugStringConvertible {
    static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y < rhs.y { return true }
        if lhs.y > rhs.y { return false }
        if lhs.x < rhs.x { return true }
        if lhs.x > rhs.y { return false }
        return false 
    }
    
    var x: Int
    var y: Int
    
    func manhattanDistanceTo(_ other: Point) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
    
    public var debugDescription: String {
        return "<\(x),\(y)>"
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
typealias Vector = Point

struct Rect {
    var origin: Point
    var size: Size
    
    var occupiedPositions: [Point] {
        let positions = (origin.x..<origin.x + size.wd).allPairs(with: (origin.y..<origin.y + size.ht)).map { Point.init(x: $0.0, y: $0.1) }
        return positions
    }
}

func +(lhs: Point, rhs: Vector) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func +=(lhs: inout Point, rhs: Vector) {
    lhs = Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

enum LocalDirection {
    case forward
    case left
    case backward
    case right
}

enum CardinalDirection:Int {
    case east = 0, north, west, south
    
    var nextCounterClockwise: CardinalDirection {
        return CardinalDirection.init(rawValue: (self.rawValue + 1) % 4)!
    }
    
    var relevantAxis: WritableKeyPath<Point, Int> {
        switch self {
        case .east, .west: return \.x
        case .north, .south: return \.y
        }
    }
    
    var modifier: (Int, Int) -> Int {
        switch self {
        case .east, .south: return { $0 + $1 };
        case .west, .north: return { $0 - $1 };
        }
    }
    
    static var allDirections: [CardinalDirection] {
        return [.east, .north, .west, .south]
    }
    
    func turned(_ localDirection: LocalDirection) -> CardinalDirection {
        switch localDirection {
        case .forward: return self
        case .left: return toTheLeft
        case .right: return toTheRight
        case .backward: return opposite
        }
    }
    
    var opposite: CardinalDirection {
        return CardinalDirection(rawValue: (rawValue + 2).modulo(4))!
    }
    
    var toTheLeft: CardinalDirection {
        return CardinalDirection(rawValue: (rawValue + 1).modulo(4))!
    }
    
    var toTheRight: CardinalDirection {
        return CardinalDirection(rawValue: (rawValue - 1).modulo(4))!
    }
}

func move(_ point: Point, direction: CardinalDirection) -> Point {
    
    return move(point, modifying: direction.relevantAxis, modifer: direction.modifier)
}

fileprivate func move(_ point: Point, modifying keyPath: WritableKeyPath<Point, Int>, modifer: (Int, Int) -> Int ) -> Point {
    var point = point
    point[keyPath: keyPath] = modifer(point[keyPath: keyPath], 1)
    return point
}

extension Point {
    func steppingOnce(_ towards: CardinalDirection) -> Point {
        return move(self, direction: towards)
    }
}

extension MutableCollection where Element: MutableCollection, Element.Index == Int, Index == Int {
    subscript(point: Point) -> Element.Element {
        get {
            return self[point.y][point.x]
        }
        set {
            self[point.y][point.x] = newValue
        }
    }
}

extension Array where Element: MutableCollection, Element.Index == Int {
    subscript(point point: Point) -> Element.Element {
        get {
            return self[point.y][point.x]
        }
        set {
            self[point.y][point.x] = newValue
        }
    }

}

extension Collection where Element: Collection {
    func withPoints() -> [(point: Point, Element.Element)] {
        var accumulator: [(point: Point, Element.Element)] = []
        for (y, row) in self.enumerated() {
            for (x, element) in row.enumerated() {
                accumulator.append((point: Point(x: x, y: y), element))
            }
        }
        return accumulator
    }
}


extension Point {
    var upOne: Point { return Point(x: x, y: y - 1)}
    var downOne: Point { return Point(x: x, y: y + 1)}
    var leftOne: Point { return Point(x: x - 1, y: y )}
    var rightOne: Point { return Point(x: x + 1, y: y )}
    
    var cardinallyAdjacentPoints: [Point] {
        return [upOne, downOne, leftOne, rightOne]
    }
}


