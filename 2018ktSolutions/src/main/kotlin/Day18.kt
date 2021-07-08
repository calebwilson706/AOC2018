import java.io.File

object Day18 {
    val inputLines = File("/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day18Input.txt").readLines()

    fun part1() {
        solution(10)
    }

    fun part2() {
        val initial = parseInput()
        val target = 1000000000
        val loop = findLoop(mutableMapOf(initial to 0), initial, 1)
        val loopCount = loop.size
        val start = loop.values.minOrNull()!!
        val targetEquivalent = start + (target - start) % loopCount

        println(loop.entries.first { it.value == targetEquivalent }.key.resourceCount())

    }

    fun findLoop(previousFinds : Map<Map<Pair<Int, Int>, Status>, Int>, previous : Map<Pair<Int, Int>, Status>, n : Int): Map<Map<Pair<Int, Int>, Status>, Int> {
        val newMap = previous.oneCycle()
        val newResult = previousFinds.toMutableMap()

        previousFinds[newMap]?.let { previousFound ->
            return previousFinds.filter { (previousFound until n).contains(it.value) }
        } ?: run {
            newResult[newMap] = n
            return findLoop(newResult,newMap, n + 1)
        }
    }

    fun solution(n : Int) {
        var map = parseInput()

        (0 until n).forEach { _ ->
            map = map.oneCycle()
        }

        println(
            map.resourceCount()
        )
    }

    fun Map<Pair<Int, Int>, Status>.oneCycle(): Map<Pair<Int, Int>, Status> {
        val newMap = mutableMapOf<Pair<Int, Int>, Status>()
        this.keys.forEach {
            newMap[it] = it.getNewStatus(this)
        }

        return newMap
    }

    fun Map<Pair<Int, Int>, Status>.resourceCount() =
        this.values.count { it == Status.LUMBERYARD } * this.values.count { it == Status.TREES }


    fun parseInput() : Map<Pair<Int, Int>, Status> {
        val answer = mutableMapOf<Pair<Int, Int>, Status>()

        (inputLines.indices).forEach { y ->
            val currentLine = inputLines[y]
            (currentLine.indices).forEach { x ->
                answer[Pair(x,y)] = currentLine[x].getStatus()
            }
        }

        return answer
    }

    fun Pair<Int, Int>.getAdjacentStatuses(map : Map<Pair<Int, Int>, Status>): MutableMap<Status, Int> {
        val result = mutableMapOf<Status, Int>()
        this.adjacent().forEach { adjacent ->
            val theStatus = map[adjacent] ?: Status.OPEN
            result[theStatus] = (result[theStatus] ?: 0) + 1
        }
        return result
    }

    fun Pair<Int, Int>.getNewStatus(map : Map<Pair<Int, Int>, Status>) : Status {
        val neighboursStatus = this.getAdjacentStatuses(map)

        return when (map[this]!!) {
            Status.OPEN ->
                if (neighboursStatus[Status.TREES] ?: 0 >= 3) {
                    Status.TREES
                } else Status.OPEN
            Status.TREES ->
                if (neighboursStatus[Status.LUMBERYARD] ?: 0 >= 3) {
                    Status.LUMBERYARD
                } else Status.TREES
            Status.LUMBERYARD ->
                if (neighboursStatus[Status.LUMBERYARD] ?: 0 >= 1 && neighboursStatus[Status.TREES] ?: 0 >= 1) {
                    Status.LUMBERYARD
                } else Status.OPEN
        }
    }

}

enum class Status {
    OPEN, TREES, LUMBERYARD
}

fun Char.getStatus() = when (this) {
    '.' -> Status.OPEN
    '|' -> Status.TREES
    else -> Status.LUMBERYARD
}


fun Pair<Int, Int>.adjacent(): MutableList<Pair<Int, Int>> {
    val answer = mutableListOf<Pair<Int, Int>>()

    (-1 .. 1).forEach { x ->
        (-1..1).forEach { y ->
            answer.add(Pair(x + this.first, y + this.second))
        }
    }

    answer.remove(this)
    return answer
}
