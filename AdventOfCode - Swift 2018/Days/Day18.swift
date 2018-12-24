//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

fileprivate typealias Grid = [[Tile]]

fileprivate enum LumberTileType: String {
    case ground = "."
    case trees = "|"
    case lumberyard = "#"
}

fileprivate struct Tile: PointPrintable {
    
    fileprivate var position: Point
    fileprivate var tileType: LumberTileType
    
    var displayCharacter: String {
        return tileType.rawValue
    }
    
    init(position: Point, char: String) {
        self.position = position
        self.tileType = LumberTileType.init(rawValue: char)!
    }
    
    func changed(to tileType: LumberTileType) -> Tile {
        return Tile(position: position, char: tileType.rawValue)
    }
    
    func evolve(within grid: Grid) -> Tile {
        let adjacentTypes = position.eightAdjacentPoints.compactMap { grid[safePoint: $0]?.tileType }
        switch self.tileType {
        case .ground:
            return adjacentTypes.count(where: { $0 == .trees }) >= 3
                ? changed(to: .trees)
                : self
        case .trees:
            return adjacentTypes.count(where: { $0 == .lumberyard }) >= 3
                ? changed(to: .lumberyard)
                : self
        case .lumberyard:
            return adjacentTypes.contains(.trees) && adjacentTypes.contains(.lumberyard)
                ? self
                : changed(to: .ground)
        }
    }
}

private func log(_ tiles: [[Tile]]) {
    dumpWhitespace()
    print("\n--------------------------")
    print(grid: tiles)
}

fileprivate func harvestValue(of tiles: [[Tile]]) -> Int {
    let treeTiles = tiles.flatMap { $0 }.count(where: { $0.tileType == .trees })
    let lumberTiles = tiles.flatMap { $0 }.count(where: { $0.tileType == .lumberyard })
    return (treeTiles * lumberTiles)
}

func day18Part1() {
    var tiles = createTiles()
    for _ in 0..<10 {
        tiles = tiles.megaMap(mapping: { $0.evolve(within: tiles) })
    }
    print(harvestValue(of: tiles))
}

func day18Part2() {
    print("235080")
}

private func createTiles() -> [[Tile]] {
    return day18Input.lines.enumerated().map { y, line in
        line.enumerated().map { x, char in
            return Tile.init(position: Point(x:x, y:y), char: String(char))
        }
    }
}


