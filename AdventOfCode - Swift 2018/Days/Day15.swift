//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

fileprivate typealias Grid = [[Tile]]

func day15Part1() {
    // Build grid
    let lines = day15InputSimple.lines
    var grid: Grid = []
    for (y, line) in lines.enumerated() {
        var row: [Tile] = []
        for (x, char) in line.stringChars.enumerated() {
            let point = Point(x: x, y: y)
            let tile = parse(tile: char, position: point)
            row += [tile]
        }
        grid += [row]
    }
    print(grid: grid)
    while true {
        func allCombatants() -> [Combatant] {
            return grid.flatMap { $0 }.compactMap { $0 as? Combatant }
        }
        // attack
        let combatants = allCombatants().sorted(by: \.position)
        for combatant in combatants {
            print("combatant \(combatant.team)")
            let enemies = allCombatants().filter { $0.team != combatant.team }
            var adjacentEnemy: Combatant? {
                return combatant.position.cardinallyAdjacentPoints
                    .compactMap({ grid[point: $0] as? Combatant})
                    .filter({ tile in enemies.contains(where: { tile === $0 }) }).first
            }
            // if not near enemy, move
            if adjacentEnemy == nil {
                let nextStep = enemies
                    .flatMap { $0.position.cardinallyAdjacentPoints }
                    .filter { grid[$0] is Floor }
                    .compactAddMap( { shortestPath(from: combatant.position, to: $0, in: grid) })
                    .min(by: {
                        if $0.1.count < $1.1.count { return true }
                        if $0.1.count > $1.1.count { return false }
                        return $0.1.first! < $1.1.first!
                        })
                
                if let nextStep = nextStep {
                    move(tile: combatant, to: nextStep.1.first!, in: &grid)
//                    print("stepping to \(nextStep.debugDescription)")
                }
                
            }
            
            // if near enemy attack
            if let adjacentEnemy = adjacentEnemy {
//                print("attack them")
            }
            
            // TODO is in range a consideration
        }
        
        print(grid: grid)
    }
    print(grid: grid)
}



private func move(tile: Tile, to destination: Point, in grid: inout Grid) {
    grid[point: destination] = tile
    grid[point: tile.position] = Floor(position: tile.position)
    tile.position = destination
}


private func print(grid: Grid) {
    var outputString = ""
    for (_, line) in grid.enumerated() {
        for (_, tile) in line.enumerated() {
            outputString += tile.character
        }
        outputString += "\n"
    }
    print(outputString)
}


func day15Part2() {
    
}

class GenericSearchNode<T: Equatable&Hashable> {
    var value: T
    var cost: Int
    var findConnections: (GenericSearchNode<T>) -> [GenericSearchNode<T>]
    var priorNode: GenericSearchNode<T>?
    
    init(value: T, cost: Int, priorNode: GenericSearchNode<T>?, connections: @escaping (GenericSearchNode<T>) -> [GenericSearchNode<T>]) {
        self.value = value
        self.cost = cost
        self.priorNode = priorNode
        self.findConnections = connections
    }
}
var visited: [Point] = []

fileprivate func shortestPath(from: Point, to: Point, in grid: Grid) -> [Point]? {
    // TODO consider draws
    visited = []
    func connections(for node: GenericSearchNode<Point>) -> [GenericSearchNode<Point>] {
        return availableMoves(from: node.value, in: grid)
            .filter { !visited.contains($0) }
            .map { GenericSearchNode.init(value: $0, cost: node.cost + 1, priorNode: node, connections: { connections(for: $0) })}
    }
    
    var candidates: [GenericSearchNode<Point>] = []
    candidates.append(.init(value: from, cost: 0, priorNode: nil, connections: { connections(for: $0) }))
    
    while let candidate = candidates.first {
//        print("investigating candidate")
        if candidate.value == to {
            var chain: [GenericSearchNode<Point>] = [candidate]
            var tail = candidate
            while let prior = tail.priorNode {
                chain.insert(prior, at: 0)
                tail = prior
            }
            return Array(chain.map { $0.value }.dropFirst())
        }
        visited.append(candidate.value)
        candidates = candidates
            .appending(contentsOf: connections(for: candidate))
            .filter { !visited.contains($0.value) }
            .sorted(by: { (a, b) -> Bool in
                if a.cost < b.cost { return true }
                if a.cost > b.cost { return false }
                return a.value < b.value
            })
    }
    
    return nil
}

private func availableMoves(from: Point, in grid: Grid) -> [Point] {
    return from.cardinallyAdjacentPoints
        .filter { grid[point: $0] is Floor }
}

protocol Tile: class {
    func combatPhase()
    func movementPhase()
    
    var position: Point { get set }
    init(position: Point)
    static var character: String { get }
}

extension Tile {
    var character: String {
        return type(of: self).character
    }
}

class Wall: Tile {
    func combatPhase() { }
    func movementPhase() { }
    static var character: String { return "#" }
    
    var position: Point
    required init(position: Point) {
        self.position = position
    }
}

class Floor: Tile {
    func combatPhase() { }
    func movementPhase() { }
    static var character: String { return "." }
    
    var position: Point
    required init(position: Point) {
        self.position = position
    }
}

class Combatant: Tile {
    enum Team {
        case goblin
        case elf
    }
    class var team: Team { fatalError() }
    var team: Team { return type(of: self).team }
    
    func combatPhase() { }
    func movementPhase() { }
    
    class var character: String {
        switch team {
        case .goblin: return "G"
        case .elf: return "E"
        }
    }
    
    var position: Point
    required init(position: Point) {
        self.position = position
    }
}

class Goblin: Combatant {
    override class var team: Team { return Combatant.Team.goblin }
}

class Elf: Combatant {
    override class var team: Team { return Combatant.Team.elf }
}

private var allTileTypes: [Tile.Type] = [
    Wall.self,
    Floor.self,
    Goblin.self,
    Elf.self
]

func parse(tile: String, position: Point) -> Tile {
    let tileType = allTileTypes.first(where: { $0.character == tile })!
    return tileType.init(position: position)
}

