import strutils, sequtils

const goal = 380621
var 
    scoreBoard = @[3, 7]
    firstElfScoreIndex = 0
    secondElfScoreIndex = 1

proc createRecipe(first: int, second: int): seq[int] =
    var res = first + second
    if res >= 10:
        result.add((res / 10).int)
        if res mod 10 == 0:
            result.add(0)
        elif res > 10:
            result.add(res mod 10)
    else:
        result.add(res)

proc computeRecipes() = 
    var 
        firstRecipe = scoreBoard[firstElfScoreIndex]
        secondRecipe = scoreBoard[secondElfScoreIndex]
        res = createRecipe(firstRecipe, secondRecipe)
    scoreBoard.add(res[0])
    if res.len == 2:
        scoreBoard.add(res[1])
    var scoreLen = scoreBoard.len

    firstElfScoreIndex = (firstElfScoreIndex + 1 + firstRecipe) mod scoreLen
    secondElfScoreIndex = (secondElfScoreIndex + 1 + secondRecipe) mod scoreLen

var foundPartTwo = false

proc searchPartTwo() =
    echo "Searching"
    var numberOfRecipes = (scoreBoard.join).find("380621")
    if not foundPartTwo and numberOfRecipes != -1:
        echo "Part2: ", numberOfRecipes
        foundPartTwo = true

var current = 0


while current != goal+10:
    computeRecipes()
    current = current + 1

echo "Part one: ", scoreBoard[goal..goal+9].join()        

while not foundPartTwo:
    computeRecipes()
    if current mod 10000000 == 0:
        searchPartTwo()
    current = current + 1


