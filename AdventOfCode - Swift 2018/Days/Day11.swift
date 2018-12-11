//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day11Part1() {
    let grid = createScoreGrid(size: 300)
    let winner = highestPower(within: grid, withSideLength: 3)
    print("\(winner.position.x),\(winner.position.y)")
}

func day11Part2() {
    let grid = createScoreGrid(size: 300)
    let winner = (1...300)
        .map { highestPower(within: grid, withSideLength: $0) }
        .max(by: { $0.power < $1.power} )!
    print("\(winner.position.x),\(winner.position.y),\(winner.sideLength)")
}

struct Score {
    var power: Int
    var position: Point
    var sideLength: Int
}


func createScoreGrid(size: Int) -> [[Int]] {
    var rows: [[Int]] = []
    for y in (0...300) {
        var row: [Int] = []
        for x in (0...300) {
            row += [score(for: Point(wd: x, ht: y))]
        }
        rows += [row]
    }
    return rows
}

func highestPower(within scores: [[Int]], withSideLength sideLength: Int) -> Score {
    let investigationPoints = (0...300-sideLength).allPairs(with: 0...300-sideLength).map(Point.init(tuple:))
    let t0 = Date()
    let result = investigationPoints.map { point -> Score in
            let sum = (0..<sideLength).allPairs(with: (0..<sideLength))
                .map { scores[point.y + $0.0][point.x + $0.1] }
                .sum()
            return Score(power: sum, position: point, sideLength: sideLength)
        }
        .max(by: { $0.power < $1.power })!
    let t1 = Date()
    print(t1.timeIntervalSince(t0))
    return result
}

//Find the fuel cell's rack ID, which is its X coordinate plus 10.
//Begin with a power level of the rack ID times the Y coordinate.
//Increase the power level by the value of the grid serial number (your puzzle input).
//Set the power level to itself multiplied by the rack ID.
//Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
//Subtract 5 from the power level.

private let serialNumber: Int = 9798
func score(for point: Point) -> Int {
    let rackId = point.x + 10
    var powerLevel = rackId * point.y
    powerLevel += serialNumber
    powerLevel *= rackId
    if powerLevel < 100 {
        powerLevel = 0
    }
    else {
        powerLevel = (powerLevel / 100) % 10
    }
    powerLevel -= 5
    return powerLevel
}





