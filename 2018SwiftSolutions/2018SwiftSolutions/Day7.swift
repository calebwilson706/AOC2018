//
//  Day7.swift
//  2018SwiftSolutions
//
//  Created by Caleb Wilson on 18/05/2021.
//

import Foundation
import PuzzleBox

class Day7 {
    
    let input = Day7InputParser().parse()
    let firstColumn : [Character]
    let secondColumn : [Character]
    let allPrograms : Set<Character>
    
    init() {
        self.firstColumn = input.map { $0.firstStep }
        self.secondColumn = input.map { $0.nextAvailableStep }
        self.allPrograms = Set(firstColumn + secondColumn)
    }
    
    func part1() {
        let thoseToCarryOut = LinkedList(from: getFirstProgramsToCarryOut().sorted(), isSet: true)
        let mapOfPrerequisites = getAllPrerequisites()
        var order = ""

        while !thoseToCarryOut.isEmpty {
            let currentProgram = thoseToCarryOut.first!.value
            order += "\(currentProgram)"
            thoseToCarryOut.remove(at: 0)
            getNextToCarryOut(currentOrder: order, prerequisites: mapOfPrerequisites).forEach { thoseToCarryOut.appendWhenSortedList(value: $0) }
        }

        print(order)
    }
    
    func part2() {
        var programsToCompleteFirst = getAllPrerequisites()
        var elfWorkersTasks = [Int : ProgramCompletionStatus]()
        let thoseToCarryOut = LinkedList<Character>(isSet: true)
        var currentTime = -1
        
        updateMapAndListOfTasksToComplete(map: &programsToCompleteFirst, tasksToComplete: thoseToCarryOut, afterCompleting: nil)

        while (!programsToCompleteFirst.isEmpty || !elfWorkersTasks.isEmpty || !thoseToCarryOut.isEmpty) {
            for elfID in 1...5 {
                if let taskBeingCompleted = elfWorkersTasks[elfID] {
                    taskBeingCompleted.oneSecondPassed()
                    if taskBeingCompleted.isCompleted {
                        updateMapAndListOfTasksToComplete(map: &programsToCompleteFirst, tasksToComplete: thoseToCarryOut, afterCompleting: taskBeingCompleted.program)
                        elfWorkersTasks[elfID] = nil
                    }
                }
                if !thoseToCarryOut.isEmpty && elfWorkersTasks[elfID] == nil {
                    let elfNewTask = ProgramCompletionStatus(program: thoseToCarryOut.first!.value)
                    thoseToCarryOut.remove(at: 0)
                    elfWorkersTasks[elfID] = elfNewTask
                }
            }
            currentTime += 1
        }
        
        print(currentTime)
    }
    
    private func getNextToCarryOut(currentOrder : String, prerequisites : [Character : Set<Character>]) -> [Character] {
        let programsToComplete = secondColumn.filter { !currentOrder.contains($0) }
        return programsToComplete.filter { key in
            prerequisites[key]!.allSatisfy { value in
                currentOrder.contains(value)
            }
        }
    }
    
    private func getFirstProgramsToCarryOut() -> Set<Character> {
        return Set(firstColumn.filter { !secondColumn.contains($0) })
    }
    
    private func getAllPrerequisites() -> [Character : Set<Character>] {
        allPrograms.reduce([Character : Set<Character>]()) { overallAccumulator, next in
            var innerAccumulator = overallAccumulator
            innerAccumulator[next] = getPreRequisites(program: next)
            return innerAccumulator
        }
    }
    
    private func getPreRequisites(program : Character) -> Set<Character> {
        Set(input.filter { $0.nextAvailableStep == program }.map { $0.firstStep })
    }
    
    private func updateMapAndListOfTasksToComplete(map : inout [Character : Set<Character>], tasksToComplete : LinkedList<Character>, afterCompleting : Character?) {
        if let completedTask = afterCompleting {
            map = updateMapOfTasksToComplete(map: map, afterCompleting: completedTask)
        }
        let nextToComplete = map.filter { $0.value.isEmpty }
        nextToComplete.keys.forEach {
            tasksToComplete.appendWhenSortedList(value: $0)
            map.removeValue(forKey: $0)
        }
    }
    
    private func updateMapOfTasksToComplete(map : [Character : Set<Character>],afterCompleting : Character) -> [Character : Set<Character>] {
        var mutableMap = map
        map.forEach { (key, value) in
            var newValue = value
            newValue.remove(afterCompleting)
            mutableMap[key] = newValue
        }
        return mutableMap
    }
    
    class ProgramCompletionStatus {
        let program : Character
        var timeLeft : Int
        
        var isCompleted : Bool {
            timeLeft == 0
        }
        
        init(program : Character) {
            self.program = program
            self.timeLeft = 60 + Int(program.asciiValue!) - 64
        }
        
        func oneSecondPassed() {
            timeLeft -= 1
        }
    }
    
}






class Day7InputParser : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day7Input.txt")
    }
    
    func parse() -> [OrderOfOperations] {
        inputStringUnparsed!.components(separatedBy: "\n").map { line in
            let words = line.components(separatedBy: " ")
            return OrderOfOperations(firstStep: words[1][0], nextAvailableStep: words[7][0])
        }
    }
    
}

struct OrderOfOperations {
    let firstStep : Character
    let nextAvailableStep : Character
}
