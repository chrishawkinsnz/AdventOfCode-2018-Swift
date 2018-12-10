//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day7Part1() {
    var graph = buildGraph(input: day7Input)
    
    var visitedNodes: [Node] = []
    var pointsOfInvesigation: [Node] {
        return graph
            .filter { !visitedNodes.contains($0) }
            .filter { n in n.dependentOn.count(where: { !visitedNodes.contains($0) }) == 0 }
            .sorted(by: \.letter)
    }
    while let pointOfInvestigation = pointsOfInvesigation.first {
        visitedNodes.append(pointOfInvestigation)
    }
    print(visitedNodes.map { $0.letter }.joined())
}

func day7Part2() {
    Node.baseTime = 60
    var maxWorkers = 5
    var graph = buildGraph(input: day7Input)
    
    var processingNodes: [Node] = []
    var visitedNodes: [Node] = []
    
    var remainingNodes: [Node] {
        return graph
            .filter { !visitedNodes.contains($0) }
            .filter { $0.timeRemaining > 0 }
    }
    
    var pointsOfInvesigation: [Node] {
        return remainingNodes
            .filter { !processingNodes.contains($0) }
            .filter { !visitedNodes.contains($0) }
            .filter { n in n.dependentOn.count(where: { !visitedNodes.contains($0) }) == 0 }
            .sorted(by: \.letter)
    }
    
    var time = 0
    while remainingNodes.count > 0 {
        time += 1
        
        // Complete any in progress work
        for finishedNode in processingNodes.filter({ $0.timeRemaining <= 0 }) {
            processingNodes.remove(finishedNode)
            visitedNodes.append(finishedNode)
        }
        // Load up all available workers with work
        while let pointOfInvestigation = pointsOfInvesigation.first, processingNodes.count < maxWorkers {
            processingNodes += [pointOfInvestigation]
        }

        // Process one time unit on each in progress piece of work
        processingNodes.forEach { $0.timeRemaining -= 1}
    }
    print(time)
}

fileprivate func buildGraph(input: String) -> [Node] {
    var nodes: [String: Node] = [:]
    let dependencies = input.lines.map(Dependency.init(string:))
    dependencies.flatMap { [$0.letter, $0.dependsOn] }.unique.map(Node.init(letter:)).forEach { nodes[$0.letter] = $0}
    
    for dependency in dependencies {
        nodes[dependency.letter]!.dependentOn += [nodes[dependency.dependsOn]!]
    }

    return Array(nodes.values)
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

fileprivate class Node: Hashable, Equatable {
    
    static var baseTime: Int = 60
    
    var letter: String
    var dependentOn: [Node] = []
    var timeRemaining: Int
    
    init(letter: String) {
        self.letter = letter
        let letters = Array("_ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        timeRemaining = Node.baseTime + letters.firstIndex(of: letter.first!)!
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(letter)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.letter == rhs.letter
    }
    
}
