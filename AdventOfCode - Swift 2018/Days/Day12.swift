//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day12Part1() {
    var plantMap = day12InitialState.map { $0 == "#" }.indexDict()
    let rules = day12Input.lines.map(Rule.init(string:))
    
    for _ in 1...20 {
        plantMap = runGeneration(on: plantMap, rules: rules)
    }
    
    print(score(for: plantMap))
}

func day12Part2() {
    var plantMap = day12InitialState.map { $0 == "#" }.indexDict()
    let rules = day12Input.lines.map(Rule.init(string:))
    
    var scores: [Int] = []
    let finalGeneration = 50_000_000_000
    for generation in 1...finalGeneration {
        plantMap = runGeneration(on: plantMap, rules: rules)
        scores += [score(for: plantMap)]
        let deltas = scores.deltas()
        if deltas.count > 5 && deltas.suffix(5).countUnique == 1 {
            let gensRemaining = finalGeneration - generation
            let expectedFinalScore = deltas.last! * gensRemaining + scores.last!
            print(expectedFinalScore)
            return
        }
    }
}

fileprivate func score(for plantMap: [Int: Bool]) -> Int {
    return plantMap.filter { $0.value }.map { $0.key }.sum()
}

fileprivate func runGeneration(on plantMap: [Int: Bool], rules: [Rule]) -> [Int: Bool] {
    var nextGeneration = plantMap
    
    for rule in rules {
        for index in getScanningRange(of: plantMap) {
            if let change = rule.effectOnPosition(position: index, within: plantMap) {
                nextGeneration[index] = change
            }
        }
    }
    nextGeneration = nextGeneration.filter { getPlantRange(of: nextGeneration).contains($0.key) }
    return nextGeneration
}

func getPlantRange(of plantMap: [Int: Bool]) -> ClosedRange<Int> {
    let minPlantIndex = plantMap.filter { $0.value }.keys.min()!
    let maxPlantIndex = plantMap.filter { $0.value }.keys.max()!
    return minPlantIndex...maxPlantIndex
}

func getScanningRange(of plantMap: [Int: Bool]) -> ClosedRange<Int> {
    let minPlantIndex = plantMap.filter { $0.value }.keys.min()!
    let maxPlantIndex = plantMap.filter { $0.value }.keys.max()!
    return minPlantIndex-2...maxPlantIndex+2
}

struct Rule {
    var inputs: [Int: Bool] = [:]
    var output: Bool
    
    init(string: String) {
        let inputString = string.components(separatedBy: " => ")[0]
        let outputString = string.components(separatedBy: " => ")[1]
        let bools = inputString.map { $0 == "#" }
        for (i, planted) in bools.enumerated() {
            inputs[i - 2] = planted
        }
        
        output = outputString == "#"
    }
    
    func effectOnPosition(position: Int, within plants: [Int: Bool]) -> Bool? {
        for input in inputs.keys {
            if plants[position + input, default: false] != inputs[input] {
                return nil
            }
        }
        return output
    }
    
}

