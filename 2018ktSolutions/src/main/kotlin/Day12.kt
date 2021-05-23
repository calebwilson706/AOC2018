import java.io.File

object Day12 {
    private val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day12Input.txt").readLines()
    private const val startingState = "#.#..#.##.#..#.#..##.######...####.........#..##...####.#.###......#.#.##..#.#.###.#..#.#.####....##"

    fun part1() {
        solution(20)
    }

    fun part2() {
        //4911 after 200
        //22 more each time
        print(4911 + (50000000000 - 200)*22)
    }

    private fun solution(max: Int) {
        var answer = startingState.indices.associateWith { startingState[it] }
        val combinations = getCombinations()

        (0 until max).forEach { _ ->
            answer = carryOutOneGeneration(answer, combinations)
        }

        println(answer.filter { it.value == '#' }.keys.sum())
    }

    private fun carryOutOneGeneration(previousPlants : Map<Int,Char>, combinations : Map<String, Char>) : Map<Int, Char> {
        val previousPlantIndexList = previousPlants.keys
        val newPlants = mutableMapOf<Int, Char>()

        (previousPlantIndexList.minOrNull()!! - 2 .. previousPlantIndexList.maxOrNull()!! + 2).forEach {
            val stringForCurrent = previousPlants.formString(it)
            newPlants[it] = combinations[stringForCurrent] ?: '.'
        }

        return  newPlants
    }

    private fun Map<Int,Char>.formString(currentIndex : Int) : String {
        return (currentIndex - 2 .. currentIndex + 2).fold("") { acc, index ->
            acc + (this[index] ?: ".")
        }
    }


    private fun getCombinations() : Map<String, Char> {
        val combinationsPairs = inputLines.map { it.split(" => ") }
        return combinationsPairs.associate { it.first() to it.last()[0] }
    }
}