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
    print(runSimulation(program: day19Input, instructionRegister: day19InstructionRegister, initialRegisters: [1,0,0,0,0,0]))
}

private func runSimulation(program: String, instructionRegister: Int, initialRegisters: [Int]) -> Int {
    let instructions = program.lines.map(parseInstruction)
    var registers = initialRegisters
    var instructionPointer = 0
    var iterations: Int = 0
    var history: [([Int], Operation)] = []
    while instructionRegister >= 0 && instructionPointer < instructions.count {
        iterations += 1
//        printEvery(nTimes: 1000, output: "\(iterations)")
        print("line \(instructionPointer + 1)")
        registers[instructionRegister] = instructionPointer
        registers = instructions[instructionPointer].execute(registers: registers)
        instructionPointer = registers[instructionRegister] + 1
        if iterations > 100 {
            fatalError()
        }
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
