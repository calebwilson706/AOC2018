//0 -> addi 4 16 4 (jmp to 17)
//1 -> seti 1 2 5
//2 -> seti 1 1 1
//3 -> mulr 5 1 2
//4 -> eqrr 2 3 2
//5 -> addr 2 4 4
//6 -> addi 4 1 4
//7 -> addr 5 0 0
//8 -> addi 1 1 1
//9 -> gtrr 1 3 2
//10 -> addr 4 2 4
//11 -> seti 2 4 4
//12 -> addi 5 1 5
//13 -> gtrr 5 3 2
//14 -> addr 2 4 4
//15 -> seti 1 8 4
//16 -> mulr 4 4 4
//17 -> addi 3 2 3     ---------|
//18 -> mulr 3 3 3              |
//19 -> mulr 4 3 3              |
//20 -> muli 3 11 3             |
//21 -> addi 2 4 2              |
//22 -> mulr 2 4 2              | setup -> r3 = 930
//23 -> addi 2 6 2              |
//24 -> addr 3 2 3              |
//25 -> addr 4 0 4              |
//26 -> seti 0 8 4     ---------|
//27 -> setr 4 1 2     (r2 = r4)            |
//28 -> mulr 2 4 2     (r2 = r2*r4)         |
//29 -> addr 4 2 2     (r2 = r2 + r4)       |
//30 -> mulr 4 2 2     (r2 = r2 * r4)       |--------> r2 = (27 * 28 + 29)*30*14*32 + 930
//31 -> muli 2 14 2    (r2 = r2*14)         |
//32 -> mulr 2 4 2     (r2 = r2*r4)         |
//33 -> addr 3 2 3     (r2 = r2 + 930)      |
//34 -> seti 0 0 0
//35 -> seti 0 0 4



import Foundation
import PuzzleBox

class Day19 : PuzzleClass {
    
    init() {
        super.init(filePath: "/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day19Input.txt")
    }
    
    func showInstructions() {
        Array(inputStringUnparsed!.components(separatedBy: "\n")).enumerated().forEach { (index, elem) in
            print("\(index) -> \(elem)")
        }
    }
    
    
    func part2() {
        //r2 from working out above
        print(factorsSum(of: (27 * 28 + 29)*30*14*32 + 930))
    }
    
    func factorsSum(of n: Int) -> Int {
        
        let sqrtn = sqrt(x: n)
        var factors: [Int] = []
        factors.reserveCapacity(2 * sqrtn)
        for i in 1...sqrtn {
            if n % i == 0 {
                factors.append(i)
            }
        }
        var j = factors.count - 1
        if factors[j] * factors[j] == n {
            j -= 1
        }
        while j >= 0 {
            factors.append(n / factors[j])
            j -= 1
        }
        return factors.reduce(0, +)
    }
}



func sqrt(x:Int) -> Int { return Int(sqrt(Double(x))) }

