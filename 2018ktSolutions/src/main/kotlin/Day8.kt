import java.io.File
import java.util.*


object Day8 {
    private val inputText = File("/Users/calebjw/Documents/Developer/AdventOfCode/2018/Inputs/Day8Input.txt").readText()

    private fun parseInput() = inputText.split(" ").map { it.toInt() }

    fun part1() {
        val inputNumbers = parseInput()
        var currentTotalOfMetaData = 0
        val stackOfNodes = Stack()
        var currentIndex = 0

        while (currentIndex < inputNumbers.size) {

            if (stackOfNodes.childrenToFindForTop() > 0) {
                addNewNodeToStack(currentIndex,inputNumbers,stackOfNodes)
                currentIndex += 2
            }

            if (stackOfNodes.childrenToFindForTop() == 0) {
                val metaDataCount = stackOfNodes.metadataForTop()
                (0 until metaDataCount).forEach { offset ->
                    currentTotalOfMetaData += inputNumbers[currentIndex + offset]
                }
                currentIndex += metaDataCount
                stackOfNodes.pop()
            }

        }
        print(currentTotalOfMetaData)
    }

    fun part2() {
        val inputNumbers = parseInput()
        val stackOfNodes = Stack()
        var currentIndex = 0

        while (currentIndex < inputNumbers.size) {

            if (stackOfNodes.childrenToFindForTop() > 0) {
                addNewNodeToStack(currentIndex,inputNumbers,stackOfNodes)
                currentIndex += 2
            }

            if (stackOfNodes.childrenToFindForTop() == 0) {
                val metaDataCount = stackOfNodes.metadataForTop()
                val foundMetaData = (0 until metaDataCount).map {  inputNumbers[currentIndex + it] }
                stackOfNodes.updateTopOfStackPart2(foundMetaData)
                currentIndex += metaDataCount
            }
        }

        val root = stackOfNodes.pop()!!
        print(root.childrenMetaData.totalListUsingIndicesOneIndexed(root.foundMetadata))
    }

    private fun getNode(atIndex : Int, numbers : List<Int>): Node {
        val childrenAmount = numbers[atIndex]
        return Node(childrenAmount,numbers[atIndex + 1],childrenAmount,mutableListOf(),mutableListOf())
    }

    private fun addNewNodeToStack(atIndex : Int, numbers : List<Int>, stack : Stack) {
        stack.updateStatusOfFirstAfterFindingChild()
        stack.push(getNode(atIndex,numbers))
    }


}

data class Node(
    var amountOfChildrenToFind : Int,
    val amountOfMetaData : Int,
    val originalAmountOfChildren : Int,
    var foundMetadata: List<Int>,
    val childrenMetaData: MutableList<Int>
)

class Stack {
    private val stack = LinkedList<Node>()

    fun peek() = stack.first()

    fun pop(): Node? = stack.removeFirst()

    fun push(value : Node) = stack.push(value)

    fun isEmpty() = stack.isEmpty()

    fun updateStatusOfFirstAfterFindingChild() {
        if (!isEmpty()) {
            peek().amountOfChildrenToFind -= 1
        }
    }

    fun childrenToFindForTop() = if (isEmpty()) 1 else peek().amountOfChildrenToFind

    fun metadataForTop() = peek().amountOfMetaData

    fun updateTopOfStackPart2(newFoundMetadata : List<Int>) {

        peek().foundMetadata = newFoundMetadata

        if (stack.size == 1) {
            return
        }

        val previousTop = pop()!!

        val newValueToAdd = when {
            previousTop.originalAmountOfChildren == 0 -> newFoundMetadata.sum()
            newFoundMetadata.isEmpty() -> 0
            else -> previousTop.childrenMetaData.totalListUsingIndicesOneIndexed(newFoundMetadata)
        }

        addNewChildMetaDataValueAtTop(newValueToAdd)
    }

    private fun addNewChildMetaDataValueAtTop(value : Int) {
        peek().childrenMetaData.add(value)
    }

}

fun List<Int>.safeAccess(index : Int): Int {
    return if (index >= size) {
        0
    } else {
        this[index]
    }
}

fun List<Int>.totalListUsingIndicesOneIndexed(listIndices : List<Int>) : Int {
    return listIndices.fold(0) { acc, it ->
        acc + this.safeAccess(it - 1)
    }
}