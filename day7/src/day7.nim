import strutils, sequtils, tables, algorithm, system, os

const instructions = readFile("src/input.txt").strip.splitLines
#[const instructions = """Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.""".strip.splitLines]#


type Node = ref object
        name: string
        parents: seq[Node]
        children: seq[Node]

var nodeTable = initTable[string, Node]()    

for instruction in instructions:
    var 
        data = instruction.splitWhitespace
        pid = data[1]
        cid = data[7]
        parentNode = if nodeTable.hasKey(pid): nodeTable[pid] else: Node(name: pid, children: @[], parents: @[])
        childNode = if nodeTable.hasKey(cid): nodeTable[cid] else: Node(name: cid, children: @[], parents: @[])
    
    parentNode.children.add(childNode)
    childNode.parents.add(parentNode)
    discard nodeTable.hasKeyOrPut(parentNode.name, parentNode)
    discard nodeTable.hasKeyOrPut(childNode.name, childNode)

proc sortNode(a: Node, b:Node): int = 
    result = if a.name > b.name: 1 else: 0

var nodes = sorted(toSeq(nodeTable.values), sortNode)
var timeSheet = initTable[string, int]()

for time, letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
    timeSheet[$letter] = time + 61

proc solve(nbWorkers: int): string = 
    result = ""
    var workers = nbWorkers
    var seconds = 0
    var workingOn: seq[Node] = @[]
    while nodes.len > 0 or workingOn.len > 0:

        for nodeName in result:
            for i, node in nodes:
                for i, parent in node.parents:
                    if parent.name == $nodeName:
                        node.parents.delete(i)

        for i, node in nodes:
            if node.parents.len == 0 and workers > 0:
                workers = workers - 1
                workingOn.add(node)
                nodes.delete(i)
    
        workingOn = sorted(workingOn, sortNode)      

        for i, node in workingOn:
            timeSheet[node.name] = timeSheet[node.name] - 1
            if timeSheet[node.name] <= 0:
                result.add(node.name)
                workers = workers + 1
        
        if workingOn.len > 0:
            seconds = seconds + 1

        workingOn = workingOn.filterIt(timeSheet[it.name] > 0)
            
    echo "Part 2 time: ", seconds

echo solve(5) #For part 1 use one worker