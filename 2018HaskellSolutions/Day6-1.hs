module Day6 where

import Data.Char

import Helpers 

import Data.List

day6FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day6Input.txt"

getListOfImportantPointCounts :: (Eq a, Ord a) => [a] -> [Int]
getListOfImportantPointCounts inputArray =  map length $ group $ sort inputArray

getCharacterfromIndex :: Int -> Char
getCharacterfromIndex index = (['a'..'z'] ++ ['A'..'Z'])!!index

getInputCoordinatesFromString :: String -> [(Char, (Int, Int))]
getInputCoordinatesFromString string = map (\index -> (getCharacterfromIndex index,xs!!index)) (indices xs)
    where xs = map ((\a -> (head a, last a)) . (map (\num -> read num::Int) . words)) (lines string)

decoyPoint :: (Char, (Int, Int))
decoyPoint = ('a',(0,0))

straightLineDistance :: Int -> Int -> Int
straightLineDistance x y = abs $ x - y

manhattanDistanceBetween :: (Int, Int) -> (Int, Int) -> Int
manhattanDistanceBetween (x1, y1) (x2, y2) = straightLineDistance x1 x2 + straightLineDistance y1 y2

getClosestPoint :: (Int, Int) -> [(Char, (Int, Int))] -> (Char, (Int, Int))
getClosestPoint myPoint = fst . foldl step (decoyPoint, maxBound::Int)
    where step (closestPoint, shortestDistance) current | distanceFromCurrent < shortestDistance = (current, distanceFromCurrent)
                                                        | distanceFromCurrent == shortestDistance = (('.', snd current),shortestDistance)
                                                        | otherwise = (closestPoint, shortestDistance)
            where distanceFromCurrent = manhattanDistanceBetween (snd current) myPoint

getClosestPointID :: (Int, Int) -> [(Char, (Int, Int))] -> Char
getClosestPointID x xs = fst $ getClosestPoint x xs

getAllPoints :: Int -> Int -> [(Int, Int)]
getAllPoints maxX maxY = [(x,y) | x <- [0 .. maxX], y <- [0 .. maxY]]

findTheListOfClosetsPoints :: [(Char, (Int, Int))] -> [Char]
findTheListOfClosetsPoints importantPoints = map (`getClosestPointID` importantPoints) (getAllPoints 500 500)

part1 :: String -> IO()
part1 input = print $ sort $ getListOfImportantPointCounts $ findTheListOfClosetsPoints $ getInputCoordinatesFromString input
--using multiple ranges I manually found the highest one that didnt change

main :: IO()
main = do inputText <- readFile day6FilePath
          part1 inputText
