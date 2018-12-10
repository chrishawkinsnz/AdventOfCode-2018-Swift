//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day8Part1() {
    var numbers = day8Input.components(separatedBy: .whitespacesAndNewlines).compactMap { $0.intValue}
    
    var nodeStack: [LicenseNode] = []
    func parseNode(from input: inout [Int]) -> LicenseNode {
        let childCount = input.remove(at: 0)
        let metaDataCount = input.remove(at: 0)
        var childNodes: [LicenseNode] = []
        var metaData: [Int] = []
        print("CHILD COUNT: \(childCount)")
        for _ in 0..<childCount {
            childNodes.append(parseNode(from: &input))
        }
        for _ in 0..<metaDataCount {
            metaData.append(input.remove(at: 0))
        }
        var node = LicenseNode()
        node.children = childNodes
        node.metadata = metaData
        return node
    }
    let rootNode = parseNode(from: &numbers)
    
    print(rootNode.value())
}

struct LicenseNode {
    var metadata: [Int] = []
    var children: [LicenseNode] = []
    
    func metadataSum() -> Int {
        return metadata.sum() + children.map { $0.metadataSum() }.sum()
    }
    
    func value() -> Int {
        print("CHILDREN.COUNT: \(children.count)")
        if children.count == 0 {
            let sum = metadata.sum()
            print(sum)
            return sum
        }
        else {
            var sum: Int = 0
            for index in metadata {
                if let child = children[safe: index - 1] {
                    sum += child.value()
                }
            }
            return sum
        }
    }
}

func day8Part2() {
}
