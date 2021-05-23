//
//  Day13.swift
//  2018SwiftSolutions
//
//  Created by Caleb Wilson on 23/05/2021.
//

import Foundation
import PuzzleBox

class Day13 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day13Input.txt")
    }
    
    func getGrid() -> [String] {
        inputStringUnparsed!.components(separatedBy: "\n")
    }
    
    func getCarts(in grid : [String]) -> [Cart] {
        var result = [Cart]()
        
        for y in 0 ..< grid.count {
            for x in 0 ..< grid[y].count {
                let characterAtPoint = grid[y][x]
                
                if characterAtPoint.isCart {
                    result.append(Cart(cartCharacter: characterAtPoint, point: Point(x: x,y: y)))
                } else {
                    print(characterAtPoint)
                }
            }
        }
        
        return result
    }
    
    func part1() {
        let grid = getGrid()
        let carts = getCarts(in: grid)
        
        while (!carts.containsDuplicates) {
            carts.forEach {
                $0.makeMove(grid: grid)
            }
        }
        
        print(carts.getDuplicatePoints())
        
    }
    
    func part2() {
        let grid = getGrid()
        var carts = getCarts(in: grid)
        while (carts.count > 1) {
            carts.forEach {
                $0.makeMove(grid: grid)
            }
            
            let duplicatePoints = carts.getDuplicatePoints()
            carts = carts.filter {
                !duplicatePoints.contains($0.currentPoint)
            }
        }
        print(carts.first!.currentPoint)
    }
}


class Cart {
    var currentPoint : Point
    var currentDirection : Directions
    var latestTurn = Turns.RIGHT
    
    
    init(cartCharacter : Character,point : Point) {
        self.currentPoint = point
        self.currentDirection = cartCharacter.getDirectionOfCart()
    }
    
    func makeMove(grid : [String]) {
        moveForward()
        updateDirection(currentCharacter: grid[currentPoint.y][currentPoint.x])
    }
    
    private func updateDirection(currentCharacter : Character) {
        if currentCharacter == "+" {
            latestTurn = latestTurn.getNextTurn()
            currentDirection = latestTurn.makeTurn(currentDirection: currentDirection)
        } else if currentCharacter.isBoundary {
            currentDirection = currentDirection.getNewDirectionAtCorner(character: currentCharacter)
        }
    }
    
    private func moveForward() {
        currentPoint.move(direction: currentDirection)
    }
    
    
    
}

extension Collection where Element : Cart  {
    func getDuplicatePoints() -> Dictionary<Point, [Self.Element]>.Keys {
        Dictionary(grouping: self, by: {$0.currentPoint}).filter { $1.count > 1 }.keys
    }
    var containsDuplicates : Bool {
        Dictionary(grouping: self, by: {$0.currentPoint}).contains { $1.count > 1 }
    }
}

extension Point {
    mutating func move(direction : Directions) {
        switch direction {
        case .NORTH:
            y = y - 1
        case .EAST:
            x = x + 1
        case .SOUTH:
            y = y + 1
        case .WEST:
            x = x - 1
        }
    }
}

extension Character {
    func getDirectionOfCart() -> Directions {
        switch self {
        case ">" :
            return .EAST
        case "<" :
            return .WEST
        case "v":
            return .SOUTH
        default:
            return .NORTH
        }
    }
    
    var isCart : Bool {
        ["<",">","v","^"].contains(self)
    }
    
    var isBoundary : Bool {
        self == "\\" || self == "/"
    }
}

extension Directions {
    func getNewDirectionAtCorner(character : Character) -> Directions {
        if (character ==  "\\") {
            switch self {
            case .NORTH,.SOUTH:
                return self.turnLeft()
            case .EAST, .WEST:
                return self.turnRight()
            }
           
        }
        
        if (character == "/") {
            switch self {
            case .NORTH,.SOUTH:
                return self.turnRight()
            case .EAST, .WEST:
                return self.turnLeft()
            }
        }
        
        return self
    }
}

enum Turns {
    case LEFT,RIGHT,STRAIGHT
    
    func getNextTurn() -> Turns {
        switch self {
        case .LEFT:
            return .STRAIGHT
        case .RIGHT:
            return .LEFT
        case .STRAIGHT:
            return .RIGHT
        }
    }
    
    func makeTurn(currentDirection : Directions) -> Directions {
        switch self {
        case .LEFT:
            return currentDirection.turnLeft()
        case .RIGHT:
            return currentDirection.turnRight()
        case .STRAIGHT:
            return currentDirection
        }
    }
}
