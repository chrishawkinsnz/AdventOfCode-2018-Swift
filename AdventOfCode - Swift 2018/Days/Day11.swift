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
    print(highestPowerQuicker(within: grid, withSideLength: 0))
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

// Tidy
// Part 2 in ~2 hours
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

// Quicker
// Part 2 in ~2 minutes
func highestPowerQuick(within powers: [[Int]], withSideLength sideLength: Int) -> Score {
    let t0 = Date()
    var scores: [Score] = []
    let maxPos = 300 - sideLength
    for y in (0..<maxPos) {
        print(y)
        for x in (0..<maxPos) {
            let maxSideLength = min((maxPos - x),(maxPos - y))
            var sum: Int = 0
            for size in (1...maxSideLength) {
                for xd in 0..<size {
                    let yd = size - 1
                    sum += powers[y + yd][x + xd]
                }
                for yd in 0..<size - 1 {
                    let xd = size - 1
                    sum += powers[y + yd][x + xd]
                }
                scores += [Score.init(power: sum, position: Point(wd: x, ht: y), sideLength: size)]
            }
        }
    }
    let t1 = Date()
    print(t1.timeIntervalSince(t0))
    return scores.max(by: { $0.power < $1.power })!
}

// Quicker
// Part 2 in ~10 seconds
func highestPowerQuicker(within powers: [[Int]], withSideLength sideLength: Int) -> Score {
    let t0 = Date()
    // Build up summed area table
    // This is a table of all the areas as they extend to the top left of the "screen"
    var summedAreas: [[Int]] = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: 300), count: 300)
    
    for y in (0..<300) {
        var thisStripSum = 0
        for x in (0..<300) {
            let thisTileValue = powers[y][x]
            thisStripSum += thisTileValue
            let thisTileSum = thisStripSum + (summedAreas[safe: y - 1]?[x]  ?? 0)
            summedAreas[y][x] = thisTileSum
        }
    }
    print("Calculated summed areas")
    func area(for position: Point, sideLength: Int) -> Int {
        let x = position.x + 1
        let y = position.y + 1
        let delta = sideLength
        let topLeft = summedAreas[y][x]
        let botLeft = summedAreas[y + delta][x]
        let topRight = summedAreas[y][x + delta]
        let botRight = summedAreas[y + delta][x + delta]
        return botRight - botLeft - topRight + topLeft
    }
    
    var scores: [Score] = []
    let maxPos = 300
    for y in (0..<maxPos) {
        print("Calculating areas at row: \(y)")
        for x in (0..<maxPos) {
            let maxSideLength = (min((maxPos - x),(maxPos - y)) - 1).clamped(1, 299)
            for size in (1..<maxSideLength) {
                let point = Point(x: x, y: y)
                let areaValue = area(for: point, sideLength: size)
                scores += [Score(power: areaValue, position: point, sideLength: size)]
            }
        }
    }
    
    let t1 = Date()
    print(t1.timeIntervalSince(t0))
    return scores.max(by: { $0.power < $1.power })!
}

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





