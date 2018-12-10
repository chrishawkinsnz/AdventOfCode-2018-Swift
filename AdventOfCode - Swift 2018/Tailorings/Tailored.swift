//
//  Tailored.swift
//  TailoredSwift
//
//  Created by Chris Hawkins on 22/05/16.
//  Copyright © 2016 Chris Hawkins. All rights reserved.
//

import Foundation
import CoreGraphics

public func randomIntBetween(_ a:Int, _ b:Int) -> Int{
    let minimum = min(a, b)
    let maximum = max(a, b)
    let range = maximum - minimum;
    return Int(arc4random_uniform(UInt32(range))) + minimum;
}


public extension Array{
    func randomElement() -> Element? {
        let index = randomIntBetween(0, self.count)
        return self[index]
    }
}

public func + <T: RangeReplaceableCollection, U>(lhs: T, rhs: U) -> T where T.Iterator.Element == U{
    var newCollection = T.init()
    newCollection.append(contentsOf: lhs)
    newCollection.append(rhs)
    return newCollection
}

public extension Array {
    
    public func pickRandom() -> Element?{
        guard !self.isEmpty else {return nil}
        
        let idx = randomIntBetween(0, self.count)
        return self[idx]
    }
    
    public mutating func removeRandom() -> Element? {
        guard !self.isEmpty else {return nil}
        let idx = randomIntBetween(0, self.count)
        
        return self.remove(at: idx)
    }
}

public extension Array {
    private func isValidIndex(_ index: Int) -> Bool {
        return index < self.count && index >= 0
    }
    public subscript(safe index: Int) -> Element? {
        get{
            if isValidIndex(index) {
                return self[index]
            }
            else {
                return nil
            }
        }
        set {
            if let newValue = newValue, isValidIndex(index) {
                self[index] = newValue
            }
        }
    }
    
    public subscript(safe bounds: Range<Int>) -> ArraySlice<Element> {
        let lowerBound = bounds.lowerBound.clamped(startIndex, endIndex)
        let upperBound = bounds.upperBound.clamped(startIndex, endIndex)
        return self[lowerBound..<upperBound]
    }
}

public extension Sequence {
    public func findFirst(_ test: (Iterator.Element) -> Bool) -> Iterator.Element? {
        var generator = makeIterator()
        while let element = generator.next() {
            if (test(element)) {
                return element
            }
        }
        
        //--found nothing :( retur nil
        return nil
    }
    
    public func findBest<T:Comparable>(_ test: (Iterator.Element) -> T) -> Iterator.Element? {
        var generator = makeIterator()
        var bestElement: Iterator.Element?
        var bestScore:T? = nil
        while let element = generator.next() {
            let score = test(element)
            if (bestScore == nil || score > bestScore ) {
                bestScore = score
                bestElement = element
            }
        }
        
        return bestElement
    }
    
    public func findWithHighest<T:Comparable>(_ test: (Iterator.Element) -> T) -> Iterator.Element? {
        return findWithPolaritiest(test, polarityFunction: >)
    }
    
    public func findWithLowest<T:Comparable>(_ test: (Iterator.Element) -> T) -> Iterator.Element? {
        return findWithPolaritiest(test, polarityFunction: <)
    }
    
    private func findWithPolaritiest<T:Comparable>(_ test: (Iterator.Element) -> T, polarityFunction: (T, T) -> Bool) -> Iterator.Element? {
        var generator = makeIterator()
        var elementWithPolaritiest: Iterator.Element?
        var polaritiestValue:T? = nil
        while let element = generator.next() {
            let score = test(element)
            if (polaritiestValue == nil || polarityFunction(score, polaritiestValue!) ) {
                polaritiestValue = score
                elementWithPolaritiest = element
            }
        }
        
        return elementWithPolaritiest
    }

}

public extension Sequence {
    func count(where test: (Iterator.Element) -> Bool) -> Int {
        return self.filter(test).count
    }
}

public extension Sequence {
    public func unique(test: (Iterator.Element, Iterator.Element) -> Bool) -> [Iterator.Element] {
        return reduce([]) { accumulator, newElem in
            return accumulator.contains(where: { test(newElem, $0) }) ? accumulator : accumulator + [newElem]
        }
    }
    
