import java.io.File

object Day3 {
    private val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day3Input.txt").readLines()
    
    private fun parseInput() : List<ElfHypothesis> {
        val numberRegex = "([0-9]+)"
        val regex = "#$numberRegex @ $numberRegex,$numberRegex: ${numberRegex}x$numberRegex".toRegex()
        val result = mutableListOf<ElfHypothesis>()

        inputLines.forEach {
            val (id,x,y,width,height) = regex.find(it)!!.destructured
            result.add(
                ElfHypothesis(id.toInt(),x.toInt(),y.toInt(),width.toInt(),height.toInt())
            )
        }

        return result
    }

    fun part1() {
        println(getMapOfPointsToPatternIdsOnPoint().count { it.value.size > 1})
    }

    fun part2() {
        val hypotheses = parseInput()

        println(hypotheses.first { oneToCheck ->
            !hypotheses.any { oneToCheck.doesCrossOver(it) && it != oneToCheck }
        }.id)
    }

    private fun getMapOfPointsToPatternIdsOnPoint(): MutableMap<Pair<Int, Int>, MutableSet<Int>> {
        val myFabric = mutableMapOf<Pair<Int, Int>,MutableSet<Int>>()
        val hypotheses = parseInput()

        hypotheses.forEach {
            myFabric.addElfHypothesis(it)
        }

        return myFabric
    }


    private fun MutableMap<Pair<Int, Int>,MutableSet<Int>>.addElfHypothesis(hypothesis : ElfHypothesis) {
        hypothesis.getPointsOfFabricUsed().forEach {
            val existingSet = this[it] ?: mutableSetOf()
            existingSet.add(hypothesis.id)
            this[it] = existingSet
        }
    }

    private fun doRangesCrossOver(range1: IntRange, range2: IntRange) = range1.intersect(range2).isNotEmpty()

    private data class ElfHypothesis(val id : Int, val xCoordinate : Int, val yCoordinate : Int, val width : Int, val height : Int) {
        fun getPointsOfFabricUsed() : Set<Pair<Int, Int>> {
            val points = mutableSetOf<Pair<Int, Int>>()

            (0 until width).forEach { xOffset ->
                (0 until height).forEach { yOffset ->
                    points.add(Pair(xCoordinate + xOffset, yCoordinate + yOffset))
                }
            }

            return points
        }

        fun doesCrossOver(otherHypothesis: ElfHypothesis) = doRangesCrossOver(otherHypothesis.getXRange(), getXRange()) && doRangesCrossOver(otherHypothesis.getYRange(), getYRange())

        fun getXRange() = xCoordinate until xCoordinate + width
        fun getYRange() = yCoordinate until yCoordinate + height
    }
}