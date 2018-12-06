import strutils, sequtils, math
type
    Coordinate = tuple[x: int, y: int]

proc inputToCoordinate(input: string): Coordinate =
    let coords = input.split(", ")
    result = (coords[0].parseInt, coords[1].parseInt)

const coordinates = readFile("src/input.txt").strip.splitLines.map(inputToCoordinate)
const xLength = coordinates.foldl(if a.x > b.x: a else: b).x
const yLength = coordinates.foldl(if a.y > b.y: a else: b).y


var matrix: array[yLength+1, array[xLength+1, int]]
for i, coordinate in coordinates:
    matrix[coordinate.y][coordinate.x] = -1 


var matricesOfCoord: seq[array[yLength+1, array[xLength+1, int]]] = @[]
var resultMatrix = matrix
var resultMatrixWithDuplicated = matrix

for coordinate in coordinates:
    var coordMatrix = matrix
    for y, row in coordMatrix:
        for x, result in row:
            var distance = abs(coordinate.x - x) + abs(coordinate.y - y) # Manhattan distance
            if resultMatrix[y][x] == distance:
                resultMatrix[y][x] = -2
            if result != -1:
                coordMatrix[y][x] = distance
            if distance < resultMatrixWithDuplicated[y][x] or resultMatrix[y][x] == 0:
                resultMatrix[y][x] = distance
                resultMatrixWithDuplicated[y][x] = distance
                
    matricesOfCoord.add(coordMatrix)

var largestNonInfinite = 0
var correction = matricesOfCoord.len - 1
for i, coordMatrix in matricesOfCoord:
    var size = 0
    for y, row in coordMatrix:
        if size >= 0:
            for x, result in row:
                let diff = (resultMatrix[y][x] - result)
                let 
                    top = y == 0
                    left = x == 0 
                    bottom = y == coordMatrix.len
                    right = x == row.len - 1
                    isPoint = coordinates[i].x == x and coordinates[i].y == y
            
                if diff == 0 or isPoint:
                    size = size + 1
                if  diff == 0 and result != -1 and (top or left or bottom or right):
                    size = -1
                    break
    size = size - correction
    if size > largestNonInfinite :
        largestNonInfinite = size

echo largestNonInfinite

# Part two ---
const limit = 10000
var sizePartTwo = 0

for y, row in resultMatrix:
    for x, col in row:
        var sumManhattanDistance = 0
        for coordinate in coordinates:
            sumManhattanDistance = sumManhattanDistance + abs(coordinate.x - x) + abs(coordinate.y - y)
        
        if sumManhattanDistance < limit:
            sizePartTwo = sizePartTwo + 1
echo sizePartTwo
        