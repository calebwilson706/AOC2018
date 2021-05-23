module Day11 where

import Helpers

import Data.List

gridSerialNumber :: Int
gridSerialNumber = 5034

myGridCoordinates = getAllPoints (1, 1) (300, 300)

getAfter :: Int -> [a] -> a
getAfter i xs = xs!!(i + 1)

getTwoAfter :: Int -> [a] -> a
getTwoAfter i = getAfter (i + 1)

getRackId :: (Int, Int) -> Int
getRackId (x, _) = x + 10

getInitialPowerLevel :: (Int, Int) -> Int
getInitialPowerLevel point = getRackId point * snd point

getFinalPowerLevel :: (Int , Int) -> Int
getFinalPowerLevel point = getRackId point * (gridSerialNumber + getInitialPowerLevel point)

getHundredsDigit :: Int -> Int
getHundredsDigit x = rem (div x 100) 10

getValueOf :: (Int, Int) -> Int
getValueOf point = getHundredsDigit (getFinalPowerLevel point) - 5

myPowerValues :: [[Int]]
myPowerValues = chunks 300 $ map getValueOf myGridCoordinates

getTotalOfSquare :: Int -> (Int,Int) -> [[Int]] -> Int
getTotalOfSquare size (x, y) grid = foldl (\a i -> a + getTotalOfline size y (grid!!i)) 0 [x..(x + size - 1)]

getTotalOfline :: Int -> Int -> [Int] -> Int
getTotalOfline length start line = foldl (\a i -> a + line!!i) 0 [start..(start + length - 1)]

getTotalOfColumn :: Int -> (Int, Int) -> [[Int]] -> Int
getTotalOfColumn length (x,y) grid = foldl (\a x1 -> a + grid!!x1!!y) 0 [x..(x + length - 1)]

updateStatusAtStartOfRow :: [[Int]] -> Int -> (Int, Int) -> (Int,(Int,(Int, Int))) -> (Int,(Int,(Int, Int)))
updateStatusAtStartOfRow grid size p (prev,original) = (newScore,newSnd)
    where newScore = getTotalOfSquare size p grid
          isNewHigher = newScore > fst original
          newSnd = if isNewHigher then (newScore,p) else original

updateStatusMiddleOfRow :: [[Int]] -> Int -> (Int, Int) -> (Int,(Int,(Int, Int))) -> (Int,(Int,(Int, Int)))
updateStatusMiddleOfRow grid size p (prev,original) = (newTotal,newSnd)
    where (x,y) = p
          columnToSubtract = getTotalOfColumn size previousPoint grid
          columnToAdd = getTotalOfColumn size newPoint grid
          previousPoint = (x,y - 1)
          newPoint = (x,y+ size - 1)
          newTotal = prev - columnToSubtract + columnToAdd
          isNewHigher = newTotal > fst original
          newSnd = if isNewHigher then (newTotal,p) else original


getLargestPowerSquareWithSize size grid = snd $ foldl step (0,(0,(0,0))) pointsToCheck
    where pointsToCheck = getAllPoints (0,0) (300 - size,300 - size)
          step original (x,0) = updateStatusAtStartOfRow grid size (x,0) original
          step original p = updateStatusMiddleOfRow  grid size p original

part1 = print (x + 1,y + 1)
    where (x,y) = snd $ getLargestPowerSquareWithSize 9 myPowerValues

part2 :: IO()
part2 = print answer
    where step currentAnswer n =  if fst newAnswer > fst (snd currentAnswer) then (n,newAnswer) else currentAnswer
            where newAnswer = getLargestPowerSquareWithSize n grid
          grid = myPowerValues
          (size,(_,(x,y))) = foldl step (0,(0,(0,0))) [14..17]
          answer = (x + 1,y + 1,size)



main :: IO()
main = part2