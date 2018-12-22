//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

typealias Registers = [Int]

func day16Part1() {
    let blocks = day16BlockInput
        .components(separatedBy: "\n\n")
        .map(ExampleBlock.init)
    let jumboBlocks = blocks.count(where: { block in
        let matches = OpCode.allCases.filter { code in
            let operation = Operation(opCode: code, a: block.opNumbers[1], b: block.opNumbers[2], c: block.opNumbers[3])
            return block.registersAfter == operation.execute(registers: block.registersBefore)
        }
        return matches.count >= 3
        
    })
    print(jumboBlocks)
}

func day16Part2() {
    let examples = day16BlockInput
        .components(separatedBy: "\n\n")
        .map(ExampleBlock.init)

    var possibilities: [Int: [OpCode]] = [:]
    var certainties: [Int: OpCode] = [:]
    for code in 0...15 {
        let relevantExamples = examples.filter { $0.opNumbers.first! == code }
        let possibleCodes = relevantExamples.map { block in
            return OpCode.allCases.filter { possibleOpCode in
                let operation = Operation(opCode: possibleOpCode, a: block.opNumbers[1], b: block.opNumbers[2], c: block.opNumbers[3])
                return block.registersAfter == operation.execute(registers: block.registersBefore)
            }
        }
        possibilities[code] = possibleCodes[0].filter { code in possibleCodes.all{ $0.contains(code) } }
    }
    
    while certainties.keys.count != 16 {
        for key in possibilities.keys {
            let options: [OpCode] = possibilities[key]!.filter { !certainties.values.contains($0) }
            if options.count == 1 {
                certainties[key] = options[0]
                possibilities.removeValue(forKey: key)
            }
        }
    }
    print(certainties)

    var statements = day16InputProgram.lines.map { Operation.init(string: $0, codeMapping: certainties) }
    var registers = [0,0,0,0]
    while !statements.isEmpty {
        let statement = statements.remove(at: 0)
        registers = statement.execute(registers: registers)
    }

    print(registers[0])
}


struct ExampleBlock {
    let registersBefore: Registers
    let registersAfter: Registers
    let opNumbers: [Int]
    
    init(_ string: String) {
        registersBefore = string.lines[0].extractInts(pattern: "Before: \\[INT, INT, INT, INT\\]")
        opNumbers = string.lines[1].extractInts(pattern: "INT INT INT INT")
        registersAfter = string.lines[2].extractInts(pattern: "After:  \\[INT, INT, INT, INT\\]")
    }
}

enum ValueType {
    case immediate
    case register
    
    func value(_ number: Int, registers: [Int]) -> Int {
        switch self {
        case .immediate:
            return number
        case .register:
            return registers[number]
        }
    }
}

struct Operation {
    var opCode: OpCode
    private var a: Int
    private var b: Int
    private var c: Int
    
    init(string: String, codeMapping: [Int: OpCode]) {
        let opNumbers = string.extractInts(pattern: "INT INT INT INT")
        self.opCode = codeMapping[opNumbers[0]]!
        self.a = opNumbers[1]
        self.b = opNumbers[2]
        self.c = opNumbers[3]
    }
    
    init(opCode: OpCode, a: Int, b: Int, c: Int) {
        self.opCode = opCode
        self.a = a
        self.b = b
        self.c = c
    }
    
    func execute(registers input: [Int]) -> [Int] {
        var registers = input
        var a: Int { return opCode.aType.value(self.a, registers: registers) }
        var b: Int { return opCode.bType.value(self.b, registers: registers) }
        func setValue(_ value: Int) {
//            if opCode.baseType == .set {
//                print("C = \(a)")
//            }
//            else {
//                print("\(value) = \(a) \(symbol) \(b)")
//            }
            registers[c] = value
        }
        
        switch opCode.baseType {
        case .add:
            setValue(a &+ b)
        case .mul:
            setValue((a &* b))
        case .ban:
            setValue(a & b)
        case .bor:
            setValue(a | b)
        case .set:
            setValue(a)
        case .gt:
            setValue(a > b ? 1 : 0)
        case .eq:
            setValue(a == b ? 1 : 0)
        }
        return registers
    }
    
    var symbol: String {
        switch opCode.baseType {
        case .add: return "+"
        case .mul: return "*"
        case .ban: return "&"
        case .bor: return "|"
        case .set: return "<="
        case .gt: return ">"
        case .eq: return "=="
        }
    }
}

enum OpCode: String, CaseIterable {
    case addr
    case addi
    
    case mulr
    case muli
    
    case banr
    case bani
    
    case borr
    case bori
    
    case setr
    case seti
    
    case gtir
    case gtri
    case gtrr
    
    case eqir
    case eqri
    case eqrr
    
    enum BaseType {
        case add
        case mul
        case ban
        case bor
        case set
        case gt
        case eq
    }
    
    var baseType: BaseType {
        switch self {
        case .addr, .addi: return .add
        case .muli, .mulr: return .mul
        case .banr, .bani: return .ban
        case .bori, .borr: return .bor
        case .setr, .seti: return .set
        case .gtir, .gtri, .gtrr: return .gt
        case .eqir, .eqri, .eqrr: return .eq
        }
    }
    
    var bType: ValueType {
        switch self {
        case .addi, .muli, .bani, .bori: return .immediate
        case .addr, .mulr, .banr, .borr: return .register
        case .eqir, .eqrr, .gtir, .gtrr: return .register
        case .eqri, .gtri: return .immediate
        case .setr, .seti: fatalError()
        }
    }
    
    var aType: ValueType {
        switch self {
        case .gtir, .eqir, .seti: return .immediate
        default: return .register
        }
    }
    
    var cType: ValueType {
        return .register
    }
}
