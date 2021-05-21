import java.awt.Point
import java.io.File
import java.lang.StringBuilder
import kotlin.math.abs
import kotlin.math.max

object Day10 {

    private val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day10Input.txt").readLines()

    fun part1() {
        val endTime = getCorrectTime()
        val points = parseInput()

        (0..endTime).forEach { _ ->
            points.forEach { it.move() }
        }

        showMap(points)
    }

    fun part2() {
        println(getCorrectTime() + 1)
    }

    private fun showMap(points : List<Light>) {
        val coordinatesOfLights = points.map { it.position }
        val xCoordinates =  coordinatesOfLights.map { it.first }
        val yCoordinates = coordinatesOfLights.map { it.second }

        getRange(yCoordinates).forEach { y ->
            getRange(xCoordinates).forEach { x ->
                print(if (coordinatesOfLights.contains(Pair(x,y))) "#" else ".")
            }
            println()
        }
    }


    private fun getCorrectTime() : Int {
        val points = parseInput()
        var lowestX = 50000
        var lowestY = 50000
        var resultTime = 0

        (0 until 15000).forEach { time ->
            var maxX = 0
            var maxY = 0
            points.forEach {
                it.move()
                val position = it.position
                maxX = max(abs(position.first),maxX)
                maxY = max(abs(position.first),maxY)
            }

            if (maxX < lowestX && maxY < lowestY) {
                lowestX = maxX
                lowestY = maxY
                resultTime = time
            }
        }

        return resultTime
    }


    private fun parseInput() : List<Light> {
        val numberRegex = "\\s*(-?[0-9]+)"
        val pair = "=<$numberRegex,$numberRegex>"
        val regex = "position$pair velocity$pair".toRegex()

        return inputLines.map {
            val (x1,y1,x2,y2) = regex.find(it)!!.destructured
            Light(Pair(x1.toInt(),y1.toInt()), Pair(x2.toInt(),y2.toInt()))
        }
    }

    private fun getRange(numbers : List<Int>) = (numbers.minOrNull()!! .. numbers.maxOrNull()!!)

}

data class Light(var position : Pair<Int, Int>, val velocity : Pair<Int, Int>) {
    fun move() {
        position = Pair(position.first + velocity.first, position.second + velocity.second)
    }
}