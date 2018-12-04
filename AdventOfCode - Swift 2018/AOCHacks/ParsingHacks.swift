//
//  ParsingHacks.swift
//  AdventOfCode - Swift 2018
//
//  Created by Chris Hawkins on 3/12/18.
//  Copyright © 2018 Chris Hawkins. All rights reserved.
//

import Foundation

extension String {
    func extractInts(pattern: String) -> [Int] {
        let adjustedPattern = pattern.replacingOccurrences(of: "INT", with: "([0-9]+)")
        let regex = try! NSRegularExpression(pattern: adjustedPattern, options: [])
        let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count))!
        
        var ints: [Int] = []
        for i in 1..<match.numberOfRanges {
            let range = match.range(at: i)
            let substring = (self as NSString).substring(with: range)
            ints += [substring.intValue!]
        }
        return ints
    }
}

extension String {
    var lines: [String] {
        return self.components(separatedBy: .newlines)
    }
    
    mutating func chomp(_ string: String) {
        if self.hasPrefix(string) {
            self.removeSubrange(startIndex..<string.endIndex)
        }
    }
    
    mutating func chompInt() -> Int {
        let intString = prefix(while: { ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains($0) })
        guard let int = intString.intValue else { fatalError() }
        self.removeSubrange(intString.startIndex..<intString.endIndex)
        return int
    }
}


