//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day9Part1() {
    let playerCount = 10
    let lastMarbleValue = 1618
    print(runExperiment(playerCount: playerCount, lastMarbleValue: lastMarbleValue))
}
// 32
// 32
// 17
// 27
// 58
// 31   --
// 31   --
// 17
// 85
// 31   --
// 102
func day9Part2() {
    let playerCount = 411
    let lastMarbleValue = 7205900
    
    let t0 = Date()
    let score = runExperiment3(playerCount: playerCount, lastMarbleValue: lastMarbleValue)
    print(score)
    let t1 = Date()
    print(t1.timeIntervalSince(t0))
//    var scores: [Int] = []
//    var deltas: [Int] = []
//    var lastScore: Int?
//    for i in 1..<3000 {
//        let score = runExperiment(playerCount: playerCount, lastMarbleValue: i)
//        scores.append(score)
//        if let lastScore = lastScore {
//            let delta = score - lastScore
//            deltas.append(delta)
//            if i.modulo(23) == 0 {
//                print("LastMarbleValue:\(i)\t\tScore: \(score)\t\tDelta:\(delta)")
//            }
//        }
//        else {
//            deltas.append(0)
//        }
//
//        lastScore = score
//    }
    
//    for i in 0..<scores.count {
//        let score = scores[i]
//        let delta: Int
//        if (i > 0) {
//            delta = scores[i] - scores[i - 1]
//        }
//        else {
//            delta = 0
//        }
//        print("LastMarbleValue:\(iScore: \(score)\t\t\tDelta:\(delta)")
//    }
//    print(runExperiment(playerCount: playerCount, lastMarbleValue: lastMarbleValue))
}

fileprivate func runExperiment(playerCount: Int, lastMarbleValue: Int) -> Int {
    var nextMarbleUp = 1
    
    var currentMarbleIndex = 0
    var circle: [Int] = [0]
    var playerScores: [Int] = Array<Int>.init(repeating: 0, count: playerCount)
    while true {
        for playerIndex in 0..<playerCount {
            if nextMarbleUp == lastMarbleValue {
                //print something
                return playerScores.max()!
            }
            let nextMarble = nextMarbleUp
            nextMarbleUp += 1
            if nextMarble.modulo(23) == 0 {
                let newIndex = (currentMarbleIndex - 7).modulo(circle.count)
                currentMarbleIndex = newIndex
                let removedMarble = circle.remove(at: newIndex)
                let score = nextMarble + removedMarble
                playerScores[playerIndex] += score
            }
            else {
                let newIndex = (currentMarbleIndex + 2).modulo(circle.count)
                circle.insert(nextMarble, at: newIndex)
                currentMarbleIndex = circle.firstIndex(of: nextMarble)!
            }
        }
    }
}


fileprivate func runExperiment2(playerCount: Int, lastMarbleValue: Int) -> Int {
    var nextMarbleUp = 1

    var scoreLog: [Int] = []
    var currentMarbleIndex = 0
    var circle: [Int] = [0]
    var playerScores: [Int] = Array<Int>.init(repeating: 0, count: playerCount)
    while true {
        for playerIndex in 0..<playerCount {
            if nextMarbleUp == lastMarbleValue {
                //print something
                return playerScores.max()!
            }
            let nextMarble = nextMarbleUp
            nextMarbleUp += 1

            if nextMarble.modulo(23) == 0 {
                let newIndex = (currentMarbleIndex - 7).modulo(circle.count)
                currentMarbleIndex = newIndex
                let removedMarble = circle.remove(at: newIndex)
                let score = nextMarble + removedMarble
                scoreLog += [score]
                playerScores[playerIndex] += score
            }
            else {
                let newIndex = (currentMarbleIndex + 2).modulo(circle.count)
                circle.insert(nextMarble, at: newIndex)
                currentMarbleIndex = newIndex
            }
            
            if nextMarble.modulo(1000) == 0 {
                print(nextMarble)
            }
        }
    }
}


fileprivate func runExperiment3(playerCount: Int, lastMarbleValue: Int) -> Int {
    var nextMarbleUp = 1
    
    var scoreLog: [Int] = []
    var currentMarbleIndex = 0
    let circle: NSMutableArray = NSMutableArray.init(capacity: lastMarbleValue)
    circle.insert(0, at: 0)
    var playerScores: [Int] = Array<Int>.init(repeating: 0, count: playerCount)
    while true {
        for playerIndex in 0..<playerCount {
            if nextMarbleUp == lastMarbleValue {
                //print something
                return playerScores.max()!
            }
            let nextMarble = nextMarbleUp
            nextMarbleUp += 1
            
            if nextMarble.modulo(23) == 0 {
                let newIndex = (currentMarbleIndex - 7).modulo(circle.count)
                currentMarbleIndex = newIndex
                let removedMarble = circle[newIndex] as! Int
                circle.removeObject(at: newIndex)
                let score = nextMarble + removedMarble
                scoreLog += [score]
                playerScores[playerIndex] += score
            }
            else {
                let newIndex = (currentMarbleIndex + 2).modulo(circle.count)
                circle.insert(nextMarble, at: newIndex)
                currentMarbleIndex = newIndex
            }
            
            if nextMarble.modulo(1000) == 0 {
                print(nextMarble)
            }
        }
    }
}
