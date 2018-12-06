//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day5Part1() {
    let polymer = Array(day5Input)
    print(runPolyymerExperiment(string: polymer))
}

func runPolyymerExperiment(string: [Character]) -> Int {
    var polymer = string
    while true {
        var i = 0;
        var madeItAllTheWay = true
        while i < (polymer.count - 1) {
            if (doReact(lhs: polymer[i], rhs: polymer[i+1])) {
                polymer.remove(at: i)
                polymer.remove(at: i)
                madeItAllTheWay = false
            }
            i += 1
        }
        if (madeItAllTheWay) {
            return polymer.count
        }
    }
}

func day5Part2() {
    var lowest = Int.max
    let basePolymer = Array(day5Input)

    for pair in zip(lowercases, uppercases) {
        let adjustedPolymer = basePolymer.filter { $0 != pair.0 && $0 != pair.1}
        let count = runPolyymerExperiment(string: adjustedPolymer)
        if (count < lowest) {
            lowest = count
        }
    }
    print("lowest: \(lowest)")
}

let lowercases = "abcdefghijklmnopqrstuvwxyz"
let uppercases = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


func doReact(lhs: Character, rhs: Character) -> Bool {
    let leftIsLowercase = lowercases.contains(lhs)
    let rightIsLowercase = lowercases.contains(rhs)
    
    guard leftIsLowercase != rightIsLowercase else { return false }
    
    let lhsIndex = (lowercases.firstIndex(of: lhs) ?? uppercases.firstIndex(of: lhs))!
    let rhsIndex = (lowercases.firstIndex(of: rhs) ?? uppercases.firstIndex(of: rhs))!
    return lhsIndex == rhsIndex
}
