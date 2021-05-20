//
//  Day8.swift
//  2018SwiftSolutions
//
//  Created by Caleb Wilson on 20/05/2021.
//

import Foundation
import PuzzleBox


class Day9 {
    let amountOfPlayers = 405
    let finalMarble = 71700
    
    func part1() {
        solution(marbleFactor: 1)
    }
    
    func part2() {
        solution(marbleFactor: 100)
    }
    
    func solution(marbleFactor : Int) {
        var circle = [0,1]
        var points = generateEmptyMapOfInts(maxKey: amountOfPlayers)
        var currentIndex = 1
        var currentElf = 0
        
        for marble in 2...(finalMarble*marbleFactor) {
            currentElf = getNextElf(current: currentElf)
            
            if marble.isImportantMarble() {
                currentIndex = getIndexOfMarbleToRemoveAfterImportantIsFound(currentIndex: currentIndex, currentSize: circle.count)
                let removedValue = circle.remove(at: currentIndex)

                points[currentElf]! += removedValue + marble
            } else {
                currentIndex = getNextIndexOfMarble(currentIndex: currentIndex, currentSize: circle.count)
                circle.insert(marble, at: currentIndex)
            }
        }
        
        print(points.values.max()!)
       
    }
    
    func getNextIndexOfMarble(currentIndex : Int, currentSize : Int) -> Int {
        let desiredIndex = currentIndex + 2
        return (desiredIndex == currentSize) ? currentSize : ((desiredIndex >= currentSize) ? (desiredIndex - currentSize) : desiredIndex)
    }
    
    func getIndexOfMarbleToRemoveAfterImportantIsFound(currentIndex : Int,currentSize : Int) -> Int {
        let desiredIndex = (currentIndex - 7)
        return (desiredIndex >= 0) ? desiredIndex : (currentSize + desiredIndex)
    }
    
    func getNextElf(current : Int) -> Int {
        (current + 1) % (amountOfPlayers)
    }
    
    func generateEmptyMapOfInts(maxKey : Int) -> [Int : Int] {
        (0 ..< maxKey).reduce([Int : Int]()) { acc, next in
            var working = acc
            working[next] = 0
            return working
        }
    }
    
}

extension LinkedList {
    func circularIndex(index : Int) -> Int {
        index % size
    }
}

extension Int {
    func isImportantMarble() -> Bool {
        self % 23 == 0
    }
}

