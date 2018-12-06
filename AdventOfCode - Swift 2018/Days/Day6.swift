//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day6Part1() {
    let hazzards = day6Input.lines.map(parse(string:))
    let minX = hazzards.map { $0.x }.min()!
    let minY = hazzards.map { $0.y }.min()!
    let maxX = hazzards.map { $0.x }.max()!
    let maxY = hazzards.map { $0.y }.max()!

    var hazzardToSpacesNearest: [Point: [Point]] = [:]

    for space in (minX..<maxX).allPairs(with: (minY..<maxY)).map(Point.init(tuple:)) {
        var closestPoints: [Int:[Point]] = [:]
        for hazzard in hazzards {
            closestPoints[hazzard.manhattanDistanceTo(space), default: []] += [hazzard]
        }
        if let closestHazzard = singleClosestHazzards(to: space, from: hazzards) {
            hazzardToSpacesNearest[closestHazzard, default: []] += [space]
        }
    }

    let topEdge = (minX..<maxX).map { Point(x: $0, y: minY) }
    let botEdge = (minX..<maxX).map { Point(x: $0, y: maxY) }
    let leftEdge = (minY..<maxY).map { Point(x: minX, y: $0) }
    let rightEdge = (minY..<maxY).map { Point(x: maxX, y: $0) }
    let perimeter = topEdge + botEdge + leftEdge + rightEdge
    
    perimeter
        .compactMap { singleClosestHazzards(to: $0, from: hazzards) }
        .forEach { hazzardToSpacesNearest.removeValue(forKey: $0) }
    
    print(hazzardToSpacesNearest.map { $0.value.count }.max()!)
}

func singleClosestHazzards(to space:Point, from hazzards: [Point]) -> Point? {
    var distancesToPoints: [Int:[Point]] = [:]
    for hazzard in hazzards {
        distancesToPoints[hazzard.manhattanDistanceTo(space), default: []] += [hazzard]
    }
    let minimumDistance = distancesToPoints.keys.min()!
    let closest = distancesToPoints[minimumDistance]
    if closest?.count == 1 {
        return closest!.first!
    }
    return nil
}

func day6Part2() {
    let hazzards = day6Input.lines.map(parse(string:))
    let minX = hazzards.map { $0.x }.min()!
    let minY = hazzards.map { $0.y }.min()!
    let maxX = hazzards.map { $0.x }.max()!
    let maxY = hazzards.map { $0.y }.max()!
    
    let regionSpaces = (minX..<maxX)
        .allPairs(with: (minY..<maxY))
        .map(Point.init(tuple:))
        .count(where: { space in hazzards.map { $0.manhattanDistanceTo(space) }.sum() < 10000 })
    print(regionSpaces)
}

private func parse(string: String) -> Point {
    let parts = string.components(separatedBy: ", ")
    return Point(x: parts[0].intValue!, y: parts[1].intValue!)
}
