//
//  Day15.swift
//  2018SwiftSolutions
//
//  Created by Caleb Wilson on 25/05/2021.
//

import Foundation
import PuzzleBox
import Collections

class Day15 : PuzzleClass {
    
    func getMap() -> [String] {
        inputStringUnparsed!.components(separatedBy: "\n")
    }
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day15Input.txt")
    }
    
    func part1() {
        let (units, rounds) = battle(elfPower: 3, map: getMap())
        print(units.totalHP*rounds)
    }
    
    func part2() {
        let map = getMap()
        let elfCount = getCombatUnits(lines: map, elfPower: 3).filter { $0.unitType == .Elf }.count
        
        for elfPower in (4 ... Int.max) {
            let (finalUnits, rounds) = battle(elfPower: elfPower, map: map)
            if finalUnits.allSatisfy({ $0.unitType == .Elf }) && finalUnits.count == elfCount {
                print(finalUnits.totalHP*rounds)
                return
            }
        }
    }
    
    
    func battle(elfPower : Int, map : [String]) -> ([CombatUnit], Int) {
        var combatUnits = getCombatUnits(lines: map, elfPower: elfPower)
        var rounds = 0
        
        top: while !combatUnits.isEmpty {
            for unit in combatUnits {
                if !unit.isDead {
                    if combatUnits.enemies(of: unit).isEmpty {
                        break top
                    }
                    unit.takeTurn(map: map, combatUnits: &combatUnits)
                }
            }
            rounds += 1
            combatUnits.sort(by: { $0.position < $1.position })
        }
        
        return (combatUnits, rounds)
    }
    
}

func getCombatUnits(lines : [String], elfPower : Int) -> [CombatUnit] {
    var units = [CombatUnit]()
    
    for y in lines.indices {
        for x in 0 ..< lines[y].count {
            let current = lines[y][x]
            if current.isLetter {
                units.append(CombatUnit(x: x, y: y, character: current, elfPower: elfPower))
            }
        }
    }
    
    return units
}

enum UnitType {
    case Elf, Goblin
}

class CombatUnit {
    var health = 200
    var position : Point
    let power : Int
    let unitType : UnitType
    
    var isDead : Bool {
        health <= 0
    }

    init(x : Int, y : Int, character : Character, elfPower : Int) {
        let isGoblin = (character == "G")
        self.position = Point(x: x, y: y)
        self.unitType = isGoblin ? .Goblin : .Elf
        self.power = isGoblin ? 3 : elfPower
    }
    
    func takeTurn(map : [String], combatUnits : inout [CombatUnit]){
        if !combatUnits.enemies(of: self).containsOneInRange(to: self) {
            moveToClosestEnemy(map: map, combatUnits: combatUnits)
        }
        attack(combatUnits: &combatUnits)
        combatUnits = combatUnits.filter { !$0.isDead }
    }
        
    
    func attack(combatUnits : inout [CombatUnit]) {
        let enemiesInRange = combatUnits.enemiesInRange(to: self)
        if let oneToAttack = enemiesInRange.min(by: { $0.health < $1.health }) {
            oneToAttack.health -= power
        }
    }
    
    func moveToClosestEnemy(map : [String], combatUnits : [CombatUnit]) {
        let (enemies, friends) = combatUnits.enemiesAndFriends(of: self)
        let enemyPositions = Set(enemies.positions)
        let friendPositions = Set(friends.positions)
        
        let path = position.shortestPath(map: map, destinations: enemyPositions, blockades: friendPositions)
        
        if let nextPosition = path?.first {
            position = nextPosition
        }
    }
}


extension Point : Comparable {
    public static func < (lhs: Point, rhs: Point) -> Bool {
        (lhs.y == rhs.y) ? (lhs.x < rhs.x) : (lhs.y < rhs.y)
    }
    
    func shortestPath(map : [String],destinations : Set<Point>, blockades : Set<Point>) -> [Point]? {
        var queueOfPointsToVisit = Deque<Point>()
        queueOfPointsToVisit.append(self)
        
        var previousTo = [Point : Point]()
        var paths : [Point : [Point]] = [:]
        var shortest = Int.max
        
        while !queueOfPointsToVisit.isEmpty {
            let visitedPoint = queueOfPointsToVisit.removeFirst()
            
            if destinations.containsOneInRange(to: visitedPoint) {
                var point = visitedPoint
                var route = [Point]()
                
                while let previous = previousTo[point] {
                    route = [point] + route
                    point = previous
                }
                
                if route.count <= shortest {
                    paths[visitedPoint] = route
                    shortest = route.count
                } else {
                    break
                }
            }
            
            let neighbours = visitedPoint.getValidMoves(in: map, otherBlockades: blockades)
            
            neighbours.forEach {
                if previousTo[$0] == nil {
                    queueOfPointsToVisit.append($0)
                    previousTo[$0] = visitedPoint
                }
            }
            
        }
        
        return paths.min(by: { $0.key < $1.key })?.value
         
    }
}

extension Collection where Element == Point {
    func containsOneInRange(to other : Point) -> Bool {
        self.contains { $0.isInRange(to: other) }
    }
}


extension Collection where Element == CombatUnit {
    func enemies(of unit : CombatUnit) -> [CombatUnit] {
        self.filter { $0.unitType != unit.unitType }
    }
    
    func enemiesInRange(to unit : CombatUnit) -> [CombatUnit] {
        enemies(of: unit).filter { $0.position.isInRange(to: unit.position) }
    }
    
    func containsOneInRange(to unit : CombatUnit) -> Bool {
        positions.containsOneInRange(to: unit.position)
    }
    
    func enemiesAndFriends(of unit : CombatUnit) -> ([CombatUnit],[CombatUnit]) {
        separate(predicate: { $0.unitType != unit.unitType })
    }
    
    var totalHP : Int {
        reduce(0) { acc, next in
            acc + next.health
        }
    }
    
    var positions : [Point] {
        map(\.position)
    }
}

extension Point {
    var neighbours : [Point] {
        [down(),left(),right(),up()]
    }
        
    func getValidMoves(in map : [String], otherBlockades : Set<Point>) -> [Point] {
        neighbours.filter { $0.isValidSpot(in: map) && !otherBlockades.contains($0) }
    }
    
    func isValidSpot(in map : [String]) -> Bool {
        return map.isInBoundsOfMap(self) && map.getValue(at: self) != "#"
    }
    
    func isInRange(to other : Point) -> Bool {
        return manhattanDistance(to: other) == 1
    }
    
    func manhattanDistance(to other : Point) -> Int {
        return abs(other.x - self.x) + abs(other.y - self.y)
    }
}

extension Collection where Element == String {
    func getValue(at point : Point) -> Character {
        self[point.y as! Self.Index][point.x]
    }
}

extension Collection where Element : Collection {
    func isInBoundsOfMap(_ p : Point) -> Bool {
        self.indices.contains(p.y as! Self.Index) && (self.first?.count ?? 0) > p.x && p.x >= 0
    }
}

extension CombatUnit : CustomStringConvertible {
    var description: String {
        "\(unitType) at \(position) with hp : \(health)"
    }
}

extension Collection {
    func separate(predicate: (Iterator.Element) -> Bool) -> (matching: [Iterator.Element], notMatching: [Iterator.Element]) {
        var groups: ([Iterator.Element],[Iterator.Element]) = ([],[])
        for element in self {
            if predicate(element) {
                groups.0.append(element)
            } else {
                groups.1.append(element)
            }
        }
        return groups
    }
}


