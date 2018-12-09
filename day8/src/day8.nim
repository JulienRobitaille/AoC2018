import strutils, sequtils, math

const input = "src/input.txt".readFile.strip.splitWhitespace

type Node = object
        children: seq[Node]
        meta: seq[int]

proc parseTree(input: seq[string]): Node = 
    var i = -1
    proc next(): int = 
        i = i + 1
        result = i
    
    proc findNodes(input: seq[string]): Node = 
        result = Node(children: @[], meta: @[])
        
        var 
            nbChild = input[next()].parseInt
            nbMeta = input[next()].parseInt

        if nbChild > 0:
            for round in 0..<nbChild:
                result.children.add(findNodes(input))
            
        for round in 0..<nbMeta:
            result.meta.add(input[next()].parseInt)
    
    result = findNodes(input)

proc part1(node: Node): int = 
    for child in node.children:
        result = result + part1(child)
    result = result + node.meta.sum

proc part2(node: Node): int = 
    if node.children.len > 0:
        for meta in node.meta:
            if node.children.len >= meta:
                result = result + part2(node.children[meta-1])
    else:
        result = node.meta.sum
    


var node = parseTree(input)

echo part1(node)
echo part2(node)