    public func countUnique(test: (Iterator.Element, Iterator.Element) -> Bool) -> Int {
        return self.unique(test: test).count
    }
}

public extension Sequence where Iterator.Element: Equatable {
    public var unique: [Iterator.Element] {
        return self.unique(test: ==)
    }
    public var countUnique: Int {
        return self.unique(test: ==).count
    }
}

open class DefaultsProxy {
    open let object: AnyObject?
    
    public init(object: AnyObject?) {
        self.object = object
    }
    
    open lazy var string: String? = {
        return self.object as? String
    }()
    
    open lazy var int: Int? = {
        return self.object as? Int
    }()
    
    open lazy var double: Double? = {
        return self.object as? Double
    }()
    
    open lazy var float: Float? = {
        return self.object as? Float
    }()
    
    open lazy var bool: Bool? = {
        return self.object as? Bool
    }()
    
    open lazy var array: [AnyObject]? = {
        return self.object as? [AnyObject]
    }()
    
    open lazy var dictionary: [String: AnyObject]? = {
        return self.object as? [String: AnyObject]
    }()
}

public extension UserDefaults {
    public subscript(key: String) -> DefaultsProxy {
        get {
            return DefaultsProxy(object: self.object(forKey: key) as AnyObject?)
        }
    }
}

public extension UserDefaults {
    public subscript(key: String) -> Any? {
        get {
            return nil
        }
        set {
            if let string = newValue as? String {
                self.set(string, forKey: key)
            }
            else if let int = newValue as? Int {
                self.set(int, forKey: key)
            }
            else if let double = newValue as? Double {
                self.set(double, forKey: key)
            }
            else if let float = newValue as? Float {
                self.set(float, forKey: key)
            }
            else if let bool = newValue as? Bool {
                self.set(bool, forKey: key)
            }
            else if let array = newValue as? [AnyObject] {
                self.set(array, forKey: key)
            }
            else if let dictionary = newValue as? [String: AnyObject] {
                self.set(dictionary, forKey: key)
            }
        }
    }
}

public func +(left:Int, right:String) -> String{
    return String(left) + right
}

public func +(left:String, right:Int) -> String{
    return left + String(right)
}

infix operator ==== : ChrisDefaultPrecedenceGroup
infix operator ===== : ChrisDefaultPrecedenceGroup

public func =====(left: String, right: String) -> Bool {
    return left.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == right.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
}

public func +<KeyType, ValueType>(left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
    var combined: [KeyType: ValueType] = [:]
    for (key, value) in left {
        combined[key] = value
    }
    for (key, value) in right {
        combined[key] = value
    }
    
    return combined
}

public func +=<KeyType, ValueType>(left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (key, value) in right {
        left[key] = value
    }
}

public func |= (left: inout Bool, right: Bool) {
    left = left || right
}

public func &= (left: inout Bool, right: Bool) {
    left = left && right
}

public extension Date {
    public var timeSince: TimeInterval {
        return Date().timeIntervalSince(self)
    }
}

public extension Date {
    fileprivate static let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    public var day:Int {
        return component(NSCalendar.Unit.day)
    }
    
    public var month:Int {
        return component(NSCalendar.Unit.month)
    }
    
    public var year:Int {
        return component(NSCalendar.Unit.year)
    }
    
    public func component(_ unitType: NSCalendar.Unit) -> Int {
        return (Date.calendar as NSCalendar).component(unitType, from: self)
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


//MARK - UIKit stuff

public extension CGSize {
    func scaled(_ scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
    
    mutating func scale(_ scale: CGFloat) {
        self = self.scaled(scale)
    }
}

func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize.init(width: lhs.width / rhs, height: lhs.height / rhs)
}

func * (lhs: CGSize, rhs: Double) -> CGSize {
    return CGSize.init(width: lhs.width / CGFloat(rhs), height: lhs.height / CGFloat(rhs))
}

func / (lhs: CGSize, rhs: Double) -> CGSize {
    return CGSize.init(width: lhs.width / CGFloat(rhs), height: lhs.height / CGFloat(rhs))
}

func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize.init(width: lhs.width / rhs, height: lhs.height / rhs)
}

public extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - size.width / 2.0
        let originY = center.y - size.height / 2.0
        let origin = CGPoint(x: originX, y: originY)
        self.init(origin: origin, size: size)
    }
    
    public var center: CGPoint {
        let x = origin.x + width / 2.0
        let y = origin.y + height / 2.0
        return CGPoint(x: x, y: y)
    }
    
}

