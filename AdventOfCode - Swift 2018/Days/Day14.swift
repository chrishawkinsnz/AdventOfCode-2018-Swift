//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

fileprivate typealias Grid = [[Track?]]
typealias Recipe = Int
func day14Part1() {
    let input = 880751
    
    var elfIndices: [Int] = [0,1]
    var scoreboard: [Recipe] = [3, 7]
    
    var iteration: Int = 0
    while scoreboard.count < (input + 10) {
        printEvery(nTimes: 1000, output: "\(iteration)")
        performStep(scoreboard: &scoreboard, elfIndices: &elfIndices, iterationCount: &iteration)
    }
    
    print(scoreboard.dropFirst(input).prefix(10).map { "\($0)" }.joined())
}


func day14Part2() {
    let input = 880751
    let inputInts = input.decimalDigits
    let numInts = inputInts.count
    var elfIndices: (a: Int, b: Int) = (0,1)
    var scoreboard: [Recipe] = [3, 7]
    
    var iteration: Int = 0
    var nextWalkbackPoint: Int = inputInts.count
    let inputString = String(input)
    let t0 = Date()
    var totalNumber: Int = 0
    outer: while true {
        totalNumber += 1
        performStepQuick(scoreboard: &scoreboard, elfIndices: &elfIndices, iterationCount: &iteration)
        if scoreboard.count >= nextWalkbackPoint {
            nextWalkbackPoint += numInts
            for i in 0..<numInts {
                if (inputInts[numInts - i - 1] != scoreboard[nextWalkbackPoint - numInts - i - 1]) { continue outer }
            }
            
            let wholeString = scoreboard.map { "\($0)" }.joined()
            print((wholeString as NSString).range(of: inputString).location)
            let t1 = Date() 
            print(t1.timeIntervalSince(t0))
            print(totalNumber)
            return
        }
    }
}

func performStep(scoreboard: inout [Recipe], elfIndices: inout [Int], iterationCount: inout Int) {
    let currentRecipes = elfIndices.map { scoreboard[$0]}
    let division = currentRecipes.sum().quotientAndRemainder(dividingBy: 10)
    let newRecipes: [Int]
    if division.quotient > 0 {
        newRecipes = [division.quotient, division.remainder]
    }
    else {
        newRecipes = [division.remainder]
    }
    scoreboard += newRecipes
    iterationCount += newRecipes.count
    elfIndices = elfIndices.enumerated().map {
        return ($0.element + 1 + currentRecipes[$0.offset]).modulo(scoreboard.count)
    }
}

func performStepQuick(scoreboard: inout [Recipe], elfIndices: inout (a: Int, b: Int), iterationCount: inout Int) {
    let currentRecipes: (a: Int, b: Int) = (scoreboard[elfIndices.a], scoreboard[elfIndices.b])
    let total = (currentRecipes.a + currentRecipes.b)
    if total >= 10 {
        iterationCount += 2
        let first = total / 10
        scoreboard.append(first)
        scoreboard.append(total - (first * 10))
    }
    else {
        iterationCount += 1
        scoreboard.append(total)
    }
    elfIndices.a = (elfIndices.a + 1 + currentRecipes.a) % (scoreboard.count)
    elfIndices.b = (elfIndices.b + 1 + currentRecipes.b) % (scoreboard.count)
}

func debugPrint(scoreboard: [Recipe], elfIndices: [Int]) {
    var str = ""
    for i in 0..<scoreboard.count {
        if i == elfIndices[0] {
            str += "("
        }
        else if i == elfIndices[1] {
            str += "["
        }
        else {
            str += " "
        }
        str += "\(scoreboard[i])"
        if i == elfIndices[0] {
            str += ")"
        }
        else if i == elfIndices[1] {
            str += "]"
        }
        else {
            str += " "
        }
    }
    print(str)

}
