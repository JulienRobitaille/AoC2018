import strutils, sequtils, math, tables, algorithm

const 
    input = "src/input.txt".readFile.splitLines
    #input = "src/test.txt".readFile.splitLines
    maxX = input.mapIt(it.len).max
    maxY = input.len

type 
    Matrix = array[maxY, array[maxX, char]]
    Cart = tuple[id: int, x: int, y: int, direction: char, previousValue: char, turnIndex: int]

var matrix: Matrix

const direction = {
    ">-": '>',
    "<-": '<',
    "^|": '^',
    "v|": 'v',
    ">/": '^',
    ">\\": 'v',
    "v/": '<',
    "v\\": '>',
    "^\\": '<',
    "</": 'v',
    "<\\": '^',
    "^/": '>',
}.toTable

const turnLeft = {
    '>': '^',
    '<': 'v',
    '^': '<',
    'v': '>',
}.toTable

const turnRight = {
    '>': 'v',
    '<': '^',
    '^': '>',
    'v': '<',
}.toTable

for y, row in matrix:
    for x, col in row:
        matrix[y][x] = input[y][x]

proc findCarts(m: Matrix): seq[Cart] =
    var carId = 1
    for y, row in matrix:
        for x, item in row:
            var previous: char
            case item:
                of '^':
                    previous =  '|'
                of '<':
                    previous = '-'
                of '>':
                    previous =  '-'
                of 'v':
                    previous =  '|'
                else:
                    previous = item
            if item in ['^', '<', '>', 'v']:
                result.add((id: carId,x: x, y: y, direction: item, previousValue: previous, turnIndex: 0))
                carId = carId + 1

proc getCartNextPosition(cart: Cart): Cart =
    var point: tuple[x: int, y: int]
    case cart.direction:
        of '^':
            point = (x: cart.x, y: cart.y - 1)
        of '<':
            point = (x:cart.x - 1, y: cart.y)
        of '>':
            point = (x: cart.x + 1, y: cart.y)
        of 'v':
            point = (x: cart.x, y: cart.y + 1)
        else:
            echo "Incorect position"
    result = (id: cart.id, x: point.x, y: point.y, direction: cart.direction, previousValue: cart.previousValue, turnIndex: cart.turnIndex)

proc getCartNextDirection(cart: Cart, nextTrac: char): Cart =
    var 
        nextMove = $cart.direction & $nextTrac
        d: char
        turnIndex = cart.turnIndex
    
    if nextTrac in ['-', '|', '/', '\\']:
        d = direction[nextMove]
    elif nextTrac == '+':
        if turnIndex mod 3 == 1:
            d = cart.direction
        elif turnIndex mod 3 == 0:
            d = turnLeft[cart.direction]
        elif turnIndex mod 3 == 2:
            d = turnRight[cart.direction]
        turnIndex = turnIndex + 1
    else:
        echo "Incorect trac: ", nextTrac
    
    result = (id: cart.id, x: cart.x, y: cart.y, direction: d, previousValue: nextTrac, turnIndex: turnIndex)

var firstCrash = false

proc run(carts: seq[Cart]): seq[Cart]= 
    result = @[]
    var deletedCart: seq[int] = @[]
    for cart in carts:
        var 
            newCart = getCartNextPosition(cart)
            nextValue = matrix[newCart.y][newCart.x]
        if cart.id in deletedCart:
            continue;

        if nextValue in ['^', '<', '>', 'v']:
            var allCarts = carts.concat(result)
            var otherCart = allCarts.filterIt(it.x == newCart.x and it.y == newCart.y)[0]
            if not firstCrash:
                firstCrash = true
                echo "First crash at: ", newCart.x, ", ", newCart.y
            matrix[cart.y][cart.x] = cart.previousValue
            matrix[newCart.y][newCart.x] = otherCart.previousValue
            deletedCart.add(cart.id)
            deletedCart.add(otherCart.id)
            result = result.filterIt(not (it.id in deletedCart))
            continue

        newCart = getCartNextDirection(newCart, nextValue)
        matrix[cart.y][cart.x] = cart.previousValue 
        matrix[newCart.y][newCart.x] = newCart.direction
        result.add(newCart)
        

var carts = findCarts(matrix)
while carts.len > 1:
    carts = run(carts)
    carts = carts.sortedByIt(it.y + it.x)
echo "Last cart at: ", carts[0].x, ", ", carts[0].y