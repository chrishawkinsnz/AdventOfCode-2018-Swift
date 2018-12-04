//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day1Part1() {
    print(changes.sum())
}

func day1Part2() {
    var priorSums: Set<Int> = []
    var sum: Int = 0
    
    for delta in changes.looping {
        sum += delta
        if priorSums.contains(sum) { break }
        priorSums.insert(sum)
    }
    print(sum)
}

func day1Part2FailedLazyAttempt() {
    struct Step {
        var priorSum: Set<Int> = []
        var sum: Int = 0
    }
    let _ = changes.looping.lazy.scanl(initial: Step()) { (lastStep, delta) -> Step in
        let sum = lastStep.sum + delta
        return Step(priorSum: lastStep.priorSum.inserting(sum), sum: sum)
    }.first(where: { $0.priorSum.contains($0.sum) })
}

private var changes: [Int] {
    return day1Input
        .components(separatedBy: .newlines)
        .compactMap { $0.intValue }
}


