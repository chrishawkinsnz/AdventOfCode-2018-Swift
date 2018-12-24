//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation
func day20Part1() {
    let input = day20Input
    
    let sanitizedInput = String(input.dropFirst().dropLast())
    let tokens = sanitizedInput.map { Token.init(String($0)) }
    let rootGraphNode = createGraph(from: tokens)
    let map = buildMap(from: rootGraphNode)
    let dist = futhestDistance(from: map)
    
    printMaze(map)
    print(dist)
}

fileprivate enum MetaToken: String {
    case beginGroup = "("
    case endGroup = ")"
    case groupDivider = "|"
}

fileprivate enum Token {
    case direction(CardinalDirection)
    case meta(MetaToken)
    
    init(_ string: String) {
        if let metaToken = MetaToken.init(rawValue: string) {
            self = .meta(metaToken)
        }
        else if let directionToken = CardinalDirection(string: string) {
            self = .direction(directionToken)
        }
        else {
            fatalError()
        }
    }
}

fileprivate typealias MazeMap = [Point: Tile]

fileprivate protocol MazeNode: class, CustomDebugStringConvertible {
    func explore(within map: inout MazeMap, startingFrom origin: Point) -> [Point]
}

fileprivate class MultiNode: MazeNode {
    var options: [MazeNode] = []
    
    var debugDescription: String {
        var str = "<MultiNode>\n"
        for option in options {
            str += option.debugDescription
            str += "\n"
        }
        str += "</MultiNode>"
        return str
    }
    
    func explore(within map: inout MazeMap, startingFrom origin: Point) -> [Point] {
        var tips = Set<Point>()
        for option in options {
            let freshTips = option.explore(within: &map, startingFrom: origin)
            freshTips.forEach { tips.insert($0) }
        }
        return Array(tips)
    }
}

fileprivate class DirectionNode: MazeNode {
    var direction: CardinalDirection
    
    init(direction: CardinalDirection) {
        self.direction = direction
    }
    
    var debugDescription: String {
        return "<DirectionNode> \(direction.letter) </DirectionNode>"
    }
    
    func explore(within map: inout MazeMap, startingFrom origin: Point) -> [Point] {
        let dest = origin.moved(direction)
        map[origin, default: Tile(position: origin)].doors.insert(direction)
        map[dest, default: Tile(position: dest)].doors.insert(direction.opposite)
        return [dest]
    }
}

fileprivate class SequenceNode: MazeNode {
    var steps: [MazeNode] = []
    
    var debugDescription: String {
        var str = "<SequenceNode>\n"
        for step in steps {
            str += step.debugDescription
            str += "\n"
        }
        str += "</SequenceNode>"
        return str
    }
    
    func explore(within map: inout MazeMap, startingFrom origin: Point) -> [Point] {
        var tips: Set<Point> = [origin] // TODO does this need to be an input
        for step in steps {
            var nextTips = Set<Point>()
            for tip in tips {
                let resultingTips = step.explore(within: &map, startingFrom: tip)
                resultingTips.forEach { nextTips.insert($0) }
            }
            tips = nextTips
        }
        return Array(tips)
    }
}

fileprivate func buildMap(from graph: MazeNode) -> MazeMap {
    let initialTile = Tile(position: Point(x:0, y:0))
    var maze: [Point: Tile] = [initialTile.position: initialTile]
    _ = graph.explore(within: &maze, startingFrom: initialTile.position)
    return maze
}

fileprivate func futhestDistance(from map: MazeMap) -> Int {
    let records = findFurthestDistances(within: map, from: Point(x: 0, y: 0), walkDistance: 0, records: [:])
    return records.map { $0.value }.max()!
}

