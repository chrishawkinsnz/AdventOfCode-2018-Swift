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
    print(runSimulation(elfAttackPower: 3, elfDeathsAcceptable: true)!)
}

func day15Part2() {
    for attackPower in 10... {
        print(attackPower)
        if let value = runSimulation(elfAttackPower: attackPower, elfDeathsAcceptable: false) {
            print(value)
            return
        }
    }
}

func runSimulation(elfAttackPower: Int, elfDeathsAcceptable: Bool = true) -> Int? {
    Elf.baseAttackPower = elfAttackPower

    let lines = day15Input.lines
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
    var barrenPositions: [Combatant.Team: Set<Point>] = [
        .goblin: [],
        .elf: []
    ]
    
    func clearBarrennessCache() {
        barrenPositions[.goblin]?.removeAll(keepingCapacity: false)
        barrenPositions[.elf]?.removeAll(keepingCapacity: false)
    }
    
    var roundsCompleted: Int = 0
    while true {
        func allCombatants() -> [Combatant] {
            return grid.flatMap { $0 }.compactMap { $0 as? Combatant }
        }
        // attack
        let t0 = Date()
        
        var combatants = allCombatants().sorted(by: \.position)
        for combatant in combatants {
            guard combatant.hp > 0 else { continue }
            let enemies = allCombatants().filter { $0.team != combatant.team }
            var adjacentEnemy: Combatant? {
                return combatant.position.cardinallyAdjacentPoints
                    .compactMap({ grid[point: $0] as? Combatant})
                    .filter({ tile in enemies.contains(where: { tile === $0 }) })
                    .min(by: { a, b in
                        if a.hp < b.hp { return true }
                        if a.hp > b.hp { return false }
                        return a.position < b.position
                    })
            }
            
            if adjacentEnemy == nil && !barrenPositions[combatant.team]!.contains(combatant.position) {
                let enemieOpenings = enemies
                    .flatMap { $0.position.cardinallyAdjacentPoints }
                    .filter { grid[$0] is Floor }
                    .sorted(by: { $0.manhattanDistanceTo(combatant.position) < $1.manhattanDistanceTo(combatant.position) })
                
                let result = shortestPath3(from: combatant.position, toOneOf: enemieOpenings, in: grid)
                switch result {
                case .path(let path):
                    move(tile: combatant, to: path.first!, in: &grid)
                    clearBarrennessCache()
                case .noPath(let visited):
                    visited.forEach { barrenPositions[combatant.team]?.insert($0) }
                }
            }
            
            // if near enemy attack
            if let adjacentEnemy = adjacentEnemy {
                print("adjacent enemy hp: \(adjacentEnemy.hp)")
                adjacentEnemy.hp -= combatant.attack
                print("adjacent enemy hp: \(adjacentEnemy.hp)")
                if adjacentEnemy.hp <= 0 {
                    clearBarrennessCache()
                    grid[point: adjacentEnemy.position] = Floor(position: adjacentEnemy.position)
                    if adjacentEnemy.team == .elf && !elfDeathsAcceptable {
                        for _ in 0...100 { print("ABANDON TIMELINE, ELVES HAVE FALLEN") }
                        return nil
                    }
                    if combatants.filter({ $0.hp > 0 }).map({ $0.team }).countUnique == 1 {
                        let remainingHp = combatants.filter { $0.hp > 0 }.map { $0.hp }.sum()
                        print("Combat completed")
                        print("Rounds: \(roundsCompleted)")
                        print("Total remaining HP: \(remainingHp)")
                        return roundsCompleted * remainingHp
                    }
                }     
            }
        }
        let t1 = Date()
        print(t1.timeIntervalSince(t0))
        
        print(grid: grid)
        roundsCompleted += 1
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

// v1: 162.34325206279755
// v2: 160.011234998703  // swapping sorted for min
fileprivate func shortestPath(from: Point, to: Point, in grid: Grid) -> [Point]? {
    // TODO consider draws
    visited = []
    func connections(for node: GenericSearchNode<Point>) -> [GenericSearchNode<Point>] {
        return availableMoves(from: node.value, in: grid)
            .filter { !visited.contains($0) }
            .map { GenericSearchNode.init(value: $0, cost: node.cost + 1, priorNode: node, connections: { connections(for: $0) })}
    }
    
    var candidates: [GenericSearchNode<Point>] = []
    var nextCandidate: GenericSearchNode<Point>? = .init(value: from, cost: 0, priorNode: nil, connections: { connections(for: $0) })

    while true {
        guard let candidate = nextCandidate else { break }
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
            
        nextCandidate = candidates.min(by: { (a, b) -> Bool in
            if a.cost < b.cost { return true }
            if a.cost > b.cost { return false }
            return a.value < b.value
        })
    }
    
    return nil
}

// v3 17.114624977111816 // Considering if a previous combatant is closer
// v4 0.5703179836273193 // Sorting openings before searching
enum SearchResult {
    case path(path: [Point])
    case noPath(visited: [Point])
}

fileprivate func shortestPath2(from: Point, to: Point, in grid: Grid, previousClosestLength: Int) -> [Point]? {
    // TODO consider draws
    visited = []
    func connections(for node: GenericSearchNode<Point>) -> [GenericSearchNode<Point>] {
        return availableMoves(from: node.value, in: grid)
            .filter { !visited.contains($0) }
            .map { GenericSearchNode.init(value: $0, cost: node.cost + 1, priorNode: node, connections: { connections(for: $0) })}
    }
    
    var candidates: [GenericSearchNode<Point>] = []
    var nextCandidate: GenericSearchNode<Point>? = .init(value: from, cost: 0, priorNode: nil, connections: { connections(for: $0) })
    
    while true {
        guard let candidate = nextCandidate else { break }
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
        
        nextCandidate = candidates.min(by: { (a, b) -> Bool in
            if a.cost < b.cost { return true }
            if a.cost > b.cost { return false }
            return a.value < b.value
        })
        if nextCandidate != nil && nextCandidate!.cost + nextCandidate!.value.manhattanDistanceTo(to) > previousClosestLength {
            return nil
        }
    }
    
    return nil
}

fileprivate func shortestPath3(from: Point, toOneOf destinations: [Point], in grid: Grid) -> SearchResult {
    // TODO consider draws
    visited = []
    func connections(for node: GenericSearchNode<Point>) -> [GenericSearchNode<Point>] {
        return availableMoves(from: node.value, in: grid)
            .filter { !visited.contains($0) }
            .map { GenericSearchNode.init(value: $0, cost: node.cost + 1, priorNode: node, connections: { connections(for: $0) })}
    }
    
    var candidates: [GenericSearchNode<Point>] = []
    var nextCandidate: GenericSearchNode<Point>? = .init(value: from, cost: 0, priorNode: nil, connections: { connections(for: $0) })
    
    while true {
        guard let candidate = nextCandidate else { break }
        //        print("investigating candidate")
        if destinations.contains(candidate.value) {
            var chain: [GenericSearchNode<Point>] = [candidate]
            var tail = candidate
            while let prior = tail.priorNode {
                chain.insert(prior, at: 0)
                tail = prior
            }
            return SearchResult.path(path: Array(chain.map { $0.value }.dropFirst()))
        }
        visited.append(candidate.value)
        candidates = candidates
            .appending(contentsOf: connections(for: candidate))
            .filter { !visited.contains($0.value) }
        
        nextCandidate = candidates.min(by: { (a, b) -> Bool in
            if a.cost < b.cost { return true }
            if a.cost > b.cost { return false }
            return a.value < b.value
        })
    }
    return SearchResult.noPath(visited: visited)
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
    var attack: Int { return 3 }
    var hp: Int = 200
    
    enum Team: Hashable, Equatable {
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
    static var baseAttackPower: Int = 3
    override var attack: Int { return Elf.baseAttackPower }
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

