type Marble = ref object
        value: int
        prev: Marble
        next: Marble

const 
    nbPlayers = 428
    lastMarbleNumber = 70825*100 #Remove * 100 for part 1

var
    playersScore: array[nbPlayers, int]
    currentMarble = Marble(value:0)
    currentValue = 1
    currentPlayer = 1

currentMarble.prev = currentMarble
currentMarble.next = currentMarble

proc addMarble(center: Marble): Marble = 
    result = Marble(value: currentValue)
    if center.value == 0:
        result.next = center
        result.prev = center
        center.next = result
        center.prev = result
    else:
        result.next = center.next.next
        result.prev = center.next
        center.next.prev = center
        center.next.next = result

proc removeMarble(marble: Marble) = 
    marble.prev.next = marble.next
    marble.next.prev = marble.prev

var turn = 1
while true:
    if currentMarble.value == lastMarbleNumber:
        break;
    currentPlayer = turn mod nbPlayers
    
    if currentValue mod 23 == 0:
        var seventPrevMarble = currentMarble.prev.prev.prev.prev.prev.prev.prev
        playersScore[currentPlayer] = playersScore[currentPlayer] + currentValue
        playersScore[currentPlayer] = playersScore[currentPlayer] + seventPrevMarble.value
        currentMarble = seventPrevMarble.next
        removeMarble(seventPrevMarble)
    else:
        currentMarble = addMarble(currentMarble)

    currentValue = currentValue + 1
    turn = turn + 1

var highScore = 0
var player = 0

for i, score in playersScore:
    if score > highScore:
        highScore = score
        player = i

echo player, " ", highScore