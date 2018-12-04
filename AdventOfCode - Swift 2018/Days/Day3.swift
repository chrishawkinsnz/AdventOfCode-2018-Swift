//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation
import AppKit

private struct Claim {
    var id: Int
    var rect: Rect
}

func day3Part1() {
    print(occupancies.values.count(where: { $0.count >= 2}))
}

func day3Part2() {
    print(claims.first { (claim) -> Bool in
        return !claim.rect.occupiedPositions.contains(where:{ (occupancies[$0]?.count ?? 0) > 1})
    }!.id)
}

private var claims: [Claim] = day3Input.lines.map(parseRect)

private var occupancies: [Point: [Claim]] = {
    var occupancies: [Point: [Claim]] = [:]
    for claim in claims {
        for pt in claim.rect.occupiedPositions {
            occupancies[pt, default: []].append(claim)
        }
    }
    return occupancies
}()

private func parseRect(_ line: String) -> Claim {
    let ints = line.extractInts(pattern: "#INT @ INT,INT: INTxINT")
    let rect = Rect.init(origin: .init(x:ints[1], y:ints[2]), size: .init(wd: ints[3], ht: ints[4]))
    return Claim.init(id: ints[0], rect: rect)
}


