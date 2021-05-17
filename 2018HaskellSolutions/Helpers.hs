module Helpers where

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