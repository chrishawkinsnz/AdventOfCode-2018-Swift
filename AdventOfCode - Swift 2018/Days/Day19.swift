//
//  Day1.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 3/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

func day19Part1() {
    print(runSimulation(program: day19Input, instructionRegister: day19InstructionRegister, initialRegisters: [0,0,0,0,0,0]))
}

func day19Part2() {
//    print(runSimulation(program: day19Input, instructionRegister: day19InstructionRegister, initialRegisters: [0,0,0,0,0,0]))
    
    let r2 = 10551277 // The state of r2 on entering the loop phase
    
    let result = (1...r2)
        .filter ({ r2 % $0 == 0})
        .reduce(0, +)
    
    print(result)

}

private func runSimulation(program: String, instructionRegister: Int, initialRegisters: [Int]) -> Int {
    let instructions = program.lines.map(parseInstruction)
    var registers = initialRegisters
    var instructionPointer = 0
    var iterations: Int = 0
    while instructionRegister >= 0 && instructionPointer < instructions.count {
        if instructionPointer == 1 {
            print(registers[2]) // The number part 2 wants to find the factors of (10551277)
        }
        iterations += 1
        print("line \(instructionPointer + 1)")
        registers[instructionRegister] = instructionPointer
        registers = instructions[instructionPointer].execute(registers: registers)
        instructionPointer = registers[instructionRegister] + 1
    }
    return registers[0]
}

func parseInstruction(_ string: String) -> Operation {
    let components = string.components(separatedBy: .whitespacesAndNewlines)
    return Operation(
        opCode: OpCode(rawValue: components[0])!,
        a: components[1].intValue!,
        b: components[2].intValue!,
        c: components[3].intValue!
    )
}
