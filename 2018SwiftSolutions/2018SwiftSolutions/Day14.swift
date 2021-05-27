//
//  Day14.swift
//  2018SwiftSolutions
//
//  Created by Caleb Wilson on 24/05/2021.
//

import Foundation


class Day14 {
    let puzzleInput = 880751
    let puzzleDigits = [8,8,0,7,5,1]
    
    func part1() {
        print(getRecipeList(completionPredicate: part1Predicate).dropFirst(puzzleInput))
    }
    
    func part2() {
        print(getRecipeList(completionPredicate: part2Predicate).count - 7)
    }
    
    func getRecipeList(completionPredicate : (RecipeList) -> Bool) -> [Int] {
        var recipeList = RecipeList(recipes: [3,7])
        var elf1 = 0
        var elf2 = 1
        
        while (!completionPredicate(recipeList)) {
            let elf1Value = recipeList[elf1]
            let elf2Value = recipeList[elf2]
            let newScores = getNewScoresToAdd(elf1Value: elf1Value, elf2Value: elf2Value)
            
            recipeList.updateRecipes(newValues: newScores)
            
            elf1 = updateIndex(currentIndex: elf1, currentValue: elf1Value, listLength: recipeList.count)
            elf2 = updateIndex(currentIndex: elf2, currentValue: elf2Value, listLength: recipeList.count)
        }
        
        return recipeList.recipes
    }
    
    
    
    struct RecipeList {
        var recipes : [Int]
        
        var count : Int {
            recipes.count
        }
        
        mutating func updateRecipes(newValues : [Int]) {
            recipes.append(contentsOf: newValues)
        }
        
        subscript(index : Int) -> Int {
            recipes[index]
        }
        
        func dropFirst(_ k : Int) -> ArraySlice<Int> {
            recipes.dropFirst(k)
        }
    }
    
    func updateIndex(currentIndex : Int, currentValue : Int, listLength : Int) -> Int {
        (currentIndex + currentValue + 1) % listLength
    }
    
    func part1Predicate(recipes : RecipeList) -> Bool {
        recipes.count >= (puzzleInput + 10)
    }
    
    func part2Predicate(recipes : RecipeList) -> Bool {
        let sequenceToCheck = recipes.recipes.suffix(7)
        return Array(sequenceToCheck.dropFirst()) == puzzleDigits || Array(sequenceToCheck.dropLast()) == puzzleDigits
    }
    
    func getNewScoresToAdd(elf1Value : Int, elf2Value : Int) -> [Int] {
        (elf1Value + elf2Value).unitsAndTens
    }
}

extension Int {
    var unitsAndTens : [Int] {
        let tens = self / 10
        return (tens != 0 ? [tens] : []) + [self % 10]
    }
}

extension Collection {
    func getString() -> String {
        reduce("") { acc, next in
            acc + "\(next)"
        }
    }
}
