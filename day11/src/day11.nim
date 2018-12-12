import strutils, sequtils

const serial = 8141

proc getPowerAt(x: int, y: int): int =
    
    var rackId = x + 10
    
    result = rackId * y
    result = result + serial
    result = result * rackId

    var hundred = result.intToStr

    result = if hundred.len >= 3: ($hundred[^3]).parseInt else: 0
    result = result - 5

var 
    cell: string
    size: int
    biggest: int
    hologram: array[301, array[301, int]]

for y in 1..300:
    for x in 1..300:
        if hologram[y][x] == 0: 
            hologram[y][x] = getPowerAt(y, x)

proc part1(size: int) = 
    for y in 1..300:
        for x in 1..300:
            var squareValue = 0
            for squareY in y..(y+size):
                if squareY > 300:
                        break
                for squareX in x..(x+size):
                    if squareX > 300:
                        break
                    squareValue = squareValue + hologram[squareY][squareX]
                
            if biggest < squareValue:
                biggest = squareValue
                cell = y.intToStr & "," & x.intToStr & "," & (size+1).intToStr
proc part2() = 
    for size in 1..300:
        echo "Starting size: ", size
        part1(size)

part1(2)
part2()
echo cell
echo biggest