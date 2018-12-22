import strutils, sequtils, os

type Rule = tuple[test:string, result: char]

const 
    input = "src/input.txt".readFile.splitLines
    #input = "src/test.txt".readFile.strip.splitLines
    pad = "....."
    initial = pad & input[0][15..input[0].len-1] & pad
    rules = input[2..input.len-1].mapIt((test:it[0..4], result: it[^1]))
    generations1 = 20
    generations = 100000 #Part 2 

func coundPlants(plants: string, index: int64): int64 = 
    for i, p in plants:
        if p == '#':
            result = result + (index + i - pad.len)

func grow(plants: string): string =
    result = plants & pad

    for i, p in result:
        var plant: string
        if i >= 2 and i <= plants.len - 3:
            plant = plants[i-2..i+2]
        elif i == 0:
            plant = ".." & plants[i..i+2]
        elif i == 1:
            plant = "." & plants[i-1..i+2]
        elif i == plants.len - 2:
            plant = plants[i-2..i+1] & "."
        elif i == plants.len - 1:
            plant = plants[i-2..i] & ".."
        
        result[i] = '.'
        for rule in rules:
            if rule.test == plant:
                result[i] = rule.result
                break

func getPlantSequence(plants: string): string =
    result = plants[plants.find("#")..plants.rfind("#")]    

var 
    plants = initial
    previous = ""
    index = 50000000000
# Part 1
for i in 1..generations1:
    plants = grow(plants)

echo coundPlants(plants, 0)

# Part two
plants = initial
for i in 1..generations:
    previous = getPlantSequence(plants)
    plants = grow(plants)
    #If the previous generation is equal to the next
    #It means the plant are stable
    if previous == getPlantSequence(plants):
        index = index - i #We find the initial plant index
        break

#Ask our counter to start at the index we want
echo coundPlants(plants, index)