public extension CGPoint {
    public func shifted(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        return CGPoint(x: x + self.x , y: y + self.y)
    }
    
    public mutating func shift(x: CGFloat = 0, y: CGFloat = 0) {
        self.x += x
        self.y += y
    }
}

public func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return lhs.shifted(x: rhs.dx, y: rhs.dy)
}

public func +=(lhs: inout CGPoint, rhs: CGVector) {
    lhs.shift(x: rhs.dx, y: rhs.dy)
}

public func -(lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return lhs.shifted(x: -rhs.dx, y: -rhs.dy)
}

public func -=(lhs: inout CGPoint, rhs: CGVector) {
    lhs.shift(x: -rhs.dx, y: -rhs.dy)
}

public func +(lhs: CGPoint, rhs: (CGFloat, CGFloat)) -> CGPoint{
    return lhs.shifted(x: rhs.0, y: rhs.1)
}

public func +=(lhs: inout CGPoint, rhs: (CGFloat, CGFloat)) {
    lhs.shift(x: rhs.0, y: rhs.1)
}

public func -(lhs: CGPoint, rhs: (CGFloat, CGFloat)) -> CGPoint{
    return lhs.shifted(x: -rhs.0, y: -rhs.1)
}

public func -=(lhs: inout CGPoint, rhs: (CGFloat, CGFloat)) {
    lhs.shift(x: -rhs.0, y: -rhs.1)
}

public func +(lhs: CGPoint, rhs: (Int, Int)) -> CGPoint{
    return lhs.shifted(x: CGFloat(rhs.0), y: CGFloat(rhs.1))
}

public func +=(lhs: inout CGPoint, rhs: (Int, Int)) {
    lhs.shift(x: CGFloat(rhs.0), y: CGFloat(rhs.1))
}

public func -(lhs: CGPoint, rhs: (Int, Int)) -> CGPoint{
    return lhs.shifted(x: CGFloat(-rhs.0),y: CGFloat(-rhs.1))
}

public func -=(lhs: inout CGPoint, rhs: (Int, Int)) {
    lhs.shift(x: CGFloat(-rhs.0), y: CGFloat(-rhs.1))
}


public extension Comparable {
    public func clamped(_ bound1: Self, _ bound2: Self) -> Self{
        let upperBound = bound1 > bound2 ? bound1 : bound2
        let lowerBound = bound1 > bound2 ? bound2 : bound1
        if (self > upperBound) {
            return upperBound
        }
        if (self < lowerBound) {
            return lowerBound
        }
        return self
    }
    
    public mutating func clamp(_ bound1: Self, _ bound2: Self) {
        self = clamped(bound1, bound2)
    }
}


public extension Array {
    public func shuffled() -> [Element] {
        var copy = self
        var new = [Element]()
        while copy.count > 0 {
            let idx = randomIntBetween(0, copy.count)
            new.append(copy.remove(at: idx))
        }
        return new
    }
    
    mutating public func shuffle() {
        self = shuffled()
    }
}


public func dispatch_once_ever(key: String, action: () -> Void) {
    if UserDefaults.standard.bool(forKey: key) {
        action()
    }
    UserDefaults.standard.set(true, forKey: key)
}

precedencegroup ChrisDefaultPrecedenceGroup {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

public extension CGAffineTransform {
    public func scaledBy(_ scaling: CGVector) -> CGAffineTransform {
        return self.scaledBy(x: scaling.dx, y: scaling.dy)
    }
    
    public func translatedBy(_ translation: CGVector) -> CGAffineTransform {
        return self.translatedBy(x: translation.dx, y: translation.dy)
    }
}

public extension CGPoint {
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        let dx = lhs.x - rhs.x
        let dy = lhs.y - rhs.y
        return CGVector(dx: dx, dy: dy)
    }
}

public extension CGSize {
    public static func / (lhs: CGSize, rhs: CGSize) -> CGVector {
        let proportionalChangeWidth = lhs.width / rhs.width
        let proportionalChangeHeight = lhs.height / rhs.height
        return CGVector(dx: proportionalChangeWidth, dy: proportionalChangeHeight)
    }
}

public func not(_ test:@escaping () -> Bool) -> () -> Bool {
    return {
        !test()
    }
}

public func not<T>(_ test:@escaping (T) -> Bool) -> (T) -> Bool {
    return { parameter in
        !test(parameter)
    }
}

public func not<T, U>(_ test:@escaping (T, U) -> Bool) -> (T, U) -> Bool {
    return { parameter1, parameter2 in
        !test(parameter1, parameter2)
    }
}

public extension MutableCollection {
    mutating func replace(where test: (Iterator.Element) -> Bool, with replacement: Iterator.Element) {
        var index = self.startIndex
        while index != self.endIndex {
            if test(self[index]) {
                self[index] = replacement
                return
            }
            index = self.index(after: index)
        }
    }
}

///Indicates an instance can be identified
public protocol Identifiable {
    static func ==== (lhs: Self, rhs: Self) -> Bool
}


public extension MutableCollection where Iterator.Element: Identifiable {
    mutating func replace(with replacement: Iterator.Element) {
        var index = self.startIndex
        while index != self.endIndex {
            if replacement ==== self[index] {
                self[index] = replacement
                return
            }
            index = self.index(after: index)
        }
    }
}

public extension Bool {
    public mutating func flip() {
        self = !self
    }
}

public protocol YellableError: Error {
    var message: String { get }
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public extension Result {
    public init(object: T?, error: Error?) {
        guard error == nil else { self = .failure(error!); return }
        guard let object = object else { self = .failure(IncompleteResponseError()); return }
        self = .success(object)
    }
    
    public var value: T? {
        guard case .success(let value) = self else { return nil }
        return value
    }
    
    public var error: Error? {
        guard case .failure(let error) = self else { return nil }
        return error
    }
}

public extension Array where Element: CustomStringConvertible {
    public func listed(separator: String = ",", finalSeperator: String = "and") -> String {
        switch count {
        case 0:
            return ""
        case 1:
            return first!.description
        case 2:
            return first!.description + " \(finalSeperator) " + last!.description
        default:
            let startingElements = Array(self[startIndex..<index(before: endIndex)])
            let startingString = startingElements.map { $0.description }.joined(separator: "\(separator) ")
            return startingString + " \(finalSeperator) " + last!.description
        }
    }
}

public protocol ViewControllerType: class {
    func loadViewIfNeeded()
}

public protocol StoryboardInstantiable: ViewControllerType {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String? { get }
}

public protocol StoryboardBacked: ViewControllerType {
    associatedtype CONFIGURATION_ITEM
    static var storyboardName: String { get }
    static var storyboardIdentifier: String? { get }
    func configure(with configItem: CONFIGURATION_ITEM)
}

public extension StoryboardBacked {
    func configureWith(_ configItem: String) {}
    
    static var storyboardIdentifier: String? {
        return nil
    }
}


public func ignoringParams<T>(_ function: @escaping () -> Void) -> (T) -> Void {
    return { _ in
        function()
    }
}

public func ignoringParams<T, U>(_ function: @escaping () -> Void) -> (T, U) -> Void {
    return { _, _ in
        function()
    }
}

public func ignoringParams<T, U, V>(_ function: @escaping () -> Void) -> (T, U, V) -> Void {
    return { _, _, _ in
        function()
    }
}



public extension Array where Element: Equatable {
    var countDistinct: Int {
        var distinctValues:[Element] = []
        for value in self {
            if !distinctValues.contains(value) {
                distinctValues.append(value)
            }
        }
        return distinctValues.count
    }
}

public class IncompleteResponseError: Error {}

public extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public protocol CachedGenerator: class {
    associatedtype Key: Hashable
    associatedtype Value
    
    var generatorCache: [Key: Value] { get set }
    
    func generateValue(for key: Key) -> Value
}

public extension CachedGenerator {
    func value(for key: Key) -> Value {
        if let existingValue = generatorCache[key] {
            return existingValue
        }
        let newValue = generateValue(for: key)
        generatorCache[key] = newValue
        return newValue
    }
}

public extension Collection {
    
    public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return self.sorted(by: {
            let valueA: T = $0[keyPath: keyPath]
            let valueB: T = $1[keyPath: keyPath]
            return valueA < valueB
        })
    }
    
    public func sorted<T: Comparable>(by primaryKeyPath: KeyPath<Element, T>, then secondaryKeyPath: KeyPath<Element, T>) -> [Element] {
        return self.sorted(by: {
            let valueA: T = $0[keyPath: primaryKeyPath]
            let valueB: T = $1[keyPath: primaryKeyPath]
            if (valueA == valueB) {
                let valueA: T = $0[keyPath: secondaryKeyPath]
                let valueB: T = $1[keyPath: secondaryKeyPath]
                return valueA > valueB
            }
            return valueA > valueB
        })
    }
}
//public extension CGRect {
//    func except<T>(_ keyPath: WritableKeyPath<CGRect,T>, is value: T) -> CGRect {
//        var copy = self
//        copy[keyPath: keyPath] = value
//        return copy
//    }
//}


public func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}


extension String: LocalizedError {
    var localizedDescription: String {
        return self
    }
}

public extension Collection {
    
    func grouped<T: Comparable&Hashable>(by transform: (Element) -> T) -> [T: [Element]] {
        var accumulator: [T: [Element]] = [:]
        for value in self {
            let transformed = transform(value)
            var set = accumulator[transformed] ?? []
            set.append(value)
            accumulator[transformed] = set
        }
        return accumulator
    }
    
    func grouped<T: Comparable&Hashable>(by keyPath: KeyPath<Element, T>) -> [T: [Element]] {
        return grouped(by: { $0[keyPath: keyPath]})
    }
}

public class DefaultsToggle {
    
    public var displayName: String
    
    private var key: String
    private var defaultValue: Bool
    
    public init(key: String, displayName: String? = nil, defaultValue: Bool = false) {
        self.key = key
        self.defaultValue = defaultValue
        self.displayName = displayName ?? key
    }
    
    public var value: Bool {
        get {
            guard UserDefaults.standard.value(forKey: key) != nil else { return defaultValue }
            return UserDefaults.standard.bool(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// TODO move to main Tailored.swift repo
private var numberFormatter = NumberFormatter()
extension StringProtocol {
    var intValue: Int? {
        let sanitizedString = String(drop(while: { $0 == "+"}))
        return numberFormatter.number(from: sanitizedString)?.intValue
    }
}

public extension Collection where Index == Int {
    
    public subscript(looping position: Int) -> Element {
        get {
            return self[convert(position: position)]
        }
    }
    
    public subscript(looping range: Range<Int>) -> [Element] {
        get {
            return (range.lowerBound..<range.upperBound).map { self[looping: $0] }
        }
    }
    
    fileprivate func convert(position: Int) -> Int {
        if position < 0 {
            return position.modulo(count)
        }
        if position >= count {
            return position % count
        }
        else {
            return position
        }
    }
    
    var looping: IteratorSequence<LoopingIterator<Self>> {
        return IteratorSequence(LoopingIterator(self))
    }
}

public extension Set {
    func inserting(_ element: Element) -> Set<Element> {
        var copy = self
        copy.insert(element)
        return copy
    }
}

public struct LoopingIterator<C: Collection>: IteratorProtocol where C.Index == Int {
    public var index = 0
    
    private var underlyingCollecction: C
    
    init(_ collection: C) {
        self.underlyingCollecction = collection
    }
    
    public mutating func next() -> C.Element? {
        let element = underlyingCollecction[index]
        index += 1
        return element
    }
}

public extension MutableCollection where Index == Int {
    public subscript(looping position: Int) -> Element {
        get {
            return self[convert(position: position)]
        }
        set(newValue) {
            self[convert(position: position)] = newValue
        }
    }
    
    public subscript(looping range: Range<Int>) -> [Element] {
        get {
            return (range.lowerBound..<range.upperBound).map { self[looping: $0] }
        }
        set(newValue) {
            let range = range.relative(to: self)
            let startPos = range.lowerBound
            let endPos = range.upperBound
            
            guard (endPos - startPos) == newValue.count else { fatalError("Must replace range in a Loop with a collection of the same size") }
            
            var pos = startPos
            for element in newValue {
                self[looping:pos] = element
                pos += 1
            }
        }
    }
}

extension Collection where Element: Equatable&Hashable {
    func mostCommonElement() -> Element? {
        var counts: [Element: Int] = [:]
        for element in self {
            counts[element, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value})?.key
    }
}

