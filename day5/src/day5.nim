import strutils, sequtils, re
var input = readFile("src/input.txt")

proc explode(a: char, b: char): bool = 
    result = false
    if a.isLowerAscii and b.isUpperAscii and a.toLowerAscii == b.toLowerAscii:
        result = true
    if a.isUpperAscii and b.isLowerAscii and a.toLowerAscii == b.toLowerAscii:
        result = true
var unitBag: seq[string] = @[];

proc experiment(polymer:string): string = 
    var position = 0
    result = polymer
    while true:
        let nextIndex = position + 1
        if  nextIndex < result.len:
            let a = result[position]
            let b = result[nextIndex]
            if explode(a, b):
                unitBag.add(a & "")
                unitBag.add(b & "")
                result = result[0..position-1] & result[nextIndex+1..result.len-1]
                position = 0
            else:
                position = position + 1
        else:
            break
let 
    result1 = experiment(input)
    units = unitBag.deduplicate

echo result1.len
var length = 9999999
var result2 = ""
for unit in units:
    var candidate = input.replace(unit.toLowerAscii, "").replace(unit.toUpperAscii, "")
    var polymer = experiment(candidate) 
    if polymer.len < length:
        length = polymer.len
        result2 = polymer
echo result2.len
