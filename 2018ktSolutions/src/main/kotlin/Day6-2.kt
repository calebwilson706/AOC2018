import java.io.File
import kotlin.math.abs

object Day6 {
    private val inputLines =
        File("/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day6Input.txt").readLines()

    private fun getInputPoints(): List<Pair<Int, Int>> {
        return inputLines.map { line ->
            val numbers = line.split(" ").map { it.toInt() }
            Pair(numbers.first(), numbers.last())
        }
    }

    fun test() {
        print(Pair(200,200).isTotalDistanceInRegion(10000, getInputPoints()))
    }


    fun part2() {
        var sizeOfRegion = 0
        val pointsToCheck = getInputPoints()

        for (x in 0 until 340) {
            for (y in 0 until 340) {
                if (Pair(x,y).isTotalDistanceInRegion(10000,pointsToCheck)) sizeOfRegion ++
            }
        }

        print(sizeOfRegion)
    }

    private fun Pair<Int, Int>.isTotalDistanceInRegion(range : Int, list : List<Pair<Int, Int>>): Boolean {
        var total = 0

        for (point in list) {
            total += this.getManhattanDistance(point)
            if (total >= range) {
                return false
            }
        }

        return true
    }

    private fun Pair<Int, Int>.getManhattanDistance(other : Pair<Int, Int>) = straightLineDistance(this.first, other.first) + straightLineDistance(this.second, other.second)

    private fun straightLineDistance(x : Int, y : Int) = abs(x - y)
}