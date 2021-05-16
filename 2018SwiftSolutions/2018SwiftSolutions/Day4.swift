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
        let commonMinute = getMostFrequentMinuteAndFrequency(guardNumber: lazyGuard)
        print(lazyGuard*commonMinute.value)
    }
    
    func part2() {
        let guardToCommonMinutePairMap = getListOfGuards().reduce([Int : (value : Int, count : Int)]()) { acc, next in
            var workingMap = acc
            workingMap[next] = getMostFrequentMinuteAndFrequency(guardNumber: next)
            return workingMap
        }
        let guardToUse = guardToCommonMinutePairMap.max { $0.value.count < $1.value.count }!
        print(guardToUse.key*guardToUse.value.value)
    }
    

    
    private func getListOfGuards() -> Set<Int> {
        var guards = Set<Int>()
        
        getInputStringsInOrder().forEach {
            let whatWouldBeGuard = $0.components(separatedBy: " ")[3]
            if whatWouldBeGuard.contains("#") {
                guards.insert(Int(whatWouldBeGuard.dropFirst())!)
            }
        }
        
        return guards
    }
    
    private func getMostFrequentMinuteAndFrequency(guardNumber : Int) -> (value : Int, count : Int) {
        let lines = getLinesOfActionInvolving(guardNumber: guardNumber)
        let timesInPairs = lines.map { String($0.components(separatedBy: " ")[1].dropLast()).toMinutesSinceZero() }.chunked(into: 2)
        var minutesSleeping = [Int]()
        
        timesInPairs.forEach {
            ($0.first! ..< $0.last!).forEach { time in
                minutesSleeping.append(time)
            }
        }
        
        return mostFrequent(array: minutesSleeping) ?? (value : -1,count : 0)
    }
    
    private func getLinesOfActionInvolving(guardNumber : Int) -> [String] {
        let stringLines = getInputStringsInOrder()
        var isGuardTheActiveOne = false
        var lines = [String]()
        
        stringLines.forEach {
            if $0.contains("#\(guardNumber)") {
                isGuardTheActiveOne = true
            } else if ($0.contains("#")) {
                isGuardTheActiveOne = false
            } else if isGuardTheActiveOne {
                lines.append($0)
            }
        }
        
        return lines
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
        if self.contains("#") {
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
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
