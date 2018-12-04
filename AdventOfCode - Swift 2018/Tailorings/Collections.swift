//
//  Collections.swift
//  TailoredSwift
//
//  Created by Chris Hawkins on 29/03/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

public struct SortedArray <T>: Collection {
    fileprivate var values: [T]
    fileprivate var sortingFunction: (T, T) -> Bool
    
    public init(sortBy: @escaping (T, T) -> Bool) {
        self.values = []
        self.sortingFunction = sortBy
    }
    
    public init<COL: Collection>(initialValues: COL, sortBy: @escaping  (T, T) -> Bool) where COL.Iterator.Element == T {
        self.values = initialValues.sorted(by: sortBy)
        self.sortingFunction = sortBy
    }
    
    public mutating func add(_ element: T) {
        func searchBetween(lowerBound: Int, upperBound:Int) -> Int {
            if (lowerBound == upperBound) {
                return lowerBound
            }
            
            let midPoint = (lowerBound + upperBound) / 2
            let midElement = values[midPoint]
            print(midElement)
            let isBefore = sortingFunction(element, midElement)
            if (isBefore) {
                return searchBetween(lowerBound: lowerBound, upperBound: midPoint)
            }
            else {
                if midPoint == (upperBound - 1) {
                    return upperBound
                }
                return searchBetween(lowerBound: midPoint, upperBound: upperBound)
            }
        }
        
        let index = searchBetween(lowerBound: 0, upperBound: values.count)
        values.insert(element, at: index)
    }
    
    
    public mutating func add<COL: Collection>(_ elements: COL) where COL.Iterator.Element == T{
        self = self.adding(elements)
    }
    
    public func adding(_ element: T) -> SortedArray<T> {
        var copy = self
        copy.add(element)
        return copy
    }
    
    public func adding<COL: Collection>(_ elements: COL) -> SortedArray<T> where COL.Iterator.Element == T{
        var copy = self
        for element in elements {
            copy.add(element)
        }
        return copy
    }
    
    public func removing(at index: Int) -> SortedArray<T> {
        var copy = self
        copy.remove(at: index)
        return copy
    }
    
    public mutating func remove(at index: Int) {
        self.values.remove(at: index)
    }
    
    public mutating func removeAll() {
        self.values.removeAll()
    }
    
    public func removingAll() -> SortedArray<T> {
        var copy = self
        copy.removeAll()
        return copy
    }
    
    public mutating func setValues<COL: Collection>(values: COL) where COL.Iterator.Element == T {
        self.values = Array(values).sorted(by: sortingFunction)
    }
    
    public func settingValues<COL: Collection>(values: COL) -> SortedArray<T> where COL.Iterator.Element == T {
        var copy = self
        copy.setValues(values: values)
        return copy
    }

    //--forward to array
    public var startIndex: Int {
        return values.startIndex
    }
    
    public var endIndex: Int {
        return values.endIndex
    }
    
    public subscript(index: Int) -> T {
        return values[index]
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
}

public extension SortedArray where Iterator.Element: Comparable {
    public init<COL: Collection>(initialValues: COL) where COL.Iterator.Element == SortedArray.Iterator.Element {
        self.values = Array(initialValues)
        self.sortingFunction = { $0 < $1 }
    }
}

public struct SortedSet<T>: Collection where T: Comparable {
    private var values: SortedArray<T>
    
    public init() {
        values = SortedArray(sortBy: { $0 < $1 })
    }
    
    public init<COL: Collection>(initialValues: COL) where COL.Iterator.Element == T {
        //purge dupes
        var values = initialValues.sorted()
        
        var idx = 0
        while idx < values.count {
            let value = values[idx]
            if let previous = values[safe: idx - 1], previous == value {
                values.remove(at: idx)
            }
            else {
                idx += 1;
            }
        }
        var sortedArray = SortedArray<T>(sortBy: { $0 < $1 })
        sortedArray.values = values
        self.values = sortedArray
    }
    
    //--forward to array
    public var startIndex: Int {
        return values.startIndex
    }
    
    public var endIndex: Int {
        return values.endIndex
    }
    
    public subscript(index: Int) -> T {
        return values[index]
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public mutating func add(_ value: T) {
        if !(values.contains(value)) {
            values.add(value)
        }
    }
}
