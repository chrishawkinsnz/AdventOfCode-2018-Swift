//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

enum EventType {
    case fallAsleep
    case wakeUp
    case startShift(Int)
}

struct Event {
    var type: EventType
    var time: SimpleDate
    
    init(string: String) {
        let dateString = String(string.dropFirst().prefix(16))
        time = SimpleDate.init(dateString: dateString)
        var type: EventType
        if string.contains("wakes") {
            type = .wakeUp
        }
        else if string.contains("falls asleep") {
            type = .fallAsleep
        }
        else {
            let guardId = string.extractInts(pattern: "Guard #INT")[0]
            type = .startShift(guardId)
        }
        self.type = type
    }
}

struct SimpleDate: Comparable, CustomDebugStringConvertible, Equatable, Hashable {
    static func < (lhs: SimpleDate, rhs: SimpleDate) -> Bool {
        if lhs.year < rhs.year      { return true }
        if lhs.year > rhs.year      { return false }
        if lhs.month < rhs.month    { return true }
        if lhs.month > rhs.month    { return false }
        if lhs.day < rhs.day        { return true }
        if lhs.day > rhs.day        { return false }
        if lhs.hour < rhs.hour      { return true }
        if lhs.hour > rhs.hour      { return false }
        if lhs.minute < rhs.minute  { return true }
        if lhs.minute > rhs.minute  { return false }
        
        return false
    }
    
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    
    init(dateString: String) {
        let ints = dateString.extractInts(pattern: "INT-INT-INT INT:INT")
        year = ints[0]
        month = ints[1]
        day = ints[2]
        hour = ints[3]
        minute = ints[4]
    }
    
    public var debugDescription: String {
        return "[\(year)-\(month)-\(day) \(hour):\(minute)]"
    }
    
    func next() -> SimpleDate {
        var copy = self
        copy.minute += 1
        if (copy.minute >= 60) {
            copy.hour += 1
            copy.minute = 0
        }
        if (copy.hour >= 24) {
            copy.day += 1
            copy.hour = 0
        }
        if copy.day > daysInMonth(month: copy.month) {
            copy.month += 1
            copy.day = 1
        }
        return copy
    }
}


func day4Part1() {
    let sleepiestGuard = sleepingStats().max(by: { $0.value.count < $1.value.count })!
    let sleepiestGuardId = sleepiestGuard.key
    let sleepiestMinutes = sleepiestGuard.value.map { $0.minute }.mostCommonElement()!

    print("\(sleepiestGuardId*sleepiestMinutes)")
}


func day4Part2() {
    struct Moment: Equatable, Hashable {
        let guardId: Int
        let minute: Int
    }
    let pairs = sleepingStats().flatMap { g in g.value.map { Moment(guardId: g.key, minute: $0.minute) }}
    
    let sleepiestMoment = pairs.mostCommonElement()!
    
    print(sleepiestMoment.guardId * sleepiestMoment.minute)
}

func sleepingStats() -> [Int: [SimpleDate]] {
    let events = day4Input.lines
        .map { Event.init(string: $0) }
        .sorted(by: \.time)
    let simulation = Simulation(events: events)
    while simulation.tick() { }
    return simulation.sleepingMinutes
}

class Simulation {
    var sleepingMinutes: [Int: [SimpleDate]] = [:]
    var activeGuard: Int! = -1
    var currentTime: SimpleDate
    var isSleeping: Bool = false
    var events: [Event]
    
    init(events: [Event]) {
        self.events = events
        self.currentTime = events.first!.time
    }
    
    func tick() -> Bool {
        if events.isEmpty {
            return false
        }
        if (currentTime.hour == 1) {
            consumeEvent()
        }
        if (events.first != nil && currentTime >= events.first!.time) {
            consumeEvent()
        }
        if isSleeping && currentTime.hour == 0{
            sleepingMinutes[activeGuard, default: []] += [currentTime]
        }
        currentTime = currentTime.next()
        
        return true
    }
    
    func consumeEvent() {
        let event = events.remove(at: 0)
        switch event.type {
        case .wakeUp:
            isSleeping = false
        case .fallAsleep:
            isSleeping = true
        case .startShift(let guardId):
            isSleeping = false
            currentTime = event.time
            activeGuard = guardId
        }
    }
    
}

func daysInMonth(month: Int) -> Int {
    let mapping: [Int: Int] = [
        1: 31,
        2: 28,
        3: 31,
        4: 30,
        5: 31,
        6: 30,
        7: 31,
        8: 31,
        9: 30,
        10: 31,
        11: 30,
        12: 31
    ]
    return mapping[month]!
}
