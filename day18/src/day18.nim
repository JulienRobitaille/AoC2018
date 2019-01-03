import strutils, sequtils, math, os

const 
    input = "src/input.txt".readFile.splitLines
    #input = "src/test.txt".readFile.splitLines
    maxX = input[0].len
    maxY = input.len
    GROUND = '.'
    TREE = '|'
    LUMBERYARD = '#'
    minutes = 1000000000

type Lines = seq[seq[char]]

var matrix: Lines = @[]

for line in input:
    matrix.add(line.mapIt(it))

func isGround(c: char): bool = c == GROUND
func isTree(c: char): bool = c == TREE
func isLumberyard(c: char): bool = c == LUMBERYARD

func countTree(lines: Lines): int =
    for line in lines:
        result = result + line.count(TREE)

func countLumberyard(lines: Lines): int =
    for line in lines:
        result = result + line.count(LUMBERYARD)

func getAdjecents(lines: Lines, x:int, y:int): seq[char] =
    let adjecent = [
        (x: x - 1, y: y - 1),   # Left top corner
        (x: x, y: y - 1),       # Top
        (x: x + 1, y: y - 1),   # Right top corner
        (x: x - 1, y: y),       # Left
        #(x: x, y: y),           # Center
        (x: x + 1, y: y),       # Right
        (x: x - 1, y: y + 1),   # Left bottom corner
        (x: x, y: y + 1),       # Bottom
        (x: x + 1, y: y + 1)    # Right bottom corner
    ]

    for p in adjecent:
        if p.y >= 0 and p.y < lines.len and p.x >= 0 and p.x < lines[y].len:
            result.add(lines[p.y][p.x])


proc print(lines: Lines) = 
    for line in lines:
        echo line.join

var frames: seq[Lines] = @[matrix]

for i in 1..minutes:
    var tempMatrix = matrix
    for y, line in matrix:
        for x, element in line:
            let adjs = getAdjecents(matrix, x, y)
            if element.isGround and adjs.count(TREE) >= 3:
                tempMatrix[y][x] = TREE
            elif element.isTree and adjs.count(LUMBERYARD) >= 3:
                tempMatrix[y][x] = LUMBERYARD
            elif element.isLumberyard:
                if adjs.count(LUMBERYARD) >= 1 and adjs.count(TREE) >= 1:
                    tempMatrix[y][x] = LUMBERYARD
                else:
                    tempMatrix[y][x] = GROUND
    matrix = tempMatrix
    
    let frameIndex = frames.find(matrix)
    if  frameIndex != -1:
        let 
            period = i - frameIndex
            step = (minutes - i) mod period
            frame = frames[frameIndex + step]
        echo "Part two: ", frame.countTree * frame.countLumberyard
        print frame
        break
    else:
        frames.add(matrix)
    
    if i == 10:
        echo "Part one: ", matrix.countTree * matrix.countLumberyard
