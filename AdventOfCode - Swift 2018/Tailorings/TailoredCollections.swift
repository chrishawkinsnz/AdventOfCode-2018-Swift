//
//  TailoredSequence.swift
//  TailoredSwift
//
//  Created by Chris Hawkins on 1/05/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

/// A workaround protocol wrapper for Optionals that lets use use Optional as a type constraint.
/// This type may become redundant once recursive type constraints are allowed (SE0157)
public protocol OptionalType {
    associatedtype WrappedType
    func getAsOptional() -> Optional<WrappedType>
}

/// Workaround to allow Optionals to be used as a type constraint
extension Optional : OptionalType {
    public func getAsOptional() -> Optional<Wrapped> {
        return self
    }
}

public extension Sequence where Iterator.Element: OptionalType {
    
    /// Converts an array of optionals to an array of all the unwrappped values.
    /// This is a more declarative alternative to array.flatMap { $0 }
    public func denillified() -> [Iterator.Element.WrappedType] {
        return self.map { $0.getAsOptional() }.compactMap { $0 }
    }
}


public extension Sequence where Iterator.Element == Int{
    /// Reurns the sum of all values in the sequence
    public func sum() -> Iterator.Element{
        return self.reduce(0, +)
    }
}

public extension Sequence where Iterator.Element: FloatingPoint{
    /// Reurns the sum of all values in the sequence
    public func sum() -> Iterator.Element{
        return self.reduce(0, +)
    }
}

public extension Sequence where Iterator.Element == Int{
    /// The mean of all values in a sequence
    public func mean() -> Double {
        var sum = 0
        var count = 0
        for elem in self {
            count += 1
            sum += elem
        }
        return Double(sum) / Double(count)
    }
}

public extension Sequence where Iterator.Element == Float{
    /// The mean of all values in a sequence
    public func mean() -> Float {
        var sum: Float = 0.0
        var count = 0
        for elem in self {
            count += 1
            sum += elem
        }
        return sum / Float(count)
    }
}

public extension Sequence where Iterator.Element == Double{
    /// The mean of all values in a sequence
    public func mean() -> Double {
        var sum = 0.0
        var count = 0
        for elem in self {
            count += 1
            sum += elem
        }
        return sum / Double(count)
    }
}

public extension Sequence {
    /// Returns whether any of a sequence pass a test
    public func any(_ test: (Iterator.Element) -> Bool) -> Bool {
        return self.map(test).contains(true)
    }
    
    /// Returns whether all of a sequence pass a test
    public func all(_ test: (Iterator.Element) -> Bool) -> Bool {
        return !self.map(test).contains(false)
    }
}

public extension Sequence {
    public func scanl<T> (initial: T, transform: (T, Iterator.Element) -> T) -> [T] {
        var accumulations:[T] = [initial]
        for elem in self {
            accumulations += [transform(accumulations.last!, elem)]
        }
        return accumulations
    }
//    public func scanl<T> (initial: T, transform: (T, Iterator.Element) -> T) -> [T] {
//        var accumulations:[T] = [initial]
//        for elem in self {
//            accumulations += [transform(accumulations.last!, elem)]
//        }
//        return accumulations
//    }
}

public extension Sequence {
    public func addMap<T> (_ transform: (Iterator.Element) -> T) -> [(Iterator.Element, T)] {
        return self.map { ($0, transform($0)) }
    }
}

public extension Sequence {
    public func allPairs<O: Sequence>(with other: O) -> [(Self.Element, O.Element)] {
        var accumulator: [(Self.Element, O.Element)] = []
        for a in self {
            for b in other {
                accumulator.append((a,b))
            }
        }
        return accumulator
    }
}

public extension Array where Element: Equatable {
    mutating func togglePresenceOf(_ element: Element) {
        if self.contains(element) {
            self = self.filter { $0 != element }
        }
        else {
            self.append(element)
        }
    }
}

public extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        self = self.filter { $0 != element }
    }
}


public extension Collection where Index == Int {
    func indexDict() -> [Index: Element] {
        var dict: [Index: Element] = [:]
        for (i, value) in enumerated() {
            dict[i] = value
        }
        return dict
    }
}

public extension Sequence where Element: Numeric {
    func deltas() -> [Element] {
        return Array(zip(self.dropFirst(), self).map { $0.0 - $0.1 })
    }
}

public extension Collection where Element: Equatable {
    func allUnique() -> Bool {
        return self.countUnique(test: { $0 == $1 }) == self.count
    }
}
