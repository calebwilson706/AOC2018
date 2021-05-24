module Day14 where

import Helpers

import qualified Data.Sequence as DS

startList = [3,7]

puzzleInput = 880751

puzzleInputDigits :: DS.Seq Int
puzzleInputDigits = DS.fromList [8,8,0,7,5,1]

updateRecipeList :: Int -> Int -> DS.Seq Int -> DS.Seq Int
updateRecipeList x1 x2 xs = foldl (DS.|>) xs (digits $ x1 + x2)

getNextIndex :: Int -> Int -> Int -> Int
getNextIndex currentIndex currentValue = rem (currentIndex + currentValue + 1)

part1Predicate :: DS.Seq Int -> Bool
part1Predicate sequence = DS.length sequence >= (puzzleInput + 10)

part2Predicate :: DS.Seq Int -> Bool
part2Predicate sequence = x || y
    where x = DS.drop 1 lastSeven == puzzleInputDigits
          y = DS.take 6 lastSeven == puzzleInputDigits
          lastSeven = DS.drop (DS.length sequence - 7) sequence

getRecipeListHelper ::  (DS.Seq Int -> Bool) -> DS.Seq Int -> (Int, Int) -> DS.Seq Int
getRecipeListHelper predicate currentList (elf1, elf2) = result
    where first = currentList `DS.index` elf1
          second = currentList `DS.index` elf2
          newList = updateRecipeList first second currentList
          lengthOfNewList = length newList
          elf1New = getNextIndex elf1 first lengthOfNewList
          elf2New = getNextIndex elf2 second lengthOfNewList
          nextCall = getRecipeListHelper predicate newList (elf1New,elf2New)

          result
            | predicate newList = newList
            | otherwise = nextCall

getRecipeList :: (DS.Seq Int -> Bool) -> DS.Seq Int
getRecipeList predicate = getRecipeListHelper predicate (DS.fromList startList) (0,1)

part1 :: IO ()
part1 = print $ DS.drop puzzleInput $ getRecipeList part1Predicate

part2 :: IO ()
part2 = print $ DS.length (getRecipeList part2Predicate) - 7

main :: IO()
main = part2