fileprivate func findFurthestDistances(within map: MazeMap, from start: Point, walkDistance: Int, records: [Point: Int]) -> [Point: Int] {
    var records = records
    records[start] = walkDistance
    
    let nextWalkDistance = walkDistance + 1
    let tile = map[start]!
    let nextOptions = tile
        .adjacentTiles(within: map)
        .filter {
            let priorRecord = (records[$0.position] ?? 99999999)
            let thisRecord = nextWalkDistance
            return priorRecord > thisRecord
        }
    
    for option in nextOptions {
        records = findFurthestDistances(within: map, from: option.position, walkDistance: nextWalkDistance, records: records)
    }
    
    return records
}

fileprivate func printMaze(_ maze: MazeMap) {
    let tp = Point(x: 0, y: 0)
    print(tp.moved(.south))
    let bounds = Bounds.init(wrapping: Array(maze.keys))
    var superStr = ""
    for y in bounds.yRange {
        var str1 = ""
        var str2 = ""
        var str3 = ""
        for x in bounds.xRange {
            if let mapTile = maze[Point(x: x, y: y)] {
                let displayUnit = mapTile.displayUnit
                str1 += displayUnit[0].joined()
                str2 += displayUnit[1].joined()
                str3 += displayUnit[2].joined()
            }
            else {
                str1 += "   "
                str2 += "   "
                str3 += "   "
            }
            if x != bounds.maxX {
                str1 = String(str1.dropLast())
                str2 = String(str2.dropLast())
                str3 = String(str3.dropLast())
            }
        }
        if y == bounds.minY {
            superStr += str1
            superStr += "\n"
        }
        superStr += str2
        superStr += "\n"
        superStr += str3
        superStr += "\n"
    }
    print(superStr)
}

fileprivate func createGraph(from tokens: [Token]) -> MazeNode {
    var rootNode: SequenceNode!
    
    var activeGroups: [MultiNode] = []
    var activeSequences: [SequenceNode] = [SequenceNode()]
    
    var activeGroup: MultiNode? {
        return activeGroups.last
    }
    
    var activeSequence: SequenceNode {
        return activeSequences.last!
    }
    
    func startSequence() {
        activeSequences += [SequenceNode()]
    }
    
    func closeSequqnce() {
        if let activeGroup = activeGroup {
            activeGroup.options.append(activeSequences.popLast()!)
        }
        else {
            rootNode = activeSequences.popLast()!
        }
    }
    
    func startGroup() {
        activeGroups += [MultiNode()]
        startSequence()
    }
    
    func closeGroup() {
        closeSequqnce()
        let group = activeGroups.popLast()!
        donateToSequence(group)
    }
    
    func donateToSequence(_ node: MazeNode) {
        activeSequence.steps += [node]
    }
    
    for input in tokens {
        switch input {
        case .direction(let direction):
            donateToSequence(DirectionNode(direction: direction))
            
        case .meta(.beginGroup):
            startGroup()
            
        case .meta(.endGroup):
            closeGroup()
            
        case .meta(.groupDivider):
            closeSequqnce()
            startSequence()
        }
    }
    closeSequqnce()
    return rootNode
}

//func chompNode(from input: inout [Token]) -> Node {
//    while let token = input.popFirst() {
//        switch token {
//        case .direction(let direction):
//            return DirectionNode(direction: direction)
//        case .meta(.beginGroup):
//
//            SequenceNode.init(steps: <#T##[Node]#>)
//            break
//        case .meta(.endGroup):
//            break
//        case .meta(.groupDivider):
//            break
//
//        }
//    }
//}

fileprivate struct Tile {
    let position: Point
    var doors: Set<CardinalDirection> = []
    
    init(position: Point) {
        self.position = position
    }
    
    var displayUnit: [[String]] {
        var base = [
            ["#","#","#"],
            ["#",".","#"],
            ["#","#","#"],
        ]
        if doors.contains(.east) { base[1][2] = "|" }
        if doors.contains(.west) { base[1][0] = "|" }
        if doors.contains(.north) { base[0][1] = "-" }
        if doors.contains(.south) { base[2][1] = "-" }
            return base
    }
    
    func adjacentTiles(within maze: MazeMap) -> [Tile] {
        return doors
            .map { position.moved($0) }
            .map { maze[$0]! }
    }
}



