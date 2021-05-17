//
//  Day4.swift
//  2018SwiftSolutions
//
//  Created by Caleb Wilson on 16/05/2021.
//

import Foundation
import PuzzleBox

class Day4 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day4Input.txt")
    }
    
    func part1() {
        let lazyGuard = getLaziestGuard()
        let commonMinute = getMostFrequentMinuteAndFrequency(for: lazyGuard)
        print(lazyGuard*commonMinute.value)
    }
    
    func part2() {
        let linesForEachGuard = getLinesInvolvingEachGuard()
        let guardToCommonMinutePairMap = linesForEachGuard.map {
            (key: $0.key, value: getMostFrequentMinuteAndFrequency(fromLines: $0.value))
        }
        let guardToUse = guardToCommonMinutePairMap.max { $0.value.count < $1.value.count }!
        print(guardToUse.key*guardToUse.value.value)
    }
    
    private func getMostFrequentMinuteAndFrequency(for guardNumber : Int) -> (value : Int, count : Int) {
        let lines = getLinesOfActionInvolving(guardNumber: guardNumber)
        return getMostFrequentMinuteAndFrequency(fromLines : lines)
    }
    
    private func getMostFrequentMinuteAndFrequency(fromLines : [String]) -> (value : Int, count : Int) {
        let timesInPairs = fromLines.map { $0.getTimeInMinutesFromStringInput() }.chunked(into: 2)
        var minutesSleeping = [Int]()
        
        timesInPairs.forEach {
            ($0.first! ..< $0.last!).forEach { time in
                minutesSleeping.append(time)
            }
        }
        
        return mostFrequent(array: minutesSleeping) ?? (value : -1,count : 0)
    }
    
    
    private func getLinesOfActionInvolving(guardNumber : Int) -> [String] {
        return getLinesInvolvingEachGuard()[guardNumber] ?? []
    }
    
    private func getLinesInvolvingEachGuard() -> [Int : [String]] {
        let stringLines = getInputStringsInOrder()
        var activeGuard = 0
        var result = [Int : [String]]()
        
        stringLines.forEach {
            if $0.isInstructionGuardStartingShift() {
                activeGuard = $0.getGuardNumberFromShiftStartingString()
            } else {
                let existingList = result[activeGuard] ?? []
                result[activeGuard] = existingList + [$0]
            }
        }

        return result
    }
    
    private func getLaziestGuard() -> Int {
        let events = getGuardEvents()
        var timeSpentSleeping : [Int : Int] = [:]
        var currentGuardNumber = 0
        var dateWhenCurrentGuardStartedSleeping = Date()
        
        events.forEach {
            switch $0.guardAction {
            case .beginsShift(guardNumber: let guardNumber):
                currentGuardNumber = guardNumber
            case .wakesUp:
                let timeElapsedSinceSleep = $0.date - dateWhenCurrentGuardStartedSleeping
                timeSpentSleeping[currentGuardNumber] = (timeSpentSleeping[currentGuardNumber] ?? 0) + Int(timeElapsedSinceSleep)
            case .sleeps:
                dateWhenCurrentGuardStartedSleeping = $0.date
            }
        }
        
        let lazyGuard = timeSpentSleeping.max { $1.value > $0.value }!.key
        return lazyGuard
    }

    private func getInputStringsInOrder() -> [String] {
        inputStringUnparsed!.components(separatedBy: "\n").sorted()
    }
    
    private func getGuardEvents() -> [GuardEvent] {
        getInputStringsInOrder().map { GuardEvent(inputString: $0) }
    }

}

enum GuardActions {
    case beginsShift(guardNumber : Int),
         wakesUp,
         sleeps
}

struct GuardEvent {
    let date : Date
    let guardAction : GuardActions

    init(inputString : String) {
        let components = inputString.components(separatedBy: "] ")
        let datePart = String(components.first!.dropFirst())
        
        self.date = datePart.toDateWithDay4Format()
        self.guardAction = components.last!.getGuardAction()
    }

}

private extension String {
    func toDateWithDay4Format() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: self)!.addingTimeInterval(-75)
    }
    
    func getGuardAction() -> GuardActions {
        if self.isInstructionGuardStartingShift() {
            let guardNumber = Int(self.filter { $0.isNumber })!
            return .beginsShift(guardNumber: guardNumber)
        }
        return self.contains("asleep") ? .sleeps : .wakesUp
    }
    
    func toMinutesSinceZero() -> Int {
        let parts = self.components(separatedBy: ":")
        let hours = Int(parts.first!)!
        let minutes = Int(parts.last!)!
        
        return hours*60 + minutes
    }
    
    func getGuardNumberFromShiftStartingString() -> Int {
        Int(self.components(separatedBy: " ")[3].dropFirst())!
    }
    
    func getTimeInMinutesFromStringInput() -> Int {
        String(self.components(separatedBy: " ")[1].dropLast()).toMinutesSinceZero()
    }
    
    func isInstructionGuardStartingShift() -> Bool {
        self.contains("#")
    }
    
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
