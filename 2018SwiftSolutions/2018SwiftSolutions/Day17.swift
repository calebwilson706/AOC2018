//
//  Day17.swift
//  2018SwiftSolutions
//
//  Created by Caleb Wilson on 05/07/2021.
//

import Foundation
import PuzzleBox

class Day17 {
    
    let inputParser = Day17StartMap()
    
    func part1() {
        solution(inputParser: self.inputParser) {
            $0.value.isWater
        }
    }
    
    func part2() {
        solution(inputParser: self.inputParser) {
            $0.value == .SETTLED_WATER
        }
    }
    
    func getFilledMap(inputParser : Day17StartMap) -> [Point : BlockStatus] {
        var map = inputParser.map
        let source = Point(x:500,y:0)
        let lowestY = inputParser.minY
        let highestY = inputParser.maxY
        
        fill(start: source, grid: &map)
        map = map.filter { $0.key.y >= lowestY && $0.key.y <= highestY}
        
        return map
    }
    
    func solution(inputParser : Day17StartMap, predicate : ((key: Point, value: BlockStatus)) -> Bool ) {
        let map = getFilledMap(inputParser: inputParser)
        print(map.filter(predicate).count)
    }
    
    func fill(start : Point, grid : inout [Point : BlockStatus]) {
         
        let belowCoord = start.up()
        
        if grid[belowCoord] == nil || grid[start] == nil {
            return
        }
        
        if grid[belowCoord] == .EMPTY {
            grid[belowCoord] = .UNSETTLED_WATER
            fill(start: belowCoord, grid: &grid)
        }
        
        if grid[belowCoord]!.isSolid && grid[start.right()] == .EMPTY {
            grid[start.right()] = .UNSETTLED_WATER
            fill(start: start.right(), grid: &grid)
        }
        
        if grid[belowCoord]!.isSolid && grid[start.left()] == .EMPTY {
            grid[start.left()] = .UNSETTLED_WATER
            fill(start: start.left(), grid: &grid)
        }
        
        if hasBothWalls(start: start, grid: grid) {
            fillLevel(start: start, grid: &grid)
        }
    }
    
    func hasBothWalls(start : Point, grid : [Point : BlockStatus]) -> Bool {
        [-1,1].allSatisfy { hasWall(x: start.x, y: start.y, grid: grid, offset: $0) }
    }
    
    func hasWall(x : Int, y : Int, grid : [Point : BlockStatus], offset : Int) -> Bool {
        var currentX = x
        
        while true {
            let p = Point(x : currentX,y: y)
            if grid[p] == .EMPTY || grid[p] == nil {
                return false
            }
            if grid[p] == .CLAY {
                return true
            }
            currentX += offset
        }
    }
    
    func fillLevel(start : Point, grid : inout [Point : BlockStatus]) {
        [-1,1].forEach { fillSide(x: start.x, y: start.y, grid: &grid, offset: $0) }
    }
    
    func fillSide(x : Int, y : Int, grid : inout [Point : BlockStatus], offset : Int) {
        var currentX = x
        
        while true {
            let p = Point(x : currentX,y: y)
            
            if (grid[p] == .CLAY) {
                return
            }
            
            if (grid[p.up()] == .UNSETTLED_WATER) {
                return
            }
            
            grid[p] = .SETTLED_WATER
            currentX += offset
        }
    }
    
}

class Day17StartMap : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day17Input.txt")
    }
    
    var clays : [ClayRange] {
        inputStringUnparsed!.components(separatedBy: .newlines).map { ClayRange($0) }
    }
    
    var maxX : Int {
        clays.map(\.xRange).maxNumber + 1
    }
    
    var minX : Int {
        clays.map(\.xRange).minNumber - 1
    }
    
    var maxY : Int {
        clays.map(\.yRange).maxNumber
    }
    
    var minY : Int {
        clays.map(\.yRange).minNumber
    }
    
    var map : [Point : BlockStatus] {
        var map = [Point : BlockStatus]()
        
        (minX...maxX).forEach { x in
            (0...maxY).forEach { y in
                map[Point(x: x,y: y)] = .EMPTY
            }
        }
        
        clays.forEach { clay in
            clay.xRange.forEach { x in
                clay.yRange.forEach { y in
                    map[Point(x: x,y: y)] = .CLAY
                }
            }
        }

        return map
    }
}

func mapAsString(map : [Point : BlockStatus]) -> String {
    var mapString = ""
    let dictionary = map
    
    let xs = dictionary.keys.map(\.x)
    let ys = dictionary.keys.map(\.y)
    
    let minX = xs.min()!
    let maxX = xs.max()!
    
        (ys.min()!...ys.max()!).forEach { y in
        (minX...maxX).forEach { x in
            switch dictionary[Point(x: x,y: y)]! {
            
            case .SETTLED_WATER:
                mapString += "~"
            case .CLAY:
                mapString += "#"
            case .EMPTY:
                mapString += "."
            case .UNSETTLED_WATER:
                mapString += "|"
            }
        }
        
        mapString += "\n"
    }
    
    return mapString
}

enum BlockStatus {
    case SETTLED_WATER,UNSETTLED_WATER,CLAY,EMPTY
    
    var isSolid : Bool {
        self == .SETTLED_WATER || self == .CLAY
    }
    
    var isWater : Bool {
        self == .SETTLED_WATER || self == .UNSETTLED_WATER
    }
}

struct ClayRange {
    let xRange : ClosedRange<Int>
    let yRange : ClosedRange<Int>
    
    init(_ string : String) {
        let parts = string.components(separatedBy: ", ")
        
        let rangeAtEndParts = parts.last!.dropFirst(2).components(separatedBy: "..").map { Int($0)! }
        let isXFirst = string.first! == "x"
        
        let individualNumber = Int(parts.first!.filter(\.isNumber))!
        
        let individualNumberAsRange = individualNumber...individualNumber
        let range = rangeAtEndParts.first!...rangeAtEndParts.last!
       
        
        
        self.xRange = isXFirst ? individualNumberAsRange : range
        self.yRange = !isXFirst ? individualNumberAsRange : range
    }
}

extension Collection where Element == ClosedRange<Int> {
    var maxNumber : Int {
        map(\.upperBound).max()!
    }
    var minNumber : Int {
        map(\.lowerBound).min()!
    }
}




