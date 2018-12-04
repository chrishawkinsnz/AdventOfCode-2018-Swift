//
//  TailoredDispatch.swift
//  TailoredSwift
//
//  Created by Chris Hawkins on 1/05/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

public func doAfterSeconds(_ seconds:Double, onMainThread: Bool = true, action: @escaping () -> Void ) {
    let when = DispatchTime.now() + Double(Int64(seconds * double_t(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    let queue = onMainThread ? DispatchQueue.main : DispatchQueue.global(qos: .default)
    queue.asyncAfter(deadline: when) {
        if (onMainThread) {
            DispatchQueue.main.async(execute: {
                action()
            })
        }
        else {
            action()
        }
    }
}

public func doMain(_ executable: @escaping () -> Void) {
    DispatchQueue.main.async(execute: executable)
}

public func doBackground(_ executable: @escaping () -> Void) {
    DispatchQueue.global(qos: .default).async(execute: executable);
}

public func executeAndTime(_ withName:String = "unnamed function", executable:()->Void) {
    let startDate = Date()
    
    executable()
    
    let endDate = Date()
    let timeToReadData = endDate.timeIntervalSince(startDate)
    print ("time to execute \"\(withName)\": \(timeToReadData)")
}
