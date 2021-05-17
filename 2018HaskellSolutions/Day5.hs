module Day5 where

import Data.Char
import Helpers

import qualified Data.IntSet as Set

day5FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day5Input.txt"

removeAllVariationsOfCharacterInString :: Char -> String -> String
removeAllVariationsOfCharacterInString letter = filter (\it -> not (it == letter || toLower it == letter))

part1GetLength :: String -> Int
part1GetLength = length . foldr step ""
  where
    step x (y:ys) | x /= y && toUpper x == toUpper y = ys
    step x ys                                        = x : ys

getShortestLengthAfterRemovingLetter :: String -> Int
getShortestLengthAfterRemovingLetter inputString = foldl (\accumulator filteringCharacter -> min accumulator $ part1GetLength $ removeAllVariationsOfCharacterInString filteringCharacter inputString) 10000 ['a'..'z']

part1 :: String -> IO ()
part1 = print . part1GetLength

part2 :: String -> IO ()
part2 = print . getShortestLengthAfterRemovingLetter

main ::IO()
main = do inputText <- readFile day5FilePath
          part2 inputText
