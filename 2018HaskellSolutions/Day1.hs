module Day1 where

import qualified Data.IntSet as Set

day1FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day1Input.txt"

getIntegerListFromStringList :: [String] -> [Int]
getIntegerListFromStringList = map read

getCircularIndex :: [a] -> Int -> Int
getCircularIndex list index = rem index (length list)

part1 :: [String] -> IO()
part1 inputLines = print $ sum $ getIntegerListFromStringList inputLines

part2 :: [String] -> IO()
part2 inputLines = print(getFirstRepeatedFrequency(getIntegerListFromStringList inputLines, 0, Set.fromList [],0))


getFirstRepeatedFrequency :: ([Int], Int, Set.IntSet, Int) -> Int
getFirstRepeatedFrequency (offsets, currentIndex, visitedFrequencies, currentFrequency) =
    if currentFrequency `Set.member` visitedFrequencies then currentFrequency else getFirstRepeatedFrequency(offsets,nextindex,updatedSet,updatedCurrentFrequency)
       where nextindex = getCircularIndex offsets (currentIndex + 1)
             updatedSet = Set.insert currentFrequency visitedFrequencies
             updatedCurrentFrequency = currentFrequency + offsets!!currentIndex

main :: IO()
main = do inputText <- readFile day1FilePath
          part2 $ lines $ filter (/='+') inputText