module Day19 where

import Helpers
import Day16 ( Instruction(..), OperationArguments(..), carryOutInstruction, OperationFunctionArguments (OperationFunctionArguments) )

day19FilePath = "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day19Input.txt"

parseInput :: String -> [(Instruction, OperationArguments)]
parseInput = map parseInputLine . lines

parseInputLine :: String -> (Instruction, OperationArguments)
parseInputLine input = (getInstructionFromText $ head parts, args)
    where parts = words input
          numbers = map (\x -> read x :: Int) $ tail parts
          args = OperationArguments (head numbers) (numbers!!1) (numbers!!2)

ipLocation :: Int
ipLocation = 4

getInstructionFromText :: String -> Instruction
getInstructionFromText "addr" = Addr
getInstructionFromText "addi" = Addi
getInstructionFromText "mulr" = Mulr
getInstructionFromText "muli" = Muli
getInstructionFromText "banr" = Banr
getInstructionFromText "bani" = Bani
getInstructionFromText "borr" = Borr
getInstructionFromText "bori" = Bori
getInstructionFromText "setr" = Setr
getInstructionFromText "seti" = Seti
getInstructionFromText "gtir" = Gtir
getInstructionFromText "gtri" = Gtri
getInstructionFromText "gtrr" = Gtrr
getInstructionFromText "eqir" = Eqir
getInstructionFromText "eqri" = Eqri
getInstructionFromText "eqrr" = Eqrr

runInstruction :: (Instruction , OperationArguments) -> [Int] -> [Int]
runInstruction (instruction, arguments) registers = carryOutInstruction instruction (OperationFunctionArguments arguments registers)

runProgram :: [(Instruction , OperationArguments)] -> [Int] -> [Int]
runProgram instructions registers = if instructionPointer >= length instructions then registers else nextCall
    where instructionPointer = registers!!ipLocation
          currentInstruction = instructions!!instructionPointer
          newRegistersAfterAction = runInstruction currentInstruction registers
          newRegistersWithUpdatedIP = replaceValue ipLocation (newRegistersAfterAction!!ipLocation + 1) newRegistersAfterAction
          nextCall = runProgram instructions newRegistersWithUpdatedIP

proccess :: String -> [Int] -> [Int]
proccess = runProgram . parseInput


part1 :: String -> IO ()
part1 = print . flip proccess [0,0,0,0,0,0]

main :: IO()
main = do inputText <- readFile day19FilePath
          part1 inputText

--after setup -> 2304,931,1,930,257,931