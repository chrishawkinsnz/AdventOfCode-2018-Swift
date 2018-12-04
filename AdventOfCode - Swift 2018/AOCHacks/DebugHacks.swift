//
//  AdventOfCodeHacks.swift
//  AdventOfCode - Swift 2018
//
//  Created by Chris Hawkins on 5/12/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

var counts: [String: Int] = [:]

func printEvery(nTimes: Int, output: @autoclosure () -> String, line: Int = #line, file: String = #file) {
    let identifier = "\(file): \(line)"
    counts[identifier, default: 0] += 1
    if counts[identifier]!.remainderReportingOverflow(dividingBy: nTimes).partialValue == 0 {
        print(output())
    }
}
