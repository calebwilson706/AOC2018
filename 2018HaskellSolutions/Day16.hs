module Day16 where

import Helpers
import Data.Bits
import Data.Char
import Data.List

day16Part1FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day16InputPart1.txt"
day16Part2FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day16InputPart2.txt"

data OperationArguments = OperationArguments Int Int Int
    deriving (Show)
data OperationFunctionArguments = OperationFunctionArguments OperationArguments [Int]
data Instruction =
    Addr | Addi | Mulr | Muli | Banr | Bani | Borr | Bori | Setr | Seti | Gtrr | Gtri | Gtir | Eqrr | Eqri | Eqir
    deriving (Show, Eq, Ord, Enum)
data Part1InputBlock = Part1InputBlock [Int] [Int] [Int]
    deriving (Show)

parseInputBlockPart1 :: [String] -> Part1InputBlock
parseInputBlockPart1 parts = Part1InputBlock original arguments updated
    where original = parseRegisterStatusString $ head parts
          arguments = parseSpacedIntegers $ parts!!1
          updated = parseRegisterStatusString $ last parts


parseInputPart1 :: String -> [Part1InputBlock]
parseInputPart1 = map parseInputBlockPart1 . chunks 3 . filter (/=[]) . lines

allInstructions :: [Instruction]
allInstructions = [Addr .. Eqir]

parseSpacedIntegers :: String -> [Int]
parseSpacedIntegers = map (\x -> read x ::Int) . words

parseRegisterStatusString :: [Char] -> [Int]
parseRegisterStatusString = parseSpacedIntegers . filter (\c -> isSpace c || isDigit c)

registerRange :: [Int]
registerRange = [0..5]

isValidRegister :: Int -> Bool
isValidRegister = flip elem registerRange

asInt :: Bool -> Int
asInt bool = if bool then 1 else 0

greaterThanAsInt :: Int -> Int -> Int
greaterThanAsInt a b = asInt $ a > b

equalToAsInt :: Int -> Int -> Int
equalToAsInt a b = asInt $ a == b

bothRegisterValidationCheck :: Int -> Int -> Bool
bothRegisterValidationCheck a b = all isValidRegister [a,b]

getAnswerAfterValidation :: Bool -> [a] -> [a]
getAnswerAfterValidation isValid result = if isValid then result else []

operationR :: (Int -> Int -> Int) -> OperationFunctionArguments -> [Int]
operationR op (OperationFunctionArguments (OperationArguments a b c) registers) = getAnswerAfterValidation isValid result
    where isValid = bothRegisterValidationCheck a b
          result = replaceValue c (op (registers!!a) (registers!!b)) registers

operationRI :: (Int -> Int -> Int) -> OperationFunctionArguments -> [Int]
operationRI op (OperationFunctionArguments (OperationArguments a b c) registers) = getAnswerAfterValidation isValid result
    where isValid = isValidRegister a
          result = replaceValue c (op (registers!!a) b) registers

operationIR :: (Int -> Int -> Int) -> OperationFunctionArguments -> [Int]
operationIR op (OperationFunctionArguments (OperationArguments a b c) registers) = getAnswerAfterValidation isValid result
    where isValid = isValidRegister b
          result = replaceValue c (op a (registers!!b)) registers

setr :: OperationFunctionArguments -> [Int]
setr (OperationFunctionArguments (OperationArguments a b c) registers) = getAnswerAfterValidation isValid result
    where isValid = isValidRegister a
          result = replaceValue c (registers!!a) registers

seti :: OperationFunctionArguments -> [Int]
seti (OperationFunctionArguments (OperationArguments a b c) registers) = replaceValue c a registers

carryOutInstruction:: Instruction -> OperationFunctionArguments -> [Int]
carryOutInstruction Addr = operationR (+)
carryOutInstruction Addi = operationRI (+)
carryOutInstruction Mulr = operationR (*)
carryOutInstruction Muli = operationRI (*)
carryOutInstruction Banr = operationR (.&.)
carryOutInstruction Bani = operationRI (.&.)
carryOutInstruction Borr = operationR (.|.)
carryOutInstruction Bori = operationRI (.|.)
carryOutInstruction Setr = setr
carryOutInstruction Seti = seti
carryOutInstruction Gtrr = operationR greaterThanAsInt
carryOutInstruction Gtri = operationRI greaterThanAsInt
carryOutInstruction Gtir = operationIR greaterThanAsInt
carryOutInstruction Eqrr = operationR equalToAsInt
carryOutInstruction Eqri = operationRI equalToAsInt
carryOutInstruction Eqir = operationIR equalToAsInt

countMatches :: Part1InputBlock -> Int
countMatches = length . findPossibilitiesForOpcode

findPossibilitiesForOpcode :: Part1InputBlock -> [Instruction]
findPossibilitiesForOpcode (Part1InputBlock originals arguments answer) = filter (\instruction -> carryOutInstruction instruction ofas == answer) allInstructions
    where ofas = OperationFunctionArguments (OperationArguments (arguments!!1) (arguments!!2) (arguments!!3)) originals

updatePossibilitiesForOpcode :: Part1InputBlock -> [[Instruction]] -> [[Instruction]]
updatePossibilitiesForOpcode inputBlock accumulator = updatedAnswer
    where (Part1InputBlock originals arguments answer) = inputBlock
          opcode = head arguments
          localPossibilities = findPossibilitiesForOpcode inputBlock
          mutualItems = (accumulator!!opcode) `intersect` localPossibilities
          updatedAnswer = replaceValue opcode mutualItems accumulator


getAllPossibleOpcodes :: String -> [[Instruction]]
getAllPossibleOpcodes = foldr updatePossibilitiesForOpcode (map (const allInstructions) [0..15]) . parseInputPart1

filterDownOpcodes :: [[Instruction]] -> [(Int, Instruction)] -> [(Int, Instruction)]
filterDownOpcodes allPosibilities currentAnswer = if completed then currentAnswer else filterDownOpcodes newPossibilities nextAnswer
    where found = map snd currentAnswer
          newPossibilities = map (filter (`notElem` found)) allPosibilities
          completed = length found == 16
          nextAnswer = foldr (\nextIndex acc -> acc ++ [(nextIndex,head (newPossibilities!!nextIndex)) | length (newPossibilities!!nextIndex) == 1]) currentAnswer (indices newPossibilities)

getOpcodes :: String -> [Instruction]
getOpcodes input = map snd $ sort $ filterDownOpcodes (getAllPossibleOpcodes input) []

carryOutTests :: [[Int]] -> [Int]
carryOutTests = foldl step [0,0,0,0]
    where step acc test  = carryOutInstruction (opcodes!!head test) (OperationFunctionArguments (OperationArguments (test!!1) (test!!2) (test!!3)) acc)
          opcodes = [Bani,Banr,Muli,Setr,Bori,Eqrr,Gtir,Mulr,Gtrr,Seti,Gtri,Eqri,Addi,Borr,Eqir,Addr] -- got from methods above

part1 :: String -> IO ()
part1 = print . flip count (\e -> countMatches e >= 3) . parseInputPart1

part2 :: String -> IO()
part2 = print . carryOutTests . map parseSpacedIntegers . lines

main :: IO()
main = do inputText <- readFile day16Part2FilePath
          part2 inputText
