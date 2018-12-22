import strutils, sequtils, tables, os

type Instruction = object
        opcode: int
        A: int #Input
        B: int #Input
        C: int #Output

func getRegisters(line: string): seq[int] =
    result = line.replace("Before: [", "").replace("After:  [", "").replace("]", "").split(", ").mapIt(it.parseInt)

func getInstruction(line: string): Instruction =
    var values = line.splitWhiteSpace.mapIt(it.parseInt)
    result = Instruction(opcode: values[0], A: values[1], B: values[2], C: values[3])

const 
    #input = "src/test.txt".readFile.strip.split("\n\n\n\n")
    input = "src/input.txt".readFile.strip.split("\n\n\n\n")
    part1 = input[0].splitLines
    part2 = if input.len == 2: input[1] else: ""

var 
    registers = @[0, 0, 0, 0]
    instructionIndex = 0
    opcodes = {
        "addr": proc(a:int, b:int, c:int) = registers[c] = registers[a] + registers[b],
        "addi": proc(a:int, b:int, c:int) = registers[c] = registers[a] + b,
        "mulr": proc(a:int, b:int, c:int) = registers[c] = registers[a] * registers[b],
        "muli": proc(a:int, b:int, c:int) = registers[c] = registers[a] * b,
        "banr": proc(a:int, b:int, c:int) = registers[c] = registers[a] and registers[b],
        "bani": proc(a:int, b:int, c:int) = registers[c] = registers[a] and b,
        "borr": proc(a:int, b:int, c:int) = registers[c] = registers[a] or registers[b],
        "bori": proc(a:int, b:int, c:int) = registers[c] = registers[a] or b,
        "setr": proc(a:int, b:int, c:int) = registers[c] = registers[a],
        "seti": proc(a:int, b:int, c:int) = registers[c] = a,
        "gtir": proc(a:int, b:int, c:int) = registers[c] = if a > registers[b]: 1 else: 0,
        "gtri": proc(a:int, b:int, c:int) = registers[c] = if registers[a] > b: 1 else: 0,
        "gtrr": proc(a:int, b:int, c:int) = registers[c] = if registers[a] > registers[b]: 1 else: 0,
        "eqir": proc(a:int, b:int, c:int) = registers[c] = if a == registers[b]: 1 else: 0,
        "eqri": proc(a:int, b:int, c:int) = registers[c] = if registers[a] == b: 1 else: 0,
        "eqrr": proc(a:int, b:int, c:int) = registers[c] = if registers[a] == registers[b]: 1 else: 0
    }.toTable

var totalAboveTwo = 0
var resultOpCodes = initTable[int, string]()
var opCodePossibleValues = initOrderedTable[int, seq[string]]()

while instructionIndex < part1.len:
    var 
        beginRegisters = getRegisters(part1[instructionIndex])
        instruction = getInstruction(part1[instructionIndex+1])
        endRegisters = getRegisters(part1[instructionIndex+2]).join
        possibleOperation: seq[string] = @[]
        
    for name, fn in opcodes.pairs:
        registers = beginRegisters
        fn(instruction.A, instruction.B, instruction.C)
        var result = $registers[0] & $registers[1] & $registers[2] & $registers[3]
        if result == endRegisters:
            possibleOperation.add(name)
        

    if opCodePossibleValues.hasKeyOrPut(instruction.opcode, possibleOperation):
        opCodePossibleValues[instruction.opcode] =  opCodePossibleValues[instruction.opcode].concat(possibleOperation).deduplicate

    if possibleOperation.len > 2:
        totalAboveTwo = totalAboveTwo + 1

    instructionIndex = instructionIndex + 4
echo totalAboveTwo

# Part two ---
var limit = 50

proc orderByLen(a, b: (int, seq[string])): int = cmp(a[1].len, b[1].len)

while resultOpCodes.len <= 16 and limit > 0:
    opCodePossibleValues.sort(orderByLen)
    
    for opCode, values in opCodePossibleValues.pairs:
        if values.len == 1:
            resultOpCodes[opCode] = values[0]
            for o, v in opCodePossibleValues.pairs:
                if resultOpCodes[opCode] in v:
                    opCodePossibleValues[o] = v.filterIt(resultOpCodes[opCode] != it)
            break
        else:
            for operationName in values:
                var found = false
                for o, v in opCodePossibleValues.pairs:
                    if o != opCode and operationName in v:
                        found = true
                if not found:
                    resultOpCodes[opCode] = operationName
                    opCodePossibleValues[opCode] = @[]
                    for o, v in opCodePossibleValues.pairs:
                        if resultOpCodes[opCode] in v:
                            opCodePossibleValues[o] = v.filterIt(resultOpCodes[opCode] != it)
                    break
            
    limit = limit - 1

registers = @[0, 0, 0, 0]
for line in part2.splitLines:
    let 
        ins = getInstruction(line)
        command = resultOpCodes[ins.opcode]
        fn = opcodes[command]
    fn(ins.A, ins.B, ins.C) 
    
echo registers[0]
