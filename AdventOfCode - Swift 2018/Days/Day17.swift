//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation


struct RunningWater: CustomDebugStringConvertible {
    var position: Point
    var direction: CardinalDirection
    
    var nextPosition: Point {
        return move(position, direction: direction)
    }
    
    var description: String {
        return "{Pouring \(direction) from \(position)}"
    }
    
    var debugDescription: String {
        return description
    }
}

func day17Part1() {
    var debugLog = false
    var walls = day17Input.lines.flatMap(parseBlob)
    
    var tiles: [Point: Tile] = [:]
    for wall in walls {
        tiles[wall.position] = wall
    }
    var bounds = Bounds(wrapping: walls.map { $0.position })
    
    func set(type: TileType, at position: Point) {
        let tile = Tile(type: type, position: position)
        tiles[position] = tile
    }
    
    func tile(at position: Point) -> Tile? {
        return tiles[position]
    }
    
    func log() {
        guard debugLog else { return }
        print(grid: tiles)
        print("-------------------------------------------------\n\n")
    }
    
    enum FillingMode {
        case goingDown
        case spreadingOut
    }
    
    tiles[.init(x: 500, y:0)] = Tile.init(type: .spring, position: .init(x: 500, y:0))
    var tips = [RunningWater(position: .init(x: 500, y:1), direction: .south)]
    log()
    outerloop: while var tip = tips.popLast() {
        // Pouring down
        if tip.direction == .south {
            if tile(at: tip.position.downOne)?.type == .runningWater {
                log()
                continue
            }
            // keep pouring downwards
            while !tile(at: tip.nextPosition).isSolid && tip.position.y <= bounds.maxY{
                set(type: .runningWater, at: tip.position)
                tip.position = tip.nextPosition
            }

            if (tip.position.y > bounds.maxY) {
                log()
                continue outerloop
            }
            
            set(type: .runningWater, at: tip.position)
            
            if tile(at: tip.nextPosition)?.type == .clay || tile(at: tip.nextPosition)?.type == .settledWater {
                // when you've hit something (be it more water or clay) creat (up to) two
                let expandingTips = [
                    RunningWater(position: tip.position.leftOne, direction: .west),
                    RunningWater(position: tip.position.rightOne, direction: .east),
                    ].filter { tile(at: $0.position) == nil}
                tips.insert(contentsOf: expandingTips, at: 0)
                // Add a filling tip at current position to check if filling up
                // TODO move filling tip somewhere else eg. on the top layer thing
                let fillingTip = RunningWater(position: tip.position.upOne, direction: .south)
                tips.insert(fillingTip, at: 0)
            }
        }
        // Filling out
        else {
            while !tile(at: tip.nextPosition).isSolid && tile(at: tip.position.downOne).isSolid {
                set(type: .runningWater, at: tip.position)
                tip.position = tip.nextPosition
            }
            set(type: .runningWater, at: tip.position)
            // fall down
            if !tile(at: tip.position.downOne).isSolid {
                tips.append(.init(position: tip.position, direction: .south))
            }
            // roll back
            else if tile(at: tip.nextPosition).isSolid {
                var accumulator: [Point] = []
                var scanPosition: Point = tip.position
                
                while true {
                    accumulator += [scanPosition]
                    scanPosition = move(scanPosition, direction: tip.direction.opposite)
                    if tile(at: scanPosition) == nil {
                        break
                    }
                    if tile(at: scanPosition).isSolid {
                        for position in accumulator {
                            if tile(at: position.upOne)?.type == .runningWater {
                                let fillingTip = RunningWater(position: position.upOne, direction: .south)
                                tips.insert(fillingTip, at: 0)
                            }
                            set(type: .settledWater, at: position)
                        }
                        break
                    }
                }
            }
        }
        log()
    }
    let validTilesForCounting = tiles
        .filter { $0.key.y >= bounds.minY }
        .filter { $0.key.y <= bounds.maxY }
        .map { $0.value }
    
    // minusing 4 as the spring is weirdly low
    let overallWaterCount = validTilesForCounting.count(where: { $0.type == .runningWater || $0.type == .settledWater })
    let settledCount = validTilesForCounting.count(where: { $0.type == .settledWater })
    print("part1: \(overallWaterCount)")
    print("part2: \(settledCount)")
}

func day76Part2() {
    
}

// 24639 + 5007
private enum TileType {
    case clay
    case settledWater
    case runningWater
    case spring
    
    var displayCharacter: String {
        switch self {
        case .clay: return "#"
        case .settledWater: return "~"
        case .runningWater: return "|"
        case .spring: return "+"
        }
    }
}

extension Optional where Wrapped == Tile {
    var isSolid: Bool {
        if self == nil { return false }
        return self!.type == .settledWater || self!.type == .clay
    }
}

private struct Tile: PointPrintable {
    var type: TileType
    var position: Point
    
    var displayCharacter: String {
        return type.displayCharacter
    }
}

private typealias Grid = [[Tile]]

private func parseBlob(_ string: String) -> [Tile] {
    let ints = string.extractInts(pattern: "[x|y]=INT, [x|y]=INT..INT")
    let constant = ints[0]
    var positions: [Point] = []
    for rangeValue in ints[1]...ints[2] {
        if string.starts(with: "y") {
            positions.append(.init(x: rangeValue, y: constant))
        }
        else {
            positions.append(.init(x: constant, y: rangeValue))
        }
    }
    return positions.map { Tile.init(type: .clay, position: $0)}
}

func print(grid: [[PointPrintable?]]) {
    let bounds = Bounds(wrapping: grid.flatMap { $0 }.compactMap { $0?.position })
    
    var string = ""
    for y in bounds.xRange {
        var line = ""
        for x in bounds.yRange {
            line += grid[point: Point(x: x, y: y)]?.displayCharacter ?? " "
        }
        line += "\n"
        string += line
    }
    print(string)
}

func print(grid: [Point: PointPrintable]) {
    let bounds = Bounds(wrapping: grid.map { $0.key })
    
    var string = ""
    for y in bounds.yRange {
        var line = ""
        for x in bounds.xRange {
            line += grid[Point(x: x, y: y)]?.displayCharacter ?? " "
        }
        line += "\n"
        string += line
    }
    print(string)
}
