//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day10Part1() {
    var observations = day10Input.lines.map(parse(line: ))
    var lastObservations: [Observation] = observations
    var lastSize: Int = 99999999999
    while true {
        observations = observations.map { $0.ticked() }
        let bounds = Bounds(wrapping: observations.map { $0.pos})
        let area = bounds.area
        
        if (area > lastSize) {
            print(displayState(lastObservations))
            return
        }
        
        lastSize = area
        lastObservations = observations
    }
}

func day10Part2() {
    var observations = day10Input.lines.map(parse(line: ))
    var lastSize: Int = 99999999999
    var index = 0
    while true {
        observations = observations.map { $0.ticked() }
        let bounds = Bounds(wrapping: observations.map { $0.pos})
        let area = bounds.area
        
        if (area > lastSize) {
            print(index)
            return
        }
        
        lastSize = area
        index += 1
    }
}

struct Bounds {
    var minX: Int
    var maxX: Int
    var minY: Int
    var maxY: Int
    
    init(wrapping points: [Point]) {
        minX = points.map { $0.x }.min()!
        maxX = points.map { $0.x }.max()!
        minY = points.map { $0.y }.min()!
        maxY = points.map { $0.y }.max()!
    }
    
    var xRange: ClosedRange<Int> {
        return minX...maxX
    }
    
    var yRange: ClosedRange<Int> {
        return minY...maxY
    }
    
    var allPoints: [Point] {
        return xRange.allPairs(with: yRange).map { Point(tuple:$0) }
    }
    
    var area: Int {
        return width * height
    }
    
    var width: Int {
        return maxX - minX
    }
    
    var height: Int {
        return maxY - minY
    }
}

private func displayState(_ observations: [Observation]) -> String {
    let bounds = Bounds(wrapping: observations.map { $0.pos })

    let occupations: Set<Point> = Set<Point>(observations.map { $0.pos})
    
    var str = ""
    for y in bounds.yRange {
        for x in bounds.xRange {
            str += occupations.contains(Point(x:x, y:y)) ? "#" : "."
        }
        str += "\n"
    }
    return str
}

private func parse(line: String) -> Observation {
    let ints = line.extractInts(pattern: "position=<[ ]?INT, [ ]?INT> velocity=<[ ]?INT, [ ]?INT>")
    return Observation(pos: Point(wd: ints[0], ht: ints[1]), vel: Point(wd: ints[2], ht: ints[3]))
}

private struct Observation {
    var pos: Point
    var vel: Vector
    
    mutating func tick() {
        pos += vel
    }
    
    func ticked() -> Observation {
        var copy = self
        copy.tick()
        return copy
    }
}
