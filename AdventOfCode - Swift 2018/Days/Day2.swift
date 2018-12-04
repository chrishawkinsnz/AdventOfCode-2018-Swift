//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day2Part1() {
    let checkSum = ids.count(where: { $0.containsAnyLetter(numberOfTimes: 2)})
                 * ids.count(where: { $0.containsAnyLetter(numberOfTimes: 3)})
    print(checkSum)
}

func day2Part2() {
    for stringPair in ids.allPairs(with: ids) {
        let characterPairings = zip(stringPair.0, stringPair.1)
        if characterPairings.count(where: { $0 == $1}) == stringPair.0.count - 1 {
            print(String(characterPairings.filter{$0.0 == $0.1}.map{$0.0}))
            return
        }
    }
}

private var ids = day2Input.components(separatedBy: .newlines)

private extension String {
    func containsAnyLetter(numberOfTimes: Int) -> Bool {
        return self.contains(where: { char in self.count(where: { $0 == char }) == numberOfTimes })
    }
}

