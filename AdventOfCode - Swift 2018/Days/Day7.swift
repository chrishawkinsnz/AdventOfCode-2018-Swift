//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation


func day7Part1() {
    var nodes: [String: Node] = [:]
    var graph: [Node: [Node]] = [:] // From node to the elements it depends on
    let dependencies = day7Input.lines.map(Dependency.init(string:))
    dependencies.flatMap { [$0.letter, $0.dependsOn] }.unique.map(Node.init(letter:)).forEach { nodes[$0.letter] = $0}
    nodes.values.forEach { graph[$0] = [] }
    
    for dependency in dependencies {
        let node = nodes[dependency.letter]!
        let nodeDependentOn = nodes[dependency.dependsOn]!
        graph[node]! += [nodeDependentOn]
    }

    var visitedNodes: [Node] = []
    var pointsOfInvesigation: [Node] {
        return graph
            .filter { !visitedNodes.contains($0.key) }
            .filter { n in n.value.count(where: { !visitedNodes.contains($0) }) == 0 }
            .map { $0.key }
            .sorted(by: \.letter)
    }
    while let pointOfInvestigation = pointsOfInvesigation.first {
        visitedNodes.append(pointOfInvestigation)
    }
    print(visitedNodes.map { $0.letter }.joined())
}

func day7Part2() {

}

struct Dependency {
    var letter: String
    var dependsOn: String
    
    init(string: String) {
        let strings = string.extractStrings(pattern: "Step STRING must be finished before step STRING can begin.")
        letter = strings[1]
        dependsOn = strings[0]
    }
}

class Node: Hashable, Equatable {
        
    var letter: String
    
    init(letter: String) {
        self.letter = letter
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(letter)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.letter == rhs.letter
    }
    
}
