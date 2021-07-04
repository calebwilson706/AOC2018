module Helpers where

import Data.Char

getIntegerListFromStringList :: [String] -> [Int]
getIntegerListFromStringList = map read

getCircularIndex :: [a] -> Int -> Int
getCircularIndex list index = rem index (length list)

indices :: [a] -> [Int]
indices list = [0 .. length list - 1]

boolToInt :: Bool -> Int
boolToInt boolean = if boolean then 1 else 0

replaceValue :: Int -> a -> [a] -> [a]
replaceValue indexToReplace newValue originalList = header ++ [newValue] ++ drop 1 footer
    where (header, footer) = splitAt indexToReplace originalList

getAllPoints :: (Int,Int) -> (Int,Int) -> [(Int, Int)]
getAllPoints (minX,minY) (maxX, maxY) = [(x,y) | x <- [minX .. maxX], y <- [minY .. maxY]]

count :: [t1] -> (t1 -> Bool) -> Int
count list predicate = foldl (\acc next -> acc + if predicate next then 1 else 0) 0 list

chunks :: Int -> [a] -> [[a]]
chunks _ [] = []
chunks n xs =
    let (ys, zs) = splitAt n xs
    in  ys : chunks n zs

digits :: Int -> [Int]
digits = map digitToInt . show