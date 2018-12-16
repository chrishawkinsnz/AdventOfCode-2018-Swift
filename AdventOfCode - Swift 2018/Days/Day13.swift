//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

fileprivate typealias Grid = [[Track?]]

func day13Part1() {
    let input = day13Input

    let grid: Grid = input.lines.map { $0.map { Track(rawValue: String($0)) }}
    var trains = parseTrains(from: input)

    while true {
        trains = trains.sorted(by: \.position.y, then: \.position.x)
        for (index, train) in trains.enumerated() {
            trains[index] = train.moved(in: grid)
            if let crashSite = crashSite(in: grid, with: trains) {
                print(crashSite)
                return
            }
        }
    }
}

func day13Part2() {
    let input = day13Input
    
    let grid: Grid = input.lines.map { $0.map { Track(rawValue: String($0)) }}
    var trains = parseTrains(from: input)
    
    while true {
        trains = trains.sorted(by: \.position.y, then: \.position.x)
        var trainsMarkedForDeath: [Train] = []
        for (index, train) in trains.enumerated() {
            guard !trainsMarkedForDeath.contains(train) else { continue }
            trains[index] = train.moved(in: grid)
            if let crashSite = crashSite(in: grid, with: trains) {
                trainsMarkedForDeath += trains.filter { $0.position == crashSite }
                print("reamaining: \(trains.count)")
            }
        }
        trains = trains.filter { !trainsMarkedForDeath.contains($0) }
        if trains.count == 1 {
            print(trains.first!.position)
            return
        }
    }
}

fileprivate func parseTrains(from input: String) -> [Train] {
    let lines = input.lines
    let width = lines[0].count
    let height = lines.count
    var trains: [Train] = []
    for y in 0..<height {
        for x in 0..<width {
            let string = Array(lines[y])[safe: x].flatMap { String($0) }
            let position = Point(x: x, y:y)
            switch string {
            case "v": trains.append(.init(position: position, direction: .south))
            case "^": trains.append(.init(position: position, direction: .north))
            case ">": trains.append(.init(position: position, direction: .east))
            case "<": trains.append(.init(position: position, direction: .west))
            default: break
            }
        }
    }
    return trains
}

fileprivate func crashSite(in grid: Grid, with trains: [Train]) -> Point? {
    let occupiedPositions = trains.map { $0.position }
    return occupiedPositions.findFirst({ pos in occupiedPositions.count(where: { $0 == pos }) > 1})
}

fileprivate struct Train: Equatable {
    var position: Point
    var direction: CardinalDirection
    
    init(position: Point, direction: CardinalDirection) {
        self.position = position
        self.direction = direction
    }
    
    var lastTurnedDirectionAtIntersection: LocalDirection?
    
    func nextDirectionAtIntersection() -> LocalDirection {
        guard let lastTurn = lastTurnedDirectionAtIntersection else { return .left }
        switch lastTurn {
        case .left:     return .forward
        case .forward:  return .right
        case .right:    return .left
        case .backward: fatalError()
        }
    }
    
    mutating func move(in grid: Grid) {
        position = position.steppingOnce(direction)
        let newTile = grid[position.y][position.x]
        let possibleNextDirections: [CardinalDirection] = newTile!.optionsOnEntering(from: direction.opposite)
        if possibleNextDirections.count == 1 {
            direction = possibleNextDirections.first!
        }
        else {
            let nextFacingOption = self.nextDirectionAtIntersection()
            lastTurnedDirectionAtIntersection = nextFacingOption
            direction = direction.turned(nextFacingOption)
        }
    }
    
    func moved(in grid: Grid) -> Train {
        var copy = self
        copy.move(in: grid)
        return copy
    }
    
    var displayCharacter: String {
        switch direction {
        case .east: return ">"
        case .north: return "^"
        case .west: return "<"
        case .south: return "v"
        }
    }
}

enum Track: String {
    case backslashCorner = "`"
    case forwardslashCorner = "/"
    case horizontalTrack = "-"
    case verticalTrack = "|"
    case intersection = "+"
    
    init?(rawValue: String) {
        switch rawValue {
        case "`": self = .backslashCorner
        case "/": self = .forwardslashCorner
        case "-", ">", "<": self = .horizontalTrack
        case "|", "v", "^": self = .verticalTrack
        case "+": self = .intersection
        default: return nil
        }
    }
    
    private var connections: [[CardinalDirection]] {
        switch self {
        case .backslashCorner: return [[.east, .north], [.west, .south]]
        case .forwardslashCorner: return [[.west, .north], [.east, .south]]
        case .horizontalTrack: return [[.west, .east]]
        case .verticalTrack: return [[.north, .south]]
        case .intersection: return [[.north, .south, .west, .east]]
        }
    }
    
    func optionsOnEntering(from direction: CardinalDirection) -> [CardinalDirection] {
        return connections.first(where: { $0.contains(direction) })!.filter { $0 != direction }
    }
}

fileprivate func print(grid: Grid, trains: [Train]) {
//    return
    
    var lines = grid.map { $0.map { $0?.rawValue ?? " " }}
    for train in trains {
        var copyLine = lines[train.position.y]
        copyLine[train.position.x] = train.displayCharacter
        lines[train.position.y] = copyLine
    }
    let output = lines.map { $0.joined() }.joined(separator: "\n")
    print(output)
}
