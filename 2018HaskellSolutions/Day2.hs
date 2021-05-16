module Day2 where

import Data.List
import qualified Data.IntSet as Set

day2FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day2Input.txt"

indices :: [a] -> [Int]
indices list = [0 .. length list - 1]

boolToInt :: Bool -> Int
boolToInt boolean = if boolean then 1 else 0

getListOfCharacterCounts :: String -> Set.IntSet
getListOfCharacterCounts string = Set.fromList $ map length $ group $ sort string

getIndicesOfTwoListsWhichContainTheSameValue :: Eq a => [a] -> [a] -> [Int]
getIndicesOfTwoListsWhichContainTheSameValue list1 list2 = filter (\index -> list1!!index == list2!!index) $ indices list1

updateCheckSumTotal :: (Int, Int, Set.IntSet) -> Int
updateCheckSumTotal (numberToCheckFor, currentTotal, setOfOccurences) =
    currentTotal + if numberToCheckFor`Set.member` setOfOccurences then 1 else 0

updateBothChecksumsWithNewString :: (Int,Int) -> String -> (Int,Int)
updateBothChecksumsWithNewString (twoCount, threeCount) inputString = newChecksumPair
    where frequencies = getListOfCharacterCounts inputString
          newChecksumPair = (updateCheckSumTotal(2,twoCount,frequencies),updateCheckSumTotal(3,threeCount,frequencies))

checkIfTwoStringsDifferByOneCharacter :: String -> String -> Bool
checkIfTwoStringsDifferByOneCharacter string1 string2 = amountOfDifferingCharacters == 1
    where amountOfDifferingCharacters = foldl (\accumulator index -> accumulator + boolToInt(string1!!index /= string2!!index)) 0 $ indices string1

findBoxIdPair :: (Int,Int,[String]) -> (String, String)
findBoxIdPair (currentIndex1, currentIndex2, inputStrings) = 
    if checkIfTwoStringsDifferByOneCharacter firstString secondString then (firstString,secondString) else findBoxIdPair(nextFirstIndex,nextSecondIndex,inputStrings)
       where firstString = inputStrings!!currentIndex1
             secondString = inputStrings!!currentIndex2
             nextFirstIndex = currentIndex1 + if hasLoopedAround then 1 else 0             
             nextSecondIndex = if hasLoopedAround then nextFirstIndex + 1 else desiredSecondIndex
             desiredSecondIndex = currentIndex2 + 1
             hasLoopedAround = desiredSecondIndex >= length inputStrings
             

part1 :: [String] -> IO ()
part1 inputStrings = print(twoCount*threeCount)
    where (twoCount, threeCount) = foldl updateBothChecksumsWithNewString (0,0) inputStrings

part2 :: [String] -> IO ()
part2 inputStrings = print(map (firstString!!) $ getIndicesOfTwoListsWhichContainTheSameValue firstString secondString)
    where (firstString, secondString) = findBoxIdPair(0,1,inputStrings)

main :: IO()
main = do inputText <- readFile day2FilePath
          part2 $ lines inputText