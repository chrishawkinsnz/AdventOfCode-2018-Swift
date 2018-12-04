//
//  TailoredMath.swift
//  TailoredSwift
//
//  Created by Chris Hawkins on 1/05/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

public func randomNumberBetween<T: FloatingPoint>(_ a: T, _ b: T) -> T {
    let minimum = min(a, b)
    let maximum = max(a, b)
    let range = maximum - minimum;
    let int = arc4random_uniform(UInt32.max)
    let proportion = T(int) / T(UInt32.max)
    return minimum + proportion * range
}


public extension Array {
    public func pickRandom(weightings: [Double]) -> Element? {
        assert(weightings.count == self.count, "Must have an equal number of weightings and elements")
        let totalWeight = weightings.sum()
        let guessedWeight = randomNumberBetween(0.0, totalWeight)
        var workingSum = 0.0
        for (element, weight) in zip(self, weightings) {
            workingSum += weight
            if workingSum > guessedWeight {
                return element
            }
        }
        return nil
    }
}


public extension CGFloat {
    
    public var abs: CGFloat {
        return self > 0 ? self : -self
    }
    
}
public extension SignedNumeric where Self: Comparable {
    public var directionMask: Self {
        if (self > 0) {
            return 1
        }
        else if (self < 0) {
            return -1
        }
        else {
            return 0
        }
    }
}

extension Int {
    func modulo(_ val: Int) -> Int {
        assert(val > 0)
        if (self < 0) {
            let numberWholeTimesDivisible = Int(self / val) - 1
            return self - numberWholeTimesDivisible * val
        }
        else {
            let numberWholeTimesDivisible = Int(self / val)
            return self - numberWholeTimesDivisible * val
        }
    }
}

