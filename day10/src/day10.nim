import strutils, sequtils, math

const input = "src/input.txt".readFile.strip.splitLines
#const input = "src/test.txt".readFile.strip.splitLines

type Position = tuple[x: int, y:int]
type Velocity = tuple[x: int, y:int]
type Point = object
        position: Position
        velocity: Velocity
type Second = int

var points: seq[Point] = @[]
var pointInTime: seq[Point] = @[]

for i, line in input:
    var 
        data = line.split("> ")
        position = data[0].replace("position=<", "").split(",")
        velocity = data[1].replace("velocity=<", "").replace(">").split(",")
        px = position[0].strip.parseInt
        py = position[1].strip.parseInt
        vx = velocity[0].strip.parseInt
        vy = velocity[1].strip.parseInt
    points.add(
        Point(
            position: (x: px, y: py ),
            velocity: (x: vx, y: vy)
        )
    )
    pointInTime.add(points[i])

var minX, maxX, minY, maxY:int

    
proc computeZone(time: Second) = 
    var pointAtT: seq[Point] = @[]
    
    for i, point in points:
        var
            x = point.position.x + (point.velocity.x * time)
            y = point.position.y + (point.velocity.y * time)
        pointInTime[i] = Point(
            position: (x: x, y: y ),
            velocity: (x: point.velocity.x, y: point.velocity.y)
        )
    minX = pointInTime.mapIt(it.position.x).min
    maxX = pointInTime.mapIt(it.position.x).max
    minY = pointInTime.mapIt(it.position.y).min
    maxY = pointInTime.mapIt(it.position.y).max

proc print() =
    for y in minY..maxY:
        var line = ""
        for x in minX..maxX:
            if pointInTime.anyIt(it.position.x == x and it.position.y == y):
                line.add("#")
            else:
                line.add(" ")
        echo line
            
    

for time in 1..200000:
    computeZone(time)
    if maxY - minY <= 10:
        echo time
        print()
        break
